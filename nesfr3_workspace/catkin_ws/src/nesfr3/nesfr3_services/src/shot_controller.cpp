#include <std_msgs/String.h>
#include <std_msgs/Bool.h>
#include <string>
#include <geometry_msgs/Twist.h>
#include <std_msgs/Float64.h>
#include <std_msgs/Int32.h>
#include <nav_msgs/Odometry.h>

#include "nesfr3_services/shot_controller.hh"


#include <tf2/LinearMath/Quaternion.h>
#include <tf2/LinearMath/Matrix3x3.h>



#define camera_ratio 1
#define camera_z 1.65 //distance of the camera from the ground

#define BASE_DRIVE 0
#define SAFE_DRIVE 1


//the points are hardcoded as taking points from actor messages makes the camera shaky, but it is a viable option

#define MCU_CENTER 1.4 //approximately neck(the lower bound)
#define MCU_BOTTOM 1.2 //approximately chest(the lower bound)

#define MS_CENTER 1.35 //approximately a bit below the neck
#define MS_BOTTOM 1.0138 //approximately waist

#define MFS_CENTER 1.2 //approximately chest(the lower bound)
#define MFS_BOTTOM 0.48 //approximately knees

#define FS_CENTER 1.0138 //approximately waist
#define FS_BOTTOM 0 //approximately feet

//OFFSET can be directly integrated into the points above if needed
#define OFFSET 0.1

#define Ka 0.3
#define Kr 0.7

// TIME_RATIO is ratio of attenuation of velocity over time
#define TIME_RATIO 0.7

int drive_mode = SAFE_DRIVE;

ros::Time stop_time;
ros::Time current_time;
double position_x;
double position_y;
double orientation_x;
double orientation_y;
double orientation_z;
double orientation_w;

int execute = 0;

namespace nesfr3_services {

	ShotController::ShotController(uint32_t robot_id) 
	{
		this->service_server = this->nh.advertiseService("shot_cmd", &ShotController::Follow, this);
		this->robot_id = robot_id;
	}



	bool ShotController::Follow(nesfr3_services::FollowActor::Request &req, 
								nesfr3_services::FollowActor::Response &res)
	{
		if (req.shot_size != "FS" && 
			req.shot_size != "MFS" && 
			req.shot_size != "MS" && 
			req.shot_size != "MCU" && 
			req.shot_size != "CU" && 
			req.shot_size != "ECU")
		{
			ROS_ERROR("Please choose shot_size to be one of FS, MFS, MS, MCU, CU, or ECU.");
			return false;
		}


		this->actor_id = req.actor_id;
		this->robot_id = req.robot_id;
		this->desired_distance = req.distance;
		this->desired_angle = req.angle;
		this->shot_size = req.shot_size;
		this->use_gt = req.use_gt;


		this->desired_angle -= M_PI / 2;


		ShotController::NormalizeAngle(this->desired_angle);

		this->actors_sub = this->nh.subscribe("/nesfr3/" + std::to_string(this->robot_id) + "/Actors", 1, &ShotController::ActorsCallback, this);
		this->actor_sub = this->nh.subscribe("/gazebo/Actor/" + std::to_string(this->actor_id), 1, &ShotController::ActorCallback, this);
		this->new_id_sub = this->nh.subscribe("/nesfr3/" + std::to_string(this->robot_id) + "/new_id", 1, &ShotController::NewIdCallback, this);
		std::string ns = "/nesfr3/" + std::to_string(this->robot_id); 

		this->robot_sub = this->nh.subscribe(ns + "/wheel_odom", 1, &ShotController::OdomCallback, this);
		this->gimbal_pub = this->nh.advertise<geometry_msgs::Twist>(ns + "/gimbal/cmd_pos", 1);
		this->hfov_pub = this->nh.advertise<std_msgs::Float64>(ns + "/main_camera/set_hfov", 1);
		this->state_pub = this->nh.advertise<std_msgs::Int32>(ns + "/state", 1);
		this->id_pub = this->nh.advertise<std_msgs::Int32>(ns + "/id", 1);
		switch(drive_mode) {
		    case SAFE_DRIVE:
		        ROS_INFO("SAFE DRIVE MODE");
		        this->driver_ = new nesfr3_teleop::SafeDrive(this->robot_id);
		        break;
		    default:
		        ROS_INFO("BASE DRIVE MODE");
		        this->driver_ = new nesfr3_teleop::BaseDrive(this->robot_id);
		        break;
		}

		
		return true;
	}
	void ShotController::NewIdCallback(const std_msgs::Int32::ConstPtr &msg)
	{
		this->actor_id = uint32_t(msg->data);
	}

