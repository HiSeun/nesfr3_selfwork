#include "nesfr3_teleop/drive.h"

#include <boost/foreach.hpp>
#include <cmath>
#include <Eigen/Core>
#include <Eigen/Geometry>
#include <pcl/common/transforms.h>
#include <pcl_conversions/pcl_conversions.h>

#include <std_msgs/Float64.h>

// Configured for simulation
// TODO: Separate config for simulation and real-world
#define ODOM_RATE 500.0
#define NESFR_RADIUS 0.5
#define MAX_ACC 6.0

#define NOT_FOUND 404
#define LINEAR_kP 16
#define LINEAR_kI 10
#define LINEAR_kD 0.1
#define ANGULAR_kP 16
#define ANGULAR_kI 10
#define ANGULAR_kD 0.1

#define RESPONSE_TIME 0.2

namespace nesfr3_teleop{
    BaseDrive::BaseDrive(uint32_t nesfr3_index)
    {   
        std::string ns = "/nesfr3/" + std::to_string(nesfr3_index); 
        acc_pub_ = nh_.advertise<geometry_msgs::Twist>(ns + "/cmd_acc", 1);
        vel_pub_ = nh_.advertise<geometry_msgs::Twist>(ns + "/cmd_vel", 1);
        odom_sub_ = nh_.subscribe<nav_msgs::Odometry>(ns + "/wheel_odom", 1,
                &BaseDrive::odomCallback, this);
    }

    void BaseDrive::odomCallback(const nav_msgs::Odometry::ConstPtr& msg)
    {
        vel_x_ = msg->twist.twist.linear.x;
        vel_y_ = msg->twist.twist.linear.y;
        rot_z_ = msg->twist.twist.angular.z;
        if(fabs(vel_x_) < 0.001)
            vel_x_ = 0;
        if(fabs(vel_y_) < 0.001)
            vel_y_ = 0;
        if(fabs(rot_z_) < 0.001)
            rot_z_ = 0;
        speed_ = sqrt(pow(vel_y_, 2) + pow(vel_x_, 2));
        move_dir_ = atan2(vel_y_, vel_x_);
    }

    // Tries to slip less
    void BaseDrive::slipLess(double cmd_x, double cmd_y,
            geometry_msgs::Twist *cmd_vel,
            geometry_msgs::Twist *cmd_acc)
    {
        // magnitude of cmd_vel
        double magnitude =
            sqrt((pow(cmd_vel->linear.x, 2) + pow(cmd_vel->linear.y, 2)));

        // magnitude of command vector
        double cmd_magnitude = sqrt((pow(cmd_x, 2) + pow(cmd_y, 2)));

        // magnitude of command vectors projection to cmd_vel's orthogonal vector
        // NOTE: Orthogonal vector of (x, y) = (-y, x)
        double proj_magnitude =
            (cmd_x * (-cmd_vel->linear.y) + cmd_y * (cmd_vel->linear.x))
            / magnitude;

        // 1. if joy message was 0, then there is no direction,
        //    so it doesn't need any slip handling mechanism
        // 2. if cmd_magnitude is less than MAX_ACC,
        //    we can already handle the direction within the allowed acc range
        if(magnitude == 0 || cmd_magnitude < MAX_ACC){
            cmd_acc->linear.x = cmd_x;
            cmd_acc->linear.y = cmd_y;
        }else{
            // otherwise, prioritize changing direction by giving the
            // setting the orthogonal projection to maximum
            cmd_acc->linear.x = proj_magnitude * (-cmd_vel->linear.y) / magnitude;
            cmd_acc->linear.y = proj_magnitude * cmd_vel->linear.x / magnitude;

            // and if we still have some space left, fill it with the
            // cmd_vel's direction
            if(proj_magnitude < MAX_ACC){
                cmd_acc->linear.x += cmd_vel->linear.x
                                  * (MAX_ACC - proj_magnitude) / magnitude;
                cmd_acc->linear.y += cmd_vel->linear.y
                                  * (MAX_ACC - proj_magnitude) / magnitude;
            }
        }
    }

