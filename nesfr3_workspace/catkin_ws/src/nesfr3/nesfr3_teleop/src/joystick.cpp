#include "nesfr3_teleop/joystick.h"

#include <boost/foreach.hpp>
#include <boost/program_options.hpp>
#include <pcl/point_types.h>

#include <geometry_msgs/Twist.h>
#include <std_msgs/Float64.h>


#define HFOV_MIN 0.01
#define HFOV_MAX 3.1
#define LIN_VEL_MAX 10
#define ROT_VEL_MAX 3 //6.2830
#define GIMB_DUTY 0.01
#define ZOOM_DUTY 0.01

#define BASE_DRIVE 0
#define SAFE_DRIVE 1

int drive_mode = BASE_DRIVE;
int robot_to_control = 1;

namespace nesfr3_teleop{
    JoyStickController::JoyStickController(BaseDrive *driver)
    {
        target_hfov_ = 1.4;
        driver_ = driver;


        joy_sub_ = nh_.subscribe<sensor_msgs::Joy>("joy", 1, 
                &JoyStickController::joyCallback, this);

        std::string ns = "nesfr3/" + std::to_string(robot_to_control) + "/";
        gimbal_pub_ = nh_.advertise<geometry_msgs::Twist>(ns + "gimbal/cmd_pos", 1);
        hfov_pub_ = nh_.advertise<std_msgs::Float64>(ns + "main_camera/set_hfov", 1);
    }

    void JoyStickController::joyCallback(const sensor_msgs::Joy::ConstPtr& joy)
    {
        int stop = joy->buttons[2]; // X button
        geometry_msgs::Twist cmd_vel;

        if(stop) {
            // Make planar move command message
            float vel_x = 0;
            float vel_y = 0; //joy->axes[0];
            float rot_z = 0;
            cmd_vel.linear.x = 0;
            cmd_vel.linear.y = 0;
            cmd_vel.angular.z = 0;
        } else {
            // Make planar move command message
            float vel_x = joy->axes[1]; // left stick up/down
            float vel_y = joy->axes[0]; // left stick left/right
            float rot_z = joy->axes[2]; // right stick left/right
            cmd_vel.linear.x = LIN_VEL_MAX * vel_x;
            cmd_vel.linear.y = LIN_VEL_MAX * vel_y;
            cmd_vel.angular.z = ROT_VEL_MAX * rot_z;
        }

        // Make gimbal position message
        float pan = -joy->axes[6];
        float tilt = -joy->axes[7];
        geometry_msgs::Twist cmd_gimbal;
        cmd_gimbal.angular.y = -GIMB_DUTY * tilt;
        cmd_gimbal.angular.z = -GIMB_DUTY * pan;

        // Make zoom message
        int zoom_in = joy->buttons[7];
        int zoom_out = joy->buttons[6];
        target_hfov_ += ZOOM_DUTY * (zoom_out - zoom_in);
        if(target_hfov_ > HFOV_MAX)
            target_hfov_ = HFOV_MAX;
        if(target_hfov_ < HFOV_MIN)
            target_hfov_ = HFOV_MIN;
        std_msgs::Float64 cmd_hfov;
        cmd_hfov.data = target_hfov_;

        switch(drive_mode){
            case BASE_DRIVE:
                driver_->drive(cmd_vel);
                break;
            case SAFE_DRIVE:
                SafeDrive *driver = dynamic_cast<SafeDrive *>(driver_);
                driver->drive(cmd_vel);
                break;
        }
        gimbal_pub_.publish(cmd_gimbal);
        hfov_pub_.publish(cmd_hfov);
    }
}

int main(int argc, char** argv)
{    
    ros::init(argc, argv, "nesfr3_teleop");

    

    ros::param::get("/nesfr3_teleop_node/safe_drive", drive_mode);
    ros::param::get("/nesfr3_teleop_node/robot_to_control", robot_to_control);

    nesfr3_teleop::BaseDrive *driver;
    switch(drive_mode) {
        case SAFE_DRIVE:
            ROS_INFO("SAFE DRIVE MODE");
            driver = new nesfr3_teleop::SafeDrive(robot_to_control);
            break;
        default:
            ROS_INFO("BASE DRIVE MODE");
            driver = new nesfr3_teleop::BaseDrive(robot_to_control);
            break;
    }
    nesfr3_teleop::JoyStickController jscontrol(driver);
    ros::spin();
    return 0;
}