	void ShotController::ActorCallback(const nesfr3_msgs::Actor::ConstPtr &msg)
	{
		if (this->use_gt != 1) return;
		ignition::math::Vector2d actor_pos(msg->pose.pose.position.x, 
										   msg->pose.pose.position.y);

		ros::Time now = msg->header.stamp;

		double dt = (now - this->last_actor_update).nsec / pow(10, 9);

		if (dt > 0.00001)
		{
			if (dt < 2)
				this->actor_speed = this->last_actor_pos.Distance(actor_pos) / dt;

			this->last_actor_pos = actor_pos;
    		this->last_actor_update = now;
		}

		double actor_yaw = ShotController::GetYaw(
			msg->pose.pose.orientation.x, 
			msg->pose.pose.orientation.y, 
			msg->pose.pose.orientation.z, 
			msg->pose.pose.orientation.w);

		double global_angle = this->desired_angle + actor_yaw;

		ignition::math::Vector2d offset(this->desired_distance * cos(global_angle), 
										this->desired_distance * sin(global_angle));
		
		ignition::math::Vector2d desired_pos = actor_pos + offset;
		ignition::math::Vector2d straight_path = desired_pos - this->robot_pos;
		ignition::math::Vector2d robot_to_actor = actor_pos - this->robot_pos;

		ignition::math::Vector2d total_vel;

		if (straight_path.Length() < 0.5) // if the robot is already continuously following
		{
			//make the velocity relative to base_link since cmd_vel is applied relative to it
			total_vel.Set(cos(-this->robot_yaw) * straight_path.X() - sin(-this->robot_yaw) * straight_path.Y(),
						  sin(-this->robot_yaw) * straight_path.X() + cos(-this->robot_yaw) * straight_path.Y());
			total_vel.Normalize();
			total_vel *= (this->actor_speed + straight_path.Length() / 2);
			// robot is always slightly behind, (straight_path.Length() / 2) tries to catch up faster 
		} else {

			//two opposite tangent vectors to the robot_to_actor radius
			ignition::math::Vector2d tan_1(robot_to_actor.Y(),
					  					   -robot_to_actor.X());

			ignition::math::Vector2d tan_2(-robot_to_actor.Y(),
					  					   robot_to_actor.X());


			ignition::math::Vector2d arc_vel;

			//choose the shortest arc
			//the tangent vector having angle < 90 degree with the straight path is the shortest direction
			if (straight_path.Dot(tan_1) > 0)
			{
				arc_vel = tan_1;
			} else {
				arc_vel = tan_2;
			}
			
			arc_vel.Normalize();
			arc_vel = Ka * straight_path.Length() * arc_vel;


			ignition::math::Vector2d radial_vel = Kr * robot_to_actor * (1.0 - this->desired_distance / robot_to_actor.Length());

			ignition::math::Vector2d world_total_vel = arc_vel + radial_vel;


			//make the velocity relative to base_link since cmd_vel is applied relative to it
			total_vel.Set(cos(-this->robot_yaw) * world_total_vel.X() - sin(-this->robot_yaw) * world_total_vel.Y(),
						  sin(-this->robot_yaw) * world_total_vel.X() + cos(-this->robot_yaw) * world_total_vel.Y());

			if (total_vel.Length() < 1)
			{
				total_vel.Normalize();
				total_vel *= 1.5;
			}	
		}


		geometry_msgs::Twist cmd_vel;

		cmd_vel.linear.x = total_vel.X(); 
		cmd_vel.linear.y = total_vel.Y();

		double desired_robot_yaw = atan2(robot_to_actor.Y(), robot_to_actor.X());

		cmd_vel.angular.z = desired_robot_yaw - this->robot_yaw;

		ShotController::NormalizeAngle(cmd_vel.angular.z);

		double center_point_height = 1; //must be overwritten
		double center_to_bottom = 1; //must be overwritten

		//actually not quite sure why OFFSET is needed, calculations seem to be correct
		
		if (this->shot_size == "ECU") { // this is too hard, if not impossible, to calibrate due to robot's inertia. Please don't use.
			center_point_height = (msg->points[0].point.z + (msg->points[1].point.z + msg->points[2].point.z) / 2) / 2 - 0.8 * OFFSET;
			center_to_bottom = center_point_height - (msg->points[0].point.z - OFFSET); 

		} else if (this->shot_size == "CU") { 
			center_point_height = msg->points[0].point.z - OFFSET; //nose point
			center_to_bottom = msg->points[0].point.z - (msg->points[5].point.z + msg->points[6].point.z) / 2;
														//bottom is taken to be arithmetic mean of shoulder heights 
		} else if (this->shot_size == "MCU") { 
			center_point_height = MCU_CENTER - 0.8 * OFFSET;
			center_to_bottom = MCU_CENTER - (MCU_BOTTOM - 1.3 * OFFSET); 
		} else if (this->shot_size == "MS") {  
			center_point_height = MS_CENTER;
			center_to_bottom = MS_CENTER - (MS_BOTTOM - 1.5 * OFFSET); 
		} else if (this->shot_size == "MFS") { 
			center_point_height = MFS_CENTER - OFFSET;  
			center_to_bottom = MFS_CENTER - MFS_BOTTOM; 
		} else if (this->shot_size == "FS") { 
			center_point_height = FS_CENTER - OFFSET; 
			center_to_bottom = FS_CENTER - FS_BOTTOM; 
		} 
		

		double desired_gimbal_tilt = atan2(camera_z - center_point_height, robot_to_actor.Length()); 
		double desired_gimbal_pan = atan2(robot_to_actor.Y(), robot_to_actor.X()) - this->robot_yaw;	
		ShotController::NormalizeAngle(desired_gimbal_pan);

		double desired_vfov = 2 * (atan(center_to_bottom / robot_to_actor.Length() + tan(desired_gimbal_tilt)) - desired_gimbal_tilt);
		double desired_hfov = desired_vfov; //change it to one of the below if the camera ratio ever changes
		
		// double desired_hfov = 2 * atan(tan(desired_vfov / 2) * camera_ratio); //since camera_ratio = 1, desired_hfov = desired_vfov
		// double desired_hfov = 2 * atan2(tan(desired_vfov / 2), 1 / camera_ratio);

		geometry_msgs::Twist cmd_pos;
		cmd_pos.angular.y = desired_gimbal_tilt;
		cmd_pos.angular.z = desired_gimbal_pan;


        std_msgs::Float64 cmd_hfov;
        cmd_hfov.data = desired_hfov;
		

		switch(drive_mode){
            case BASE_DRIVE:
                this->driver_->drive(cmd_vel);
                break;
            case SAFE_DRIVE:
                nesfr3_teleop::SafeDrive *driver = dynamic_cast<nesfr3_teleop::SafeDrive *>(this->driver_);
                driver->drive(cmd_vel);
                break;
        }

        this->gimbal_pub.publish(cmd_pos);
        this->hfov_pub.publish(cmd_hfov);
        
        
	}