    // PID-control of velocity using the feedback from odometry
    void BaseDrive::drive(geometry_msgs::Twist cmd_vel)
    {
        vel_pub_.publish(cmd_vel);

        geometry_msgs::Twist cmd_acc;  
        double e_x = cmd_vel.linear.x - vel_x_;
        double e_y = cmd_vel.linear.y - vel_y_;
        double e_z = cmd_vel.angular.z - rot_z_;
        double e_x_d = e_x - e_x_prev_;
        double e_y_d = e_y - e_y_prev_;
        double e_z_d = e_z - e_z_prev_;

        double cmd_x = e_x * LINEAR_kP
                     + e_x * LINEAR_kI * (1/ODOM_RATE) 
                     + e_x_d * LINEAR_kD * ODOM_RATE;
        double cmd_y = e_y * LINEAR_kP
                     + e_y * LINEAR_kI * (1/ODOM_RATE)
                     + e_y_d * LINEAR_kD * ODOM_RATE;

        slipLess(cmd_x, cmd_y, &cmd_vel, &cmd_acc);

        cmd_acc.angular.z = e_z * ANGULAR_kP
                          + e_z * ANGULAR_kI * (1/ODOM_RATE)
                          + e_z_d * ANGULAR_kD * ODOM_RATE;

        acc_pub_.publish(cmd_acc);
        e_x_prev_ = e_x;
        e_y_prev_ = e_y;
        e_z_prev_ = e_z;
    }

    SafeDrive::SafeDrive(uint32_t nesfr3_index) : BaseDrive::BaseDrive(nesfr3_index)
    {
        std::string ns = "/nesfr3/" + std::to_string(nesfr3_index); 

        closest_dist_ = NOT_FOUND;

        pcl_sub_ = nh_.subscribe<sensor_msgs::PointCloud2>(ns + "/lidar/points", 1,
                &SafeDrive::pclCallback, this);
        sleep(1);
        //maybe acc_pub_ and odom_pub_ don't need to be assigned here as it's already done in BaseDrive::BaseDrive
        acc_pub_ = nh_.advertise<geometry_msgs::Twist>(ns + "/cmd_acc", 1);
        odom_sub_ = nh_.subscribe<nav_msgs::Odometry>(ns + "/wheel_odom", 1,
                &SafeDrive::odomCallback, this);
        collision_pub_ = nh_.advertise<sensor_msgs::PointCloud2>(ns + "/pcl/collision", 1);
        expected_pub_ = nh_.advertise<sensor_msgs::PointCloud2>(ns + "/pcl/expected", 1);
    }

    // Saves the PointCloud into its member
    void SafeDrive::pclCallback(const sensor_msgs::PointCloud2::ConstPtr& msg)
    {
        pcl::PCLPointCloud2 *tmp_ptr = new pcl::PCLPointCloud2; 
        pcl::PCLPointCloud2ConstPtr cloudPtr(tmp_ptr);
        pcl_conversions::toPCL(*msg, *tmp_ptr);
        pcl::copyPointCloud(*tmp_ptr, cloud_);

        // Example of transforming the pcl from previous frame to predict next frame
        //double pose_x = pose_.position.x - prev_pose_.position.x;
        //double pose_y = pose_.position.y - prev_pose_.position.y;
        //Eigen::Matrix3f rot1 = Eigen::Quaternionf(prev_pose_.orientation.w,
        //                                 prev_pose_.orientation.x,
        //                                 prev_pose_.orientation.y,
        //                                 prev_pose_.orientation.z).toRotationMatrix();
        //Eigen::Matrix3f rot2 = Eigen::Quaternionf(pose_.orientation.w,
        //                                 pose_.orientation.x,
        //                                 pose_.orientation.y,
        //                                 pose_.orientation.z).toRotationMatrix();

        //Eigen::Matrix3f rot_mat = rot1 * rot2.inverse();

        //Eigen::Matrix4f transformation_mat;
        //transformation_mat.topLeftCorner(3,3) = rot_mat;
        //transformation_mat.col(3) << pose_x, pose_y, 0, 1;

        //pcl::PointCloud<pcl::PointXYZ>::Ptr
        //    src_cloud(new pcl::PointCloud<pcl::PointXYZ>);
        //pcl::fromPCLPointCloud2(prev_cloud_, *src_cloud);
        //pcl::PointCloud<pcl::PointXYZ>::Ptr
        //    out_cloud(new pcl::PointCloud<pcl::PointXYZ>);
        //pcl::transformPointCloud(
        //        *src_cloud,
        //        *out_cloud,
        //        transformation_mat
        //        );

        //sensor_msgs::PointCloud2 expected_msg;
        //pcl::PCLPointCloud2 expected_cloud;
        //pcl::toPCLPointCloud2(*out_cloud, expected_cloud);
        //pcl_conversions::moveFromPCL(expected_cloud, expected_msg);
        //expected_pub_.publish(expected_msg);

        //prev_cloud_ = cloud_;
        //prev_pose_ = pose_;
    }

