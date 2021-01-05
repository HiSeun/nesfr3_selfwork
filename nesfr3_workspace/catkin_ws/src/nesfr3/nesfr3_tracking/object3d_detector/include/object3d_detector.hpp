//STL
#include <math.h>

// ROS
#include <ros/ros.h>
#include <std_msgs/Header.h>
#include <sensor_msgs/PointCloud2.h>
#include <geometry_msgs/PoseArray.h>
#include <visualization_msgs/MarkerArray.h>
#include <cob_perception_msgs/PointCloud2Array.h>
#include <nesfr3_msgs/ClusterProps.h>
#include <nesfr3_msgs/ClusterPropsArray.h>
#include <nesfr3_msgs/BoundingBox.h>
#include <nesfr3_msgs/BoundingBoxes.h>
#include <nesfr3_msgs/PoseArrayWithBoxes.h>

// PCL
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/filters/passthrough.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/common/centroid.h>
#include <pcl/common/common.h>
#include <pcl/common/pca.h>

#define IMAGE_WIDTH 1200
#define IMAGE_HEIGHT 300

#define LIDAR_WIDTH 1024
#define LIDAR_HEIGHT 64

#define LENGTH 0.286948393936
#define PI   3.14159265
#define PI_H 1.57079632

int L(double theta){ // theta is radian
    /*
        1   /      θ       θ         |      θ          θ   | \
        - * | sec(---)tan(---) + log | sec(---) + tan(---) | |   
        8   \      2       2         |      2          θ   | /
    */

    double s = 1.0/(cos(theta/2));
    double t = tan(theta/2);
    
    double ratioL = (s*t + log(std::abs(s+t)))/8.0;

    // 0.286948393674079759254287256148686298449729025454822935491... is length of 0 to pi/2

    ratioL /= LENGTH;   

    return std::ceil(ratioL * IMAGE_HEIGHT);
}

std::pair<int, int> xyz2rt2image(double x, double y, double z){
    assert(x!=0 && z!=0);
    
    // velodyne height : 0.8
    // fisheye camera height : 0.25
    z+=0.55;

    double theta = atan2(sqrt(x*x + y*y),z);
    double phi = atan2(y,x);
    int img_x = IMAGE_WIDTH - int((phi + PI) / (2*PI) * IMAGE_WIDTH); 
    int img_y = L(theta); 

    return std::make_pair(img_x,img_y);
} 

typedef struct feature {
  /*** for visualization ***/
  Eigen::Vector4f centroid;
  Eigen::Vector4f min;
  Eigen::Vector4f max;

  /*** for classification ***/
  int number_points;
  float min_distance;
  Eigen::Matrix3f covariance_3d;
  Eigen::Matrix3f moment_3d;
  float slice[20];
  float intensity[27];
} Feature;