	void ShotController::ActorsCallback(const nesfr3_msgs::Actors::ConstPtr &msgs)
	{	
		
		if (this->use_gt != 0) return;
		int i;
		for(i=0;i<msgs->actors.size();i+=1)
		{
			if ( msgs->actors[i].tracking_id == int(this->actor_id))
			{
				std_msgs::Int32 id_msg;
				id_msg.data = int(this->actor_id);
				std_msgs::Int32 state_msg;
				state_msg.data = 1;
				this->id_pub.publish(id_msg);
				this->state_pub.publish(state_msg);
				stop_time = ros::Time::now() + ros::Duration(1);
				const nesfr3_msgs::Actor *msg = &msgs->actors[i];

				position_x = msg->pose.pose.position.x;
				position_y = msg->pose.pose.position.y;
				orientation_x =	msg->pose.pose.orientation.x;
				orientation_y = msg->pose.pose.orientation.y;
				orientation_z = msg->pose.pose.orientation.z; 
				orientation_w =	msg->pose.pose.orientation.w;

				execute = 1;
				ignition::math::Vector2d actor_pos(msg->pose.pose.position.x, 
												msg->pose.pose.position.y);

				ros::Time now = msg->header.stamp;

				double dt = (now - this->last_actor_update).nsec / pow(10, 9);

				if (dt > 0.00001)
				{
					if (dt < 2)
						this->actor_speed = this->last_actor_pos.Distance(actor_pos) / dt;

					this->last_actor_pos = actor_pos;
					this->last_actor_update = now;
				}

				double actor_yaw = ShotController::GetYaw(
					msg->pose.pose.orientation.x, 
					msg->pose.pose.orientation.y, 
					msg->pose.pose.orientation.z, 
					msg->pose.pose.orientation.w);

				double global_angle = this->desired_angle + actor_yaw;

				ignition::math::Vector2d offset(this->desired_distance * cos(global_angle), 
												this->desired_distance * sin(global_angle));
				
				ignition::math::Vector2d desired_pos = actor_pos + offset;
				ignition::math::Vector2d straight_path = desired_pos - this->robot_pos;
				ignition::math::Vector2d robot_to_actor = actor_pos - this->robot_pos;

				ignition::math::Vector2d total_vel;

				if (straight_path.Length() < 0.5) // if the robot is already continuously following
				{
					//make the velocity relative to base_link since cmd_vel is applied relative to it
					total_vel.Set(cos(-this->robot_yaw) * straight_path.X() - sin(-this->robot_yaw) * straight_path.Y(),
								sin(-this->robot_yaw) * straight_path.X() + cos(-this->robot_yaw) * straight_path.Y());
					total_vel.Normalize();
					total_vel *= (this->actor_speed + straight_path.Length() / 2);
					// robot is always slightly behind, (straight_path.Length() / 2) tries to catch up faster 
				} else {

					//two opposite tangent vectors to the robot_to_actor radius
					ignition::math::Vector2d tan_1(robot_to_actor.Y(),
												-robot_to_actor.X());

					ignition::math::Vector2d tan_2(-robot_to_actor.Y(),
												robot_to_actor.X());


					ignition::math::Vector2d arc_vel;

					//choose the shortest arc
					//the tangent vector having angle < 90 degree with the straight path is the shortest direction
					if (straight_path.Dot(tan_1) > 0)
					{
						arc_vel = tan_1;
					} else {
						arc_vel = tan_2;
					}
					
					arc_vel.Normalize();
					arc_vel = Ka * straight_path.Length() * arc_vel;


					ignition::math::Vector2d radial_vel = Kr * robot_to_actor * (1.0 - this->desired_distance / robot_to_actor.Length());

					ignition::math::Vector2d world_total_vel = arc_vel + radial_vel;


					//make the velocity relative to base_link since cmd_vel is applied relative to it
					total_vel.Set(cos(-this->robot_yaw) * world_total_vel.X() - sin(-this->robot_yaw) * world_total_vel.Y(),
								sin(-this->robot_yaw) * world_total_vel.X() + cos(-this->robot_yaw) * world_total_vel.Y());

					if (total_vel.Length() < 1)
					{
						total_vel.Normalize();
						total_vel *= 1.5;
					}	
				}


				geometry_msgs::Twist cmd_vel;

				cmd_vel.linear.x = total_vel.X(); 
				cmd_vel.linear.y = total_vel.Y();

				double desired_robot_yaw = atan2(robot_to_actor.Y(), robot_to_actor.X());

				cmd_vel.angular.z = desired_robot_yaw - this->robot_yaw;
				ShotController::NormalizeAngle(cmd_vel.angular.z);

				double center_point_height = 1; //must be overwritten
				double center_to_bottom = 1; //must be overwritten

				//actually not quite sure why OFFSET is needed, calculations seem to be correct
				
				if (this->shot_size == "ECU") { // this is too hard, if not impossible, to calibrate due to robot's inertia. Please don't use.
					center_point_height = (msg->points[0].point.z + (msg->points[1].point.z + msg->points[2].point.z) / 2) / 2 - 0.8 * OFFSET;
					center_to_bottom = center_point_height - (msg->points[0].point.z - OFFSET); 

				} else if (this->shot_size == "CU") { 
					center_point_height = msg->points[0].point.z - OFFSET; //nose point
					center_to_bottom = msg->points[0].point.z - (msg->points[5].point.z + msg->points[6].point.z) / 2;
																//bottom is taken to be arithmetic mean of shoulder heights 
				} else if (this->shot_size == "MCU") { 
					center_point_height = MCU_CENTER - 0.8 * OFFSET;
					center_to_bottom = MCU_CENTER - (MCU_BOTTOM - 1.3 * OFFSET); 
				} else if (this->shot_size == "MS") {  
					center_point_height = MS_CENTER;
					center_to_bottom = MS_CENTER - (MS_BOTTOM - 1.5 * OFFSET); 
				} else if (this->shot_size == "MFS") { 
					center_point_height = MFS_CENTER - OFFSET;  
					center_to_bottom = MFS_CENTER - MFS_BOTTOM; 
				} else if (this->shot_size == "FS") { 
					center_point_height = FS_CENTER - OFFSET; 
					center_to_bottom = FS_CENTER - FS_BOTTOM; 
				} 
				

				double desired_gimbal_tilt = atan2(camera_z - center_point_height, robot_to_actor.Length()); 
				double desired_gimbal_pan = atan2(robot_to_actor.Y(), robot_to_actor.X()) - this->robot_yaw;	
				ShotController::NormalizeAngle(desired_gimbal_pan);

				double desired_vfov = 2 * (atan(center_to_bottom / robot_to_actor.Length() + tan(desired_gimbal_tilt)) - desired_gimbal_tilt);
				double desired_hfov = desired_vfov; //change it to one of the below if the camera ratio ever changes
				
				// double desired_hfov = 2 * atan(tan(desired_vfov / 2) * camera_ratio); //since camera_ratio = 1, desired_hfov = desired_vfov
				// double desired_hfov = 2 * atan2(tan(desired_vfov / 2), 1 / camera_ratio);

				geometry_msgs::Twist cmd_pos;
				cmd_pos.angular.y = desired_gimbal_tilt;
				cmd_pos.angular.z = desired_gimbal_pan;


				std_msgs::Float64 cmd_hfov;
				cmd_hfov.data = desired_hfov;
				

				switch(drive_mode){
					case BASE_DRIVE:
						this->driver_->drive(cmd_vel);
						break;
					case SAFE_DRIVE:
						nesfr3_teleop::SafeDrive *driver = dynamic_cast<nesfr3_teleop::SafeDrive *>(this->driver_);
						driver->drive(cmd_vel);
						break;
				}

				this->gimbal_pub.publish(cmd_pos);
				this->hfov_pub.publish(cmd_hfov);
				return;
			}

		}
	    current_time = ros::Time::now();

		// If there are no command during 1 second, nesfr3 automatically stops. 
		if (this->use_gt != 1 && execute == 1){
			if(stop_time < current_time){
				geometry_msgs::Twist cmd_vel;
				std_msgs::Int32 state_msg;
				state_msg.data = 0;
				this->state_pub.publish(state_msg);
				cmd_vel.linear.x = 0;
				cmd_vel.linear.y = 0;
				cmd_vel.angular.z = 0;
				ShotController::NormalizeAngle(cmd_vel.angular.z);

				switch(drive_mode){
					case BASE_DRIVE:
						this->driver_->drive(cmd_vel);
						break;
					case SAFE_DRIVE:
						nesfr3_teleop::SafeDrive *driver = dynamic_cast<nesfr3_teleop::SafeDrive *>(this->driver_);
						driver->drive(cmd_vel);
						break;
				}		    
			}
			else{
				ignition::math::Vector2d actor_pos(position_x, position_y);

				double actor_yaw = ShotController::GetYaw(
					orientation_x, 
					orientation_y, 
					orientation_z, 
					orientation_w);

				double global_angle = this->desired_angle + actor_yaw;

				ignition::math::Vector2d offset(this->desired_distance * cos(global_angle), 
												this->desired_distance * sin(global_angle));
				
				ignition::math::Vector2d desired_pos = actor_pos + offset;
				ignition::math::Vector2d straight_path = desired_pos - this->robot_pos;
				ignition::math::Vector2d robot_to_actor = actor_pos - this->robot_pos;

				ignition::math::Vector2d total_vel;

				if (straight_path.Length() < 0.5) // if the robot is already continuously following
				{
					//make the velocity relative to base_link since cmd_vel is applied relative to it
					total_vel.Set(cos(-this->robot_yaw) * straight_path.X() - sin(-this->robot_yaw) * straight_path.Y(),
								sin(-this->robot_yaw) * straight_path.X() + cos(-this->robot_yaw) * straight_path.Y());
					total_vel.Normalize();
					total_vel *= (this->actor_speed + straight_path.Length() / 2);
					// robot is always slightly behind, (straight_path.Length() / 2) tries to catch up faster 
				} else {

					//two opposite tangent vectors to the robot_to_actor radius
					ignition::math::Vector2d tan_1(robot_to_actor.Y(),
												-robot_to_actor.X());

					ignition::math::Vector2d tan_2(-robot_to_actor.Y(),
												robot_to_actor.X());


					ignition::math::Vector2d arc_vel;

					//choose the shortest arc
					//the tangent vector having angle < 90 degree with the straight path is the shortest direction
					if (straight_path.Dot(tan_1) > 0)
					{
						arc_vel = tan_1;
					} else {
						arc_vel = tan_2;
					}
					
					arc_vel.Normalize();
					arc_vel = Ka * straight_path.Length() * arc_vel;


					ignition::math::Vector2d radial_vel = Kr * robot_to_actor * (1.0 - this->desired_distance / robot_to_actor.Length());

					ignition::math::Vector2d world_total_vel = arc_vel + radial_vel;


					//make the velocity relative to base_link since cmd_vel is applied relative to it
					total_vel.Set(cos(-this->robot_yaw) * world_total_vel.X() - sin(-this->robot_yaw) * world_total_vel.Y(),
								sin(-this->robot_yaw) * world_total_vel.X() + cos(-this->robot_yaw) * world_total_vel.Y());

					if (total_vel.Length() < 1)
					{
						total_vel.Normalize();
						total_vel *= 1.5;
					}	
				}

				geometry_msgs::Twist cmd_vel;

				cmd_vel.linear.x = total_vel.X(); 
				cmd_vel.linear.y = total_vel.Y();

				double desired_robot_yaw = atan2(robot_to_actor.Y(), robot_to_actor.X());

				cmd_vel.angular.z = desired_robot_yaw - this->robot_yaw;
				ShotController::NormalizeAngle(cmd_vel.angular.z);				

				switch(drive_mode){
					case BASE_DRIVE:
						this->driver_->drive(cmd_vel);
						break;
					case SAFE_DRIVE:
						nesfr3_teleop::SafeDrive *driver = dynamic_cast<nesfr3_teleop::SafeDrive *>(this->driver_);
						driver->drive(cmd_vel);
						break;
				}
			}
		}
	}

