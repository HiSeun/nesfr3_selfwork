/*
 * Copyright 2015 Stefan Kohlbrecher, TU Darmstadt
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
*/

/*
 * Desc: Simple model controller that uses a twist message to exert
 *       forces on a robot, resulting in motion. Based on the
 *       planar_move plugin by Piyush Khandelwal.
 * Author: Stefan Kohlbrecher
 * Date: 06 August 2015
 */

#include "nesfr3_gazebo/planar_move_plugin.h"

namespace gazebo 
{

  GazeboRosForceBasedMove::GazeboRosForceBasedMove() {}

  GazeboRosForceBasedMove::~GazeboRosForceBasedMove() {}

  // Load the controller
  void GazeboRosForceBasedMove::Load(physics::ModelPtr parent,
      sdf::ElementPtr sdf) 
  {

    parent_ = parent;

    /* Parse parameters */

    robot_namespace_ = "";
    if (!sdf->HasElement("robotNamespace")) 
    {
      ROS_INFO("PlanarMovePlugin missing <robotNamespace>, "
          "defaults to \"%s\"", robot_namespace_.c_str());
    }
    else 
    {
      robot_namespace_ = 
        sdf->GetElement("robotNamespace")->Get<std::string>();
    }

    command_topic_ = "cmd_acc";
    if (!sdf->HasElement("commandTopic")) 
    {
      ROS_WARN("PlanarMovePlugin (ns = %s) missing <commandTopic>, "
          "defaults to \"%s\"", 
          robot_namespace_.c_str(), command_topic_.c_str());
    } 
    else 
    {
      command_topic_ = sdf->GetElement("commandTopic")->Get<std::string>();
    }

    odometry_topic_ = "odom";
    if (!sdf->HasElement("odometryTopic")) 
    {
      ROS_WARN("PlanarMovePlugin (ns = %s) missing <odometryTopic>, "
          "defaults to \"%s\"", 
          robot_namespace_.c_str(), odometry_topic_.c_str());
    } 
    else 
    {
      odometry_topic_ = sdf->GetElement("odometryTopic")->Get<std::string>();
    }

    odometry_frame_ = "odom";
    if (!sdf->HasElement("odometryFrame")) 
    {
      ROS_WARN("PlanarMovePlugin (ns = %s) missing <odometryFrame>, "
          "defaults to \"%s\"",
          robot_namespace_.c_str(), odometry_frame_.c_str());
    }
    else 
    {
      odometry_frame_ = sdf->GetElement("odometryFrame")->Get<std::string>();
    }

    // moment_of_inertia_ = 0.7574;
    // mass_of_robot_ = 21;
    
    moment_of_inertia_ = 0.12027;
    mass_of_robot_ = 7.032;

    // moment_of_inertia_ = 0.12027;
    // mass_of_robot_ = 15;

    robot_base_frame_ = "base_footprint";
    if (!sdf->HasElement("robotBaseFrame")) 
    {
      ROS_WARN("PlanarMovePlugin (ns = %s) missing <robotBaseFrame>, "
          "defaults to \"%s\"",
          robot_namespace_.c_str(), robot_base_frame_.c_str());
    } 
    else 
    {
      robot_base_frame_ = sdf->GetElement("robotBaseFrame")->Get<std::string>();
    }

    

    this->link_ = parent->GetLink(robot_base_frame_);

    odometry_rate_ = 500.0;
    if (!sdf->HasElement("odometryRate")) 
    {
      ROS_WARN("PlanarMovePlugin (ns = %s) missing <odometryRate>, "
          "defaults to %f",
          robot_namespace_.c_str(), odometry_rate_);
    } 
    else 
    {
      odometry_rate_ = sdf->GetElement("odometryRate")->Get<double>() * 1.2;
    } 

    this->publish_odometry_tf_ = true;
    if (!sdf->HasElement("publishOdometryTf")) {
      ROS_WARN("PlanarMovePlugin Plugin (ns = %s) missing <publishOdometryTf>, defaults to %s",
               this->robot_namespace_.c_str(), this->publish_odometry_tf_ ? "true" : "false");
    } else {
      this->publish_odometry_tf_ = sdf->GetElement("publishOdometryTf")->Get<bool>();
    }

    if (robot_namespace_ != "")
    {
      robot_base_frame_ = robot_namespace_ + "/" + robot_base_frame_;
      odometry_frame_ =  robot_namespace_ + "/" + odometry_frame_;

      GazeboRosForceBasedMove::RemoveDuplicateSlashes(robot_base_frame_);
      GazeboRosForceBasedMove::RemoveDuplicateSlashes(odometry_frame_);
      
    }

    ROS_INFO_STREAM("robotBaseFrame for force based move plugin: " << robot_base_frame_  << "\n");
 
    last_odom_publish_time_ = parent_->GetWorld()->SimTime();
    last_odom_pose_ = parent_->WorldPose();



    x_ = 0;
    y_ = 0;
    
    if (robot_namespace_ != "")
    {
      //the assumption is that the namespace is nesfr3/x (x is the index, e.g 2), 
      //and the origin is (x - 1), (x - 1) for nesfr3/x, which is specified in robots.launch
      double coord = std::stoi(robot_namespace_.substr(7)) - 1; 


      x_offset = coord;
      y_offset = coord;
    }


    rot_ = 0;
    alive_ = true;

    odom_transform_.setIdentity();

    // Ensure that ROS has been initialized and subscribe to cmd_vel
    if (!ros::isInitialized()) 
    {
      ROS_FATAL_STREAM("PlanarMovePlugin (ns = " << robot_namespace_
        << "). A ROS node for Gazebo has not been initialized, "
        << "unable to load plugin. Load the Gazebo system plugin "
        << "'libgazebo_ros_api_plugin.so' in the gazebo_ros package)");
      return;
    }
    rosnode_.reset(new ros::NodeHandle(robot_namespace_));

    ROS_DEBUG("OCPlugin (%s) has started!", 
        robot_namespace_.c_str());

    tf_prefix_ = tf::getPrefixParam(*rosnode_);

    if (publish_odometry_tf_)
      transform_broadcaster_.reset(new tf::TransformBroadcaster());

    // subscribe to the odometry topic
    ros::SubscribeOptions so =
      ros::SubscribeOptions::create<geometry_msgs::Twist>(command_topic_, 1,
          boost::bind(&GazeboRosForceBasedMove::cmdAccCallback, this, _1),
          ros::VoidPtr(), &queue_);

    vel_sub_ = rosnode_->subscribe(so);
    odometry_pub_ = rosnode_->advertise<nav_msgs::Odometry>(odometry_topic_, 1);

    // start custom queue for diff drive
    callback_queue_thread_ = 
      boost::thread(boost::bind(&GazeboRosForceBasedMove::QueueThread, this));

    // listen to the update event (broadcast every simulation iteration)
    update_connection_ = 
      event::Events::ConnectWorldUpdateBegin(
          boost::bind(&GazeboRosForceBasedMove::UpdateChild, this));

  }

