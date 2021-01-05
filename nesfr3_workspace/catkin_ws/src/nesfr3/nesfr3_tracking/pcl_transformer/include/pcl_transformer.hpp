// ROS
#include <ros/ros.h>
#include <std_msgs/Header.h>
#include <sensor_msgs/PointCloud2.h>
#include <sensor_msgs/Image.h>
#include <geometry_msgs/PoseArray.h>
#include <visualization_msgs/MarkerArray.h>
#include <cob_perception_msgs/PointCloud2Array.h>
#include <nesfr3_msgs/ClusterProps.h>
#include <nesfr3_msgs/ClusterPropsArray.h>
#include <nesfr3_msgs/Blob.h>
#include <nesfr3_msgs/Blobs.h>
#include <nesfr3_msgs/BlobsArray.h>
#include <nesfr3_msgs/PoseArrayWithClusters.h>
#include <message_filters/subscriber.h>
#include <message_filters/synchronizer.h>
#include <message_filters/sync_policies/approximate_time.h>

// PCL
#include <pcl_conversions/pcl_conversions.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/filters/passthrough.h>
#include <pcl/PCLPointCloud2.h>
#include <pcl/point_types.h>
#include <pcl/PCLPointCloud2.h>
#include <pcl/conversions.h>
#include <pcl_ros/transforms.h>
#include <pcl/segmentation/sac_segmentation.h>
#include <pcl/segmentation/extract_clusters.h>
#include <pcl/common/centroid.h>
#include <pcl/common/common.h>
#include <pcl/common/pca.h>

// CV
#include <cv_bridge/cv_bridge.h>
#include <sensor_msgs/image_encodings.h>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <image_transport/image_transport.h>

// Utils 
#include <boost/geometry.hpp>
#include <vector>
#include <string>
#include <utility>
#include <cmath>
#include <assert.h>
#include <algorithm>

#define PI   3.14159265
#define PI_H 1.57079632

#define IMG_WIDTH 1200
#define IMG_HEIGHT 300

#define LIDAR_WIDTH 1024
#define LIDAR_HEIGHT 64

#define LENGTH 0.286948393936

void dataCallback(const cob_perception_msgs::PointCloud2Array::ConstPtr &clusters_msg, const sensor_msgs::ImageConstPtr &img_msg, bool verbose);
bool cmp(const std::pair<int, int> &p1, const std::pair<int, int> &p2);
void cart2img(const sensor_msgs::PointCloud2 &pc2, std::vector<std::pair<int, int>> &crop_image);
int L(double theta);
int dL(double theta);

std::pair<int, int> xyz2rt2image(double x, double y, double z);
