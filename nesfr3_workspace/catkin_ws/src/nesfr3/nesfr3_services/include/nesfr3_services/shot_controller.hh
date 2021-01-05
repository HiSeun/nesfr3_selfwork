#include <ros/ros.h>
#include <nesfr3_teleop/drive.h>
#include <nav_msgs/Odometry.h>
#include "nesfr3_msgs/Actor.h"
#include "nesfr3_msgs/Actors.h"
#include "nesfr3_services/FollowActor.h"
#include <ignition/math/Vector2.hh>



namespace nesfr3_services{

	class ShotController
	{
		public: ShotController(uint32_t robot_id);

		private: bool Follow(nesfr3_services::FollowActor::Request &req, 
							 nesfr3_services::FollowActor::Response &res);

		private: void NewIdCallback(const std_msgs::Int32::ConstPtr &msg);
		private: void ActorCallback(const nesfr3_msgs::Actor::ConstPtr &msg);
		private: void ActorsCallback(const nesfr3_msgs::Actors::ConstPtr &msgs);
		private: void OdomCallback(const nav_msgs::Odometry::ConstPtr &msg);

		public: inline double GetYaw(double x, double y, double z, double w);
		public: inline double NormalizeAngle(double &angle);

		ignition::math::Vector2d robot_pos;
		double robot_yaw;

		ignition::math::Vector2d last_actor_pos;
		double actor_speed;
		ros::Time last_actor_update;

		uint32_t actor_id;
		uint32_t robot_id;
		uint32_t use_gt;
		double desired_distance;
		double desired_angle;
		std::string shot_size;

		ros::NodeHandle nh;
		
		ros::ServiceServer service_server;

		ros::Subscriber actor_sub;
		ros::Subscriber actors_sub;
		ros::Subscriber robot_sub;
		ros::Subscriber gimbal_sub;
		ros::Subscriber new_id_sub;

		ros::Publisher gimbal_pub;
		ros::Publisher hfov_pub;
		ros::Publisher state_pub;
		ros::Publisher id_pub;
		nesfr3_teleop::BaseDrive *driver_;



	};
}