  void inline GazeboRosForceBasedMove::RemoveDuplicateSlashes(std::string &name)
  {
    uint32_t tail = 0;
    bool active_tail = false;

    for (uint32_t i = 0; i < name.length(); i++)
    {

      if (name[i] == '/' && !active_tail)
      {
        active_tail = true;
        tail = i;
      } 

      if (name[i] != '/' && active_tail)
      {
        name.erase(tail, i - tail - 1);
        active_tail = false;
        i = tail + 1;
      }
    }

  }
  // Update the controller
  void GazeboRosForceBasedMove::UpdateChild()
  {
    boost::mutex::scoped_lock scoped_lock(lock);
    ignition::math::Pose3d pose = parent_->WorldPose();

    ignition::math::Vector3d angular_vel = parent_->WorldAngularVel();

    float torq =  rot_ * moment_of_inertia_; //limit 40 -> 10
    if(torq < -25)
        torq = -25;
    if(torq > 25)
        torq = 25;

    link_->AddRelativeTorque(ignition::math::Vector3d(0.0, 0.0, torq));

    float yaw = pose.Rot().Yaw();

    ignition::math::Vector3d linear_vel = parent_->RelativeLinearVel();

    ignition::math::Vector3d f = ignition::math::Vector3d(x_ * mass_of_robot_,
                                                          y_ * mass_of_robot_,
                                                          0.0);
    double magnitude = f.Length();
    if(magnitude > 80){ //limit 120 -> 70
        f = f * 80 / magnitude;
    } 
    link_->AddRelativeForce(f);

    if (odometry_rate_ > 0.0) {
      common::Time current_time = parent_->GetWorld()->SimTime();
      double seconds_since_last_update = 
        (current_time - last_odom_publish_time_).Double();
      if (seconds_since_last_update > (1.0 / odometry_rate_)) {
        publishOdometry(seconds_since_last_update);
        last_odom_publish_time_ = current_time;
      }
    }
  }

  // Finalize the controller
  void GazeboRosForceBasedMove::FiniChild() {
    alive_ = false;
    queue_.clear();
    queue_.disable();
    rosnode_->shutdown();
    callback_queue_thread_.join();
  }

