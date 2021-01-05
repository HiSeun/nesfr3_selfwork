#ifndef GIMBAL_POS_PLUGIN_HH
#define GIMBAL_POS_PLUGIN_HH

#include <gazebo/common/common.hh>
#include <gazebo/physics/physics.hh>
#include <sdf/sdf.hh>

#include <geometry_msgs/Twist.h>
#include <ros/ros.h>
#include <ros/callback_queue.h>

namespace gazebo {

    class GimbalPosControl : public ModelPlugin {

        public: 
            GimbalPosControl();
            ~GimbalPosControl();
            void Load(physics::ModelPtr parent, sdf::ElementPtr sdf);

        protected:
            virtual void UpdateChild();
            virtual void FiniChild();

        private:

            physics::ModelPtr parent_;
            physics::LinkPtr camera_rotator_link;
            physics::LinkPtr camera_link;
            event::ConnectionPtr update_connection_;

            boost::shared_ptr<ros::NodeHandle> rosnode_;
            ros::Subscriber vel_sub_;

            std::string robot_namespace_;
            std::string command_topic_;
            std::string robot_camera_frame_;
            std::string camera_rotator_frame_;

            ros::CallbackQueue queue_;
            boost::thread callback_queue_thread_;
            void QueueThread();

            boost::mutex lock;

            void cmdVelCallback(const geometry_msgs::Twist::ConstPtr& cmd_msg);

            double cmd_tilt;
            double cmd_pan;

            double e_tilt_prev_ = 0.0;
            double e_pan_prev_ = 0.0;

            bool alive_;
    };
}

#endif