    // Updates the last known state of robot, and publishes the predicted
    // collision points from current velocities.
    void SafeDrive::odomCallback(const nav_msgs::Odometry::ConstPtr& msg)
    {
        // update member variables
        BaseDrive::odomCallback(msg);

        //pose_ = msg->pose.pose;

        //std::vector<int> collided_indices;
        //double closest_dist =
        //    detectCollisionPts(vel_x_, vel_y_, rot_z_, collided_indices);

        //    closest_dist_ = closest_dist;

        //// copy the cloud and filter collision points,
        //// then publish
        //pcl::PCLPointCloud2 cloud_filtered;
        //pcl::copyPointCloud(cloud_, collided_indices, cloud_filtered);
        //sensor_msgs::PointCloud2 collision;
        //pcl_conversions::moveFromPCL(cloud_filtered, collision);
        //collision_pub_.publish(collision);
    }

    // Predicts path, publishes possible collision points in the future
    // and returns the closest obstacle distance.
    double SafeDrive::detectCollisionPts(double vel_x, double vel_y, double rot_z,
            std::vector<int> &collided_indices){
        double speed = sqrt(pow(vel_x, 2) + pow(vel_y, 2));
        pcl::PointCloud<pcl::PointXYZ>::Ptr
            temp_cloud(new pcl::PointCloud<pcl::PointXYZ>);
        pcl::fromPCLPointCloud2(cloud_,*temp_cloud);

        double closest_dist = NOT_FOUND;
        // if rotation speed is too low, approximate as straight movement
        // otherwise, use circular movement
        // NOTE: speed threshold is introduced to ignore noise when it's stationary 
        if (rot_z < 0.1 && speed > 0.15){
            int it = 0;
            for(auto pt : temp_cloud->points){
                if(pt.z < 0)
                    continue;
                // projects the point vector to orthogonal vector of (vel_x, vel_y)
                double dist_from_line =
                    fabs(vel_y * pt.x - vel_x * pt.y) / speed;

                // check if the point is in the way and save the index if true
                // NOTE: second condition is making sure the point is in the moving direction
                if(NESFR_RADIUS > dist_from_line
                && vel_x * pt.x + vel_y * pt.y > 0.0){
                    closest_dist =
                        std::min(closest_dist, sqrt(pow(pt.x,2) + pow(pt.y,2)));
                    collided_indices.push_back(it);
                }
                it++;
            }
        }else if(speed > 0.15){
            // find the radius of circular movement
            double path_radius = speed / rot_z;

            // find the vector that will transform the circle's center to (0, 0)
            // NOTE: after transforming all the points with this vector, we can express
            //       the circular path using 2 circles at the center
            double offset_x = vel_y * path_radius / speed;
            double offset_y = -vel_x * path_radius / speed;

            pcl::PointCloud<pcl::PointXYZ>::Ptr
                temp_cloud(new pcl::PointCloud<pcl::PointXYZ>);
            pcl::fromPCLPointCloud2(cloud_,*temp_cloud);

            int it = 0;
            for(auto pt : temp_cloud->points){
                if(pt.z < 0)
                    continue;
                // find distance from center of the point after transforming
                double dist_from_center =
                    sqrt(pow(pt.x + offset_x, 2) + pow(pt.y + offset_y, 2));

                // if it is less than outer radius and greater than inner radius,
                // we conclude that the point is in the way
                // NOTE: This circular approximation is ideal (ignores slipping),
                //       and it's far from reality.
                // TODO: Take slippage into account
                if(path_radius - NESFR_RADIUS < dist_from_center
                && path_radius + NESFR_RADIUS > dist_from_center
                && vel_x * pt.x + vel_y * pt.y > 0){
                    closest_dist =
                        std::min(closest_dist, sqrt(pow(pt.x,2) + pow(pt.y,2)));
                    collided_indices.push_back(it);
                }
                it++;
            }
        }
        return closest_dist;
    }