  void GazeboRosForceBasedMove::cmdAccCallback(
      const geometry_msgs::Twist::ConstPtr& cmd_msg) 
  {
    boost::mutex::scoped_lock scoped_lock(lock);
    x_ = cmd_msg->linear.x;
    y_ = cmd_msg->linear.y;
    rot_ = cmd_msg->angular.z;
  }

  void GazeboRosForceBasedMove::QueueThread()
  {
    static const double timeout = 0.01;
    while (alive_ && rosnode_->ok()) 
    {
      queue_.callAvailable(ros::WallDuration(timeout));
    }
  }

  void GazeboRosForceBasedMove::publishOdometry(double step_time)
  {

    ros::Time current_time = ros::Time::now();
    std::string odom_frame = tf::resolve(tf_prefix_, odometry_frame_);
    std::string base_footprint_frame = 
      tf::resolve(tf_prefix_, robot_base_frame_);

    ignition::math::Vector3d angular_vel = parent_->RelativeAngularVel();
    ignition::math::Vector3d linear_vel = parent_->RelativeLinearVel();

    odom_transform_= odom_transform_ * this->getTransformForMotion(linear_vel.X(),
            linear_vel.Y(), angular_vel.Z(), step_time);

    tf::poseTFToMsg(odom_transform_, odom_.pose.pose);
    odom_.twist.twist.linear.x  = linear_vel.X();
    odom_.twist.twist.linear.y  = linear_vel.Y();
    odom_.twist.twist.angular.z = angular_vel.Z();

    odom_.header.stamp = ros::Time(parent_->GetWorld()->SimTime().sec, parent_->GetWorld()->SimTime().nsec);
    odom_.header.frame_id = odom_frame;
    odom_.child_frame_id = base_footprint_frame;

    if (transform_broadcaster_.get()){
      transform_broadcaster_->sendTransform(
          tf::StampedTransform(odom_transform_, current_time, odom_frame,
              base_footprint_frame));
    }
    
    odom_.pose.covariance[0] = 0.001;
    odom_.pose.covariance[7] = 0.001;
    odom_.pose.covariance[14] = 1000000000000.0;
    odom_.pose.covariance[21] = 1000000000000.0;
    odom_.pose.covariance[28] = 1000000000000.0;
    
    if (std::abs(angular_vel.Z()) < 0.0001) {
      odom_.pose.covariance[35] = 0.01;
    }else{
      odom_.pose.covariance[35] = 100.0;
    }

    odom_.twist.covariance[0] = 0.001;
    odom_.twist.covariance[7] = 0.001;
    odom_.twist.covariance[14] = 0.001;
    odom_.twist.covariance[21] = 1000000000000.0;
    odom_.twist.covariance[28] = 1000000000000.0;

    if (std::abs(angular_vel.Z()) < 0.0001) {
      odom_.twist.covariance[35] = 0.01;
    }else{
      odom_.twist.covariance[35] = 100.0;
    }

    odom_.pose.pose.position.x += x_offset;
    odom_.pose.pose.position.y += y_offset;

    odometry_pub_.publish(odom_);
  }


  tf::Transform GazeboRosForceBasedMove::getTransformForMotion(double linear_vel_x,
          double linear_vel_y, double angular_vel, double timeSeconds) const
  {
    tf::Transform tmp;
    tmp.setIdentity();


    if (std::abs(angular_vel) < 0.0001) {
      //Drive straight
      tmp.setOrigin(tf::Vector3(static_cast<double>(linear_vel_x*timeSeconds),
                                static_cast<double>(linear_vel_y*timeSeconds),
                                0.0));
    } else {
      //Follow circular arc
      double distChange = sqrt(pow(linear_vel_x, 2) + pow(linear_vel_y, 2)) * timeSeconds;
      double angleChange = angular_vel * timeSeconds;
      double arcRadius = distChange / angleChange;
      double tmp_x = std::sin(angleChange) * arcRadius;
      double tmp_y = arcRadius - std::cos(angleChange) * arcRadius;

      double initialAngle = atan2(linear_vel_y, linear_vel_x);
      double tf_x = tmp_x * cos(initialAngle) - tmp_y * sin(initialAngle);
      double tf_y = tmp_y * cos(initialAngle) + tmp_x * sin(initialAngle);
    


      tmp.setOrigin(tf::Vector3(tf_x, tf_y, 0.0));
      tmp.setRotation(tf::createQuaternionFromYaw(angleChange));
    }

    return tmp;
  }

  GZ_REGISTER_MODEL_PLUGIN(GazeboRosForceBasedMove)
}

