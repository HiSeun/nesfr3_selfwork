#include "nesfr3_gazebo/gimbal_pos_plugin.h"

#define kP 0.2
#define kI 0.05
#define kD 0.01
#define RATE 0.001

namespace gazebo
{

  GimbalPosControl::GimbalPosControl(){}

  GimbalPosControl::~GimbalPosControl(){}

  void  GimbalPosControl::Load(physics::ModelPtr parent,
      sdf::ElementPtr sdf)
  {

    parent_ = parent;

    robot_namespace_ = "";
    if (sdf->HasElement("robotNamespace"))
    {
      robot_namespace_ =
        sdf->GetElement("robotNamespace")->Get<std::string>();
    }
    
    command_topic_ = "cmd_pos";
    if (sdf->HasElement("commandTopic"))
    {
      command_topic_ = sdf->GetElement("commandTopic")->Get<std::string>();
    }


    camera_rotator_frame_ = "camera_rotator_link";
    if (sdf->HasElement("robotRotatorFrame"))
    {
      camera_rotator_frame_ = sdf->GetElement("cameraRotatorFrame")->Get<std::string>();
    }


    robot_camera_frame_ = "camera_link";
    if (sdf->HasElement("robotCameraFrame"))
    {
      robot_camera_frame_ = sdf->GetElement("robotCameraFrame")->Get<std::string>();
    }

    cmd_tilt = 0;
    cmd_pan = 0;
    alive_ = true;
    camera_link = parent_->GetLink(robot_camera_frame_);
    camera_rotator_link = parent_->GetLink(camera_rotator_frame_);

    if (!ros::isInitialized())
    {
      ROS_FATAL_STREAM_NAMED("planar_move", "GimbalPosPlugin (ns = " << robot_namespace_
        << "). A ROS node for Gazebo has not been initialized, "
        << "unable to load plugin. Load the Gazebo system plugin "
        << "'libgazebo_ros_api_plugin.so' in the gazebo_ros package)");
      return;
    }
    rosnode_.reset(new ros::NodeHandle(robot_namespace_));

    ROS_DEBUG_NAMED("gimbal_pos", "OCPlugin (%s) has started",
        robot_namespace_.c_str());

    ros::SubscribeOptions so =
      ros::SubscribeOptions::create<geometry_msgs::Twist>(command_topic_, 1,
          boost::bind(&GimbalPosControl::cmdVelCallback, this, _1),
          ros::VoidPtr(), &queue_);

    vel_sub_ = rosnode_->subscribe(so);


    callback_queue_thread_ =
      boost::thread(boost::bind(&GimbalPosControl::QueueThread, this));

    // listen to the update event (broadcast every simulation iteration)
    update_connection_ =
      event::Events::ConnectWorldUpdateBegin(
          boost::bind(&GimbalPosControl::UpdateChild, this));

  }


  void GimbalPosControl::UpdateChild()
  {
    boost::mutex::scoped_lock scoped_lock(lock);

    ignition::math::Pose3d rotator_pose = camera_rotator_link->WorldPose();
    ignition::math::Pose3d camera_pose = camera_link->WorldPose();   
    ignition::math::Pose3d camera_rotator_pose = camera_rotator_link->RelativePose();
 

    double current_tilt = camera_pose.Rot().Euler().Y();
    double e_tilt_ = cmd_tilt - current_tilt;
    double e_tilt_diff_ = e_tilt_ - e_tilt_prev_;
    double tilt_torque = e_tilt_ * kP
                       + e_tilt_ * kI * RATE 
                       + e_tilt_diff_ * kI * (1/RATE) ;

    e_tilt_prev_ = e_tilt_;

    double current_pan = camera_rotator_pose.Rot().Euler().Z();
    double e_pan_ = cmd_pan - current_pan;
    double e_pan_diff_ = e_pan_ - e_pan_prev_;
    double pan_torque = e_pan_ * kP
                      + e_pan_ * kI * RATE 
                      + e_pan_diff_ * kI * (1/RATE) ;

    e_pan_prev_ = e_pan_;

    camera_link->AddRelativeTorque(ignition::math::Vector3d(0, tilt_torque, pan_torque));

  }

  void GimbalPosControl::FiniChild() {
    alive_ = false;
    queue_.clear();
    queue_.disable();
    rosnode_->shutdown();
    callback_queue_thread_.join();
  } 

  void GimbalPosControl::cmdVelCallback(
      const geometry_msgs::Twist::ConstPtr& cmd_msg)
  {
    boost::mutex::scoped_lock scoped_lock(lock);
    cmd_tilt = cmd_msg->angular.y;
    cmd_pan = cmd_msg->angular.z;
  }

  void GimbalPosControl::QueueThread()
  {
    static const double timeout = 0.01;
    while (alive_ && rosnode_->ok())
    {
      queue_.callAvailable(ros::WallDuration(timeout));
    }
  }

  GZ_REGISTER_MODEL_PLUGIN(GimbalPosControl)
}