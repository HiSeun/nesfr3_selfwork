#ifndef NESFR3_MEC_DRIVER_H
#define NESFR3_MEC_DRIVER_H
#include <boost/thread.hpp>
#include <linux/can.h>
#include <linux/can/raw.h>
#include <mutex>

#include <net/if.h>
#include <queue>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/types.h>

#include <ros/ros.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>
#include <tf/transform_broadcaster.h>
#include <tf/transform_listener.h>

namespace nesfr3_mecanum_driver{
    enum TractionStatus { ACCEL, OFF, DECEL };
    class MecanumDriver{
        public:
            MecanumDriver(uint32_t nesfr3_index);
            int initCanSock();
            void cmdCallback(const geometry_msgs::Twist::ConstPtr& msg);
            void readLoop();
            void publishOdom();
            void initOdom();

        private:
            ros::NodeHandle nh_;
            ros::Publisher odom_pub_;
            ros::Publisher wheel_pub_[4];
            ros::Subscriber cmd_sub_;
            tf::TransformBroadcaster odom_broadcaster_;
            long init_angle_[4] = {0};
            int can_fd_;

            std::atomic<int32_t> cmd_vel_[4] = {};
            std::atomic<long> motor_angle_[4] = {};
            std::atomic<short> motor_speed_[4] = {};
            std::atomic<short> motor_torque_[4] = {};
            std::atomic<float> normalized_vel_[4] = {};
            std::queue<short> motor_sp_q_[4]; 
            std::mutex rw_mutex_;
            float motor_acc_[4] = {0};
            int32_t throttle_[4] = {0};
            TractionStatus traction_stat_[4] = {OFF};
    };
}
#endif