    // If there is obstacle in the cmd_vel direction, try redirecting it
    // otherwise, introduce speed limit to enforce safety
    void SafeDrive::avoidCollision(geometry_msgs::Twist *cmd_vel){
        double speed = sqrt(pow(cmd_vel->linear.x, 2) + pow(cmd_vel->linear.y, 2));

        std::vector<int> collided_indices;
        double closest_dist = detectCollisionPts(cmd_vel->linear.x,
                                                 cmd_vel->linear.y,
                                                 cmd_vel->angular.z,
                                                 collided_indices);

        // NOTE: 0.15 is introduced to take account of response time
        double safe_to_go = closest_dist - NESFR_RADIUS - 0.15;

        // determine speed limit
        // if too close, speed limit is 0
        // otherwise, speed_limit is calculated using (v1^2 - v0^2) = 2ad
        double speed_limit;
        if(safe_to_go <= 0)
            speed_limit = 0;
        else
            speed_limit = sqrt(2 * safe_to_go * MAX_ACC);
        
        // max speed reachable before next odom update
        // so even if speed is higher than that, it makes no difference
        double speed_max = speed_ + MAX_ACC / ODOM_RATE;

        // if obstacle was found, try to find a path around
        // otherwise, enforce the speed limit
        if(closest_dist != NOT_FOUND && speed > speed_limit){
            double dist_needed = 1.95 * pow(speed_max, 2) / 2 / MAX_ACC + NESFR_RADIUS + 0.15;
            for(double theta = 0.2; theta < M_PI / 2 + 0.2; theta += 0.2){
                // try rotating the velocity vector with theta in anti-clockwise direction
                double new_x = cmd_vel->linear.x * cos(theta)
                             - cmd_vel->linear.y * sin(theta);
                double new_y = cmd_vel->linear.y * cos(theta)
                             + cmd_vel->linear.x * sin(theta);
                collided_indices.clear();
                closest_dist = detectCollisionPts(new_x, new_y, cmd_vel->angular.z,
                        collided_indices);
                if(closest_dist > dist_needed){
                    cmd_vel->linear.x = new_x;
                    cmd_vel->linear.y = new_y;
                    return;
                }

                // try rotating the velocity vector with theta in clockwise direction
                new_x = cmd_vel->linear.x * cos(-theta)
                      - cmd_vel->linear.y * sin(-theta);
                new_y = cmd_vel->linear.y * cos(-theta)
                      + cmd_vel->linear.x * sin(-theta);

                collided_indices.clear();
                closest_dist = detectCollisionPts(new_x, new_y, cmd_vel->angular.z,
                        collided_indices);
                if(closest_dist > dist_needed){
                    cmd_vel->linear.x = new_x;
                    cmd_vel->linear.y = new_y;
                    return;
                }
            }
            // if we couldn't find a path, enforce the speed limit
            cmd_vel->linear.x *= speed_limit / speed;
            cmd_vel->linear.y *= speed_limit / speed;
        }
    }

    // BaseDrive with collision avoidance
    void SafeDrive::drive(geometry_msgs::Twist cmd_vel){
        // prevent collision if the current movement is in risk of collision
        // NOTE: speed threshold is introduced to ignore noise when it's stationary 
        // NOTE: 0.15 is introduced to take account of response time
        double safe_to_go = closest_dist_ - NESFR_RADIUS - speed_ * RESPONSE_TIME;
        if(closest_dist_ != NOT_FOUND
        && pow(speed_, 2) / (safe_to_go) > 9.5 && speed_ > 0.15){
            double decel = pow(speed_, 2) / closest_dist_;
            geometry_msgs::Twist cmd_acc;  
            cmd_acc.linear.x = -vel_x_ * decel / speed_;
            cmd_acc.linear.y = -vel_y_ * decel / speed_;
            acc_pub_.publish(cmd_acc);
            return;
        }

        // make cmd_vel safe from collision and publish
        avoidCollision(&cmd_vel);
        BaseDrive::drive(cmd_vel);
    }
}
