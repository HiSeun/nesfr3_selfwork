#ifndef NESFR3_JOYSTICK_H
#define NESFR3_JOYSTICK_H
#include <ros/ros.h>
#include <pcl_ros/point_cloud.h>

#include <geometry_msgs/Twist.h>
#include <std_msgs/String.h>
#include <sensor_msgs/Joy.h>

#include "nesfr3_teleop/drive.h"

namespace nesfr3_teleop{
    class JoyStickController
    {
        public:
            JoyStickController(BaseDrive *driver);

        private:
            void joyCallback(const sensor_msgs::Joy::ConstPtr& joy);

            float target_hfov_;
            BaseDrive *driver_;

            ros::NodeHandle nh_;
            ros::Subscriber joy_sub_;
            ros::Publisher gimbal_pub_;
            ros::Publisher hfov_pub_;
    };
}
#endif
