#ifndef NESFR3_DRIVER_H
#define NESFR3_DRIVER_H
#include <ros/ros.h>
#include <pcl_ros/point_cloud.h>
#include <geometry_msgs/Twist.h>
#include <nav_msgs/Odometry.h>
#include <sensor_msgs/PointCloud2.h>


namespace nesfr3_teleop{
    class BaseDrive{
        public: 
            BaseDrive(uint32_t nesfr3_index);
            virtual void drive(geometry_msgs::Twist cmd_vel);

        protected:
            virtual void odomCallback(const nav_msgs::Odometry::ConstPtr& msg);

            ros::NodeHandle nh_;
            ros::Publisher acc_pub_;
            ros::Publisher vel_pub_;
            ros::Subscriber odom_sub_;

            double vel_x_;
            double vel_y_;
            double rot_z_;
            double speed_;
            double move_dir_;

            double e_x_prev_ = 0.0;
            double e_y_prev_ = 0.0;
            double e_z_prev_ = 0.0;

        private:
            void slipLess(double cmd_x, double cmd_y,
                    geometry_msgs::Twist *cmd_vel,
                    geometry_msgs::Twist *cmd_acc);
    };

    class SafeDrive : public BaseDrive
    {
        public:
            SafeDrive(uint32_t nesfr3_index);
            void drive(geometry_msgs::Twist cmd_vel) override;

        protected:
            void odomCallback(const nav_msgs::Odometry::ConstPtr& msg) override;
            void pclCallback(const sensor_msgs::PointCloud2::ConstPtr& msg);

            void avoidCollision(geometry_msgs::Twist *cmd_vel);
            double detectCollisionPts(double vel_x, double vel_y, double vel_z,
                    std::vector<int> &collided_indices);

            ros::Subscriber pcl_sub_;

            // Publisher of predicted collision points
            ros::Publisher collision_pub_;
            ros::Publisher expected_pub_;

            // Latest PointCloud from LiDAR
            pcl::PCLPointCloud2 cloud_;
            pcl::PCLPointCloud2 prev_cloud_;

            geometry_msgs::Pose pose_;
            geometry_msgs::Pose prev_pose_;

            // Distance to first obstacle in the current moving direction
            double closest_dist_;
    };
}
#endif
