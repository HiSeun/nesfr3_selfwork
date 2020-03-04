- [**0. Overview**](#0-overview)
- [**1. nesfr_teleop_node**](#1-nesfrteleopnode)
- [**2. joy_node**](#2-joynode)
- [**3. gazebo**](#3-gazebo)
- [**4. joint_state_publisher**](#4-jointstatepublisher)
- [**5. robot_state_publisher**](#5-robotstatepublisher)
- [**6. cartographer_node**](#6-cartographernode)
- [**7. cartographer_occupancy_grid_node**](#7-cartographeroccupancygridnode)


## **0. Overview**
This document is for describe the main function of nodes in `nesfr3`.   
(actually this is a minimal nodes, there can be more than 7 when you apply human detection or something. *i.e.* `roslaunch nesfr3_gazebo nesfr3.launch`)  
Text in the elipse is node name and text in the inner box is topic name.
![nodes.png](/media/Topics.png)



## **1. nesfr_teleop_node**
0. Description   
    Package for a controlling nesfr3 with joystick. This node subcribes joystic information, environment information wrap around nesfr3(Pointclound via lidar) and wheel odometry. And publishes its velocity(angular and linear) and camera info(zoom and position) according to joystic command. It avoids collision when parameter `safe_drive` is set to `1`;

1. Subscribed topics
   - [`/joy` (sensor_msgs/Joy)](http://docs.ros.org/api/sensor_msgs/html/msg/Joy.html)
   - `/nesfr3/lidar/points` from `/gazebo`
   - `/nesfr3/wheel_odom` from `/gazebo`
2. Published topics
   - `/nesfr3/gimbal/cmd_pos`
   - `/nesfr3/main_camera/set_hfov`
   - `/nesfr3/cmd_acc`
3. Parameters
   - `safe_drive`: It decides whether nesfr3 cares obstacle or not (int, default: 1) 
4. Code snippet
   <details><summary>Camera gimbal and zoom</summary>
   <p>

   ```c++
   // nesfr3_teleop/src/joystick.cpp
    void JoyStickController::joyCallback(const sensor_msgs::Joy::ConstPtr& joy)
    {
        // Make planar move command message
        float vel_x = joy->axes[1];
        float vel_y = joy->axes[0];
        float rot_z = joy->axes[2];
        geometry_msgs::Twist cmd_vel;
        cmd_vel.linear.x = LIN_VEL_MAX * vel_x;
        cmd_vel.linear.y = LIN_VEL_MAX * vel_y;
        cmd_vel.angular.z = ROT_VEL_MAX * rot_z;

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
   ```

   </p>
   </details>


   <details><summary>Velocity</summary>
   <p>

   ```c++
   // nesfr3_teleop/src/drive.cpp
    void BaseDrive::drive(geometry_msgs::Twist cmd_vel)
    {
        geometry_msgs::Twist cmd_acc;  
        double e_x = cmd_vel.linear.x - vel_x_;
        double e_y = cmd_vel.linear.y - vel_y_;
        double e_z = cmd_vel.angular.z - rot_z_;
        double e_x_d = e_x - e_x_prev_;
        double e_y_d = e_y - e_y_prev_;
        double e_z_d = e_z - e_z_prev_;

        double cmd_x = e_x * LINEAR_kP * ODOM_RATE
                         + e_x_d * LINEAR_kD * ODOM_RATE;
        double cmd_y = e_y * LINEAR_kP * ODOM_RATE
                         + e_y_d * LINEAR_kD * ODOM_RATE;

        slipLess(cmd_x, cmd_y, &cmd_vel, &cmd_acc);

        cmd_acc.angular.z = e_z * ANGULAR_kP * ODOM_RATE
                          + e_z_d * ANGULAR_kD * ODOM_RATE;

        acc_pub_.publish(cmd_acc);
        e_x_prev_ = e_x;
        e_y_prev_ = e_y;
        e_z_prev_ = e_z;
    }
   ```

   </p>
   </details>

## **2. joy_node**
0. Description   
    ROS driver for a generic Linux joystick. The joy package contains `joy_node`, a node that interfaces a generic Linux joystick to ROS. This node publishes a "Joy" message, which contains the current state of each one of the joystick's buttons and axes. Please refer to the [official wiki](http://wiki.ros.org/joy) to get specific information.

1. Published topics
   - [`/joy` (sensor_msgs/Joy)](http://docs.ros.org/api/sensor_msgs/html/msg/Joy.html)
## **3. gazebo**
0. Description   
    Visualize tool. Please refer to [official wiki](http://wiki.ros.org/gazebo_ros) to get specific information.

1. Subscribed topics
   - `/nesfr3/gimbal/cmd_pos` from `/nesfr3_teleop_node`
   - `/nesfr3/main_camera/set_hfov` from `/nesfr_teleop_node`
   - `/nesfr3/cmd_acc` from `/nesfr_teleop_node`
2. Published topics
   - `/nesfr3/lidar/points`
   - `/nesfr3/lidar/imu/`
   - `/nesfr3/wheel_odom`

## **4. joint_state_publisher**
0. Description   
    This package publishes `sensor_msgs/JointState messages` for a robot. The package reads the `robot_description` parameter, finds all of the non-fixed joints and publishes a `JointState` message with all those joints defined. Can be used in conjunction with the `robot_state_publisher node to also publish transforms for all joint states. Please refer to [official wiki](http://wiki.ros.org/joint_state_publisher) to get specific information.

1. Published topics
   - [`/joint_status` (sensor_msgs/JointState)](http://docs.ros.org/api/sensor_msgs/html/msg/JointState.html)

## **5. robot_state_publisher**
0. Description   
    `robot_state_publisher` uses the URDF specified by the parameter `robot_description` and the joint positions from the topic joint_states to calculate the forward kinematics of the robot and publish the results via tf. Please refer to [official wiki](http://wiki.ros.org/robot_state_publisher) to get specific information.

1. Subscribed topics
   - `/joint_states` from `/joint_stae_publisher`

## **6. cartographer_node**
0. Description   
     Package for SLAM(Simultaneous localization and mapping). Please refer to [official wiki](http://wiki.ros.org/cartographer) to get specific information.

1. Subscribed topics
   - `/nesfr3/lidar/imu` from `/gazebo`
   - `/nesfr3/lidar/points` from `/nesfr3_teleop_node`
   - `/nesfr3/wheel_odom` from `/nesfr3_teleop_node`
2. Published topics
   - `/submap_list` [/cartographer_ros_msgs/SubmapList](https://github.com/googlecartographer/cartographer_ros/blob/master/cartographer_ros_msgs/msg/SubmapList.msg)

## **7. cartographer_occupancy_grid_node**
0. Description  
    Package for SLAM, but especially **mapping**. Please refer to [official wiki](https://google-cartographer-ros.readthedocs.io/en/latest/ros_api.html#occupancy-grid-node) to get specific information.
1. Subscribed topics
   - `/submap_list` from `/cartographer_node`
2. Published topics
   - `/nav_msgs/OccupancyGrid`