	void ShotController::OdomCallback(const nav_msgs::Odometry::ConstPtr &msg)
	{	
		current_time = ros::Time::now();

		if(stop_time < current_time){
			geometry_msgs::Twist cmd_vel;
			std_msgs::Int32 state_msg;
			state_msg.data = 0;
			this->state_pub.publish(state_msg);
			cmd_vel.linear.x = 0;
			cmd_vel.linear.y = 0;
			cmd_vel.angular.z = 0;
			ShotController::NormalizeAngle(cmd_vel.angular.z);

			switch(drive_mode){
				case BASE_DRIVE:
					this->driver_->drive(cmd_vel);
					break;
				case SAFE_DRIVE:
					nesfr3_teleop::SafeDrive *driver = dynamic_cast<nesfr3_teleop::SafeDrive *>(this->driver_);
					driver->drive(cmd_vel);
					break;
			}		    
		}
		
		this->robot_pos.X() = msg->pose.pose.position.x;
		this->robot_pos.Y() = msg->pose.pose.position.y;

		this->robot_yaw = ShotController::GetYaw(
			msg->pose.pose.orientation.x, 
			msg->pose.pose.orientation.y, 
			msg->pose.pose.orientation.z, 
			msg->pose.pose.orientation.w);
	}

	inline double ShotController::GetYaw(double x, double y, double z, double w)
	{
		tf2::Quaternion q(x, y, z, w);
		tf2::Matrix3x3 m(q);
		double roll, pitch, yaw;
		m.getRPY(roll, pitch, yaw);

		return yaw;
	}

	inline double ShotController::NormalizeAngle(double &angle)
	{
		while (angle > M_PI)
			angle -= 2 * M_PI;

		while (angle < -M_PI)
			angle += 2 * M_PI;

		return angle;
	}
}


int main(int argc, char **argv)
{
	ros::init(argc, argv, "shot_controller_server");
	ros::Time::init();

	std::string ns = ros::this_node::getNamespace();

	uint32_t last_slash_index = 0;
	for (uint32_t i = 0; i < ns.size(); i++)
	{
		if (ns[i] == '/')
			last_slash_index = i;
	}

	uint32_t robot_id = std::stoi(ns.substr(last_slash_index + 1));

	nesfr3_services::ShotController shot_controller(robot_id);
	ros::spin();

	return 0;
}