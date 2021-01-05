#include "object3d_detector.hpp"

static const int FEATURE_SIZE = 61;

class Object3dDetector {
private:
  // Publishers and Subscribers
  ros::NodeHandle node_handle_;
  ros::Subscriber point_cloud_sub_;
  ros::Publisher point_cloud_pub_;
  ros::Publisher clusters_props_pub_;
  ros::Publisher pose_array_pub_;
  ros::Publisher marker_array_pub_;
  ros::Publisher bounding_boxes_pub_;
  
  bool print_fps_;
  std::string frame_id_;
  float z_limit_min_;
  float z_limit_max_;
  int cluster_size_min_;
  int cluster_size_max_;
  
  std::vector<Feature> features_;
  float human_probability_;
  bool human_size_limit_;
  
public:
  Object3dDetector();
  ~Object3dDetector();
  
  void pointCloudCallback(const sensor_msgs::PointCloud2::ConstPtr& ros_pc2);
  
  void extractCluster(pcl::PointCloud<pcl::PointXYZI>::Ptr pc, std_msgs::Header);
  void extractFeature(pcl::PointCloud<pcl::PointXYZI>::Ptr pc, Feature &f,
		      Eigen::Vector4f &min, Eigen::Vector4f &max, Eigen::Vector4f &centroid);
  void classify(std_msgs::Header);
};

Object3dDetector::Object3dDetector() {
  ros::NodeHandle node_handle_(ros::this_node::getNamespace());
  
  // Subscriber
  point_cloud_sub_ = node_handle_.subscribe<sensor_msgs::PointCloud2>("lidar/points", 1, &Object3dDetector::pointCloudCallback, this);
  
  // Publisher
  ros::NodeHandle private_nh("~");
  point_cloud_pub_ = node_handle_.advertise<cob_perception_msgs::PointCloud2Array>("cluster", 1);
  clusters_props_pub_ = node_handle_.advertise<nesfr3_msgs::ClusterPropsArray>("cluster_props", 1);
  marker_array_pub_ = node_handle_.advertise<visualization_msgs::MarkerArray>("object3d_detector/markers", 1);
  pose_array_pub_ = node_handle_.advertise<nesfr3_msgs::PoseArrayWithBoxes>("object3d_detector/poses", 1);
  bounding_boxes_pub_ = node_handle_.advertise<nesfr3_msgs::BoundingBoxes>("object3d_detector/bounding_boxes", 1);
  
  // Parameters
  private_nh.param<bool>("print_fps", print_fps_, false);
  private_nh.param<std::string>("frame_id", frame_id_, "nesfr3/1/os1_sensor");
  //private_nh.param<std::string>("frame_id", frame_id_, "nesfr3/1/velodyne");
  private_nh.param<float>("z_limit_min", z_limit_min_, -0.8);
  private_nh.param<float>("z_limit_max", z_limit_max_, 1.2);
  private_nh.param<int>("cluster_size_min", cluster_size_min_, 5);
  private_nh.param<int>("cluster_size_max", cluster_size_max_, 30000);
  private_nh.param<float>("human_probability", human_probability_, 0.7);
  private_nh.param<bool>("human_size_limit", human_size_limit_, false);
}

Object3dDetector::~Object3dDetector() {

}

int frames; clock_t start_time; bool reset = true;//fps
void Object3dDetector::pointCloudCallback(const sensor_msgs::PointCloud2::ConstPtr& ros_pc2) {
  if(print_fps_)
    if(reset) {
      frames=0;
      start_time=clock();
      reset=false;
  }
  
  pcl::PointCloud<pcl::PointXYZI>::Ptr pcl_pc(new pcl::PointCloud<pcl::PointXYZI>);
  pcl::fromROSMsg(*ros_pc2, *pcl_pc);
  
  extractCluster(pcl_pc, ros_pc2->header);
  classify(ros_pc2->header);
  
  if(print_fps_)
    if(++frames>10){
      std::cerr << "[object3d_detector]: fps = " 
                << float(frames)/(float(clock()-start_time)/CLOCKS_PER_SEC)
                << ", timestamp = "<<clock()/CLOCKS_PER_SEC
                << std::endl;
      
      reset = true;
    }
}

const int nested_regions_ = 14;
int zone_[nested_regions_] = {2,3,3,3,3,3,3,2,3,3,3,3,3,3}; // for more details, see our IROS'17 paper.

void Object3dDetector::extractCluster(pcl::PointCloud<pcl::PointXYZI>::Ptr pc, std_msgs::Header header) {
  features_.clear();

  pcl::IndicesPtr pc_indices(new std::vector<int>);
  pcl::PassThrough<pcl::PointXYZI> pass;
  pass.setInputCloud(pc);
  pass.setFilterFieldName("z");
  pass.setFilterLimits(z_limit_min_, z_limit_max_);
  pass.filter(*pc_indices);

  boost::array<std::vector<int>, nested_regions_> indices_array;
  for(int i = 0; i < pc_indices->size(); i++) {
    float range = 0.0;
    for(int j = 0; j < nested_regions_; j++) {
      float d2  = pc->points[(*pc_indices)[i]].x * pc->points[(*pc_indices)[i]].x +
                  pc->points[(*pc_indices)[i]].y * pc->points[(*pc_indices)[i]].y +
                  pc->points[(*pc_indices)[i]].z * pc->points[(*pc_indices)[i]].z;
      
      if(d2 > range*range && d2 <= (range+zone_[j])*(range+zone_[j])) {
      	indices_array[j].push_back((*pc_indices)[i]);
      	break;
      }
      
      range += zone_[j];
    }
  }

  cob_perception_msgs::PointCloud2Array::Ptr clusters_msg(new cob_perception_msgs::PointCloud2Array);  
  nesfr3_msgs::ClusterPropsArray::Ptr clusters_props(new nesfr3_msgs::ClusterPropsArray);

  clusters_msg->header = header;
  clusters_props->header = header;
  float tolerance = 0.0;
  for(int i = 0; i < nested_regions_; i++) {
    tolerance += 0.1;
    if(indices_array[i].size() > cluster_size_min_) {
      boost::shared_ptr<std::vector<int> > indices_array_ptr(new std::vector<int>(indices_array[i]));
      pcl::search::KdTree<pcl::PointXYZI>::Ptr tree(new pcl::search::KdTree<pcl::PointXYZI>);
      tree->setInputCloud(pc, indices_array_ptr);
      
      std::vector<pcl::PointIndices> cluster_indices;
      pcl::EuclideanClusterExtraction<pcl::PointXYZI> ec;
      ec.setClusterTolerance(tolerance);
      ec.setMinClusterSize(cluster_size_min_);
      ec.setMaxClusterSize(cluster_size_max_);
      ec.setSearchMethod(tree);
      ec.setInputCloud(pc);
      ec.setIndices(indices_array_ptr);
      ec.extract(cluster_indices);
      
      for(std::vector<pcl::PointIndices>::const_iterator it = cluster_indices.begin(); it != cluster_indices.end(); it++) {
      	pcl::PointCloud<pcl::PointXYZI>::Ptr cluster(new pcl::PointCloud<pcl::PointXYZI>);
      	for(std::vector<int>::const_iterator pit = it->indices.begin(); pit != it->indices.end(); ++pit)
      	  cluster->points.push_back(pc->points[*pit]);

      	cluster->width = cluster->size();
      	cluster->height = 1;
      	cluster->is_dense = true;

      	Eigen::Vector4f min, max, centroid;
      	pcl::getMinMax3D(*cluster, min, max);
      	pcl::compute3DCentroid(*cluster, centroid);
        
      	// Size limitation is not reasonable, but it can increase fps.
      	if(
	   (max[0]-min[0] < 0.2 || max[0]-min[0] > 1.0 ||
	    max[1]-min[1] < 0.2 || max[1]-min[1] > 1.0 ||
	    max[2]-min[2] < 0.5 || max[2]-min[2] > 2.0)) 
	  continue;
  
  // Convert cluster to ros cluster message
  sensor_msgs::PointCloud2::Ptr cluster_msg(new sensor_msgs::PointCloud2);
  pcl::toROSMsg(*cluster, *cluster_msg);

  // Make cluster array for pcl_transformer
  clusters_msg->segments.push_back(*cluster_msg);

  // Save and publish cluster property
  nesfr3_msgs::ClusterProps::Ptr cluster_props(new nesfr3_msgs::ClusterProps);
  
  cluster_props->min.x = min[0];
  cluster_props->min.y = min[1];
  cluster_props->min.z = min[2];
  cluster_props->max.x = max[0];
  cluster_props->max.y = max[1];
  cluster_props->max.z = max[2];
  cluster_props->centroid.x = centroid[0];
  cluster_props->centroid.y = centroid[1];
  cluster_props->centroid.z = centroid[2];

  clusters_props->ClusterPropsArray.push_back(*cluster_props);
	Feature f;
	extractFeature(cluster, f, min, max, centroid);
	features_.push_back(f);
      }
    }
  }
  clusters_props_pub_.publish(clusters_props);
  point_cloud_pub_.publish(clusters_msg);	
}

void Object3dDetector::extractFeature(pcl::PointCloud<pcl::PointXYZI>::Ptr pc, Feature &f,
				      Eigen::Vector4f &min, Eigen::Vector4f &max, Eigen::Vector4f &centroid) {
  f.centroid = centroid;
  f.min = min;
  f.max = max;
}
  
void Object3dDetector::classify(std_msgs::Header header) {
  visualization_msgs::MarkerArray marker_array;
  nesfr3_msgs::PoseArrayWithBoxes pose_array;
  nesfr3_msgs::BoundingBoxes bounding_boxes;
  
  for(std::vector<Feature>::iterator it = features_.begin(); it != features_.end(); ++it) { // 벡터의 데이터가 있는 리스트의 시작 주소를 리턴, 리스트의 끝에 도달하기 전에 리턴.
    visualization_msgs::Marker marker;
    marker.header.stamp = ros::Time::now();
    marker.header.frame_id = frame_id_;
    marker.ns = "object3d";
    marker.id = it-features_.begin();
    marker.type = visualization_msgs::Marker::LINE_LIST; // type of object line.
    geometry_msgs::Point p[24];
    
    p[0].x = it->max[0]; p[0].y = it->max[1]; p[0].z = it->max[2];
    p[1].x = it->min[0]; p[1].y = it->max[1]; p[1].z = it->max[2];
    p[2].x = it->max[0]; p[2].y = it->max[1]; p[2].z = it->max[2];
    p[3].x = it->max[0]; p[3].y = it->min[1]; p[3].z = it->max[2];
    p[4].x = it->max[0]; p[4].y = it->max[1]; p[4].z = it->max[2];
    p[5].x = it->max[0]; p[5].y = it->max[1]; p[5].z = it->min[2];
    p[6].x = it->min[0]; p[6].y = it->min[1]; p[6].z = it->min[2];
    p[7].x = it->max[0]; p[7].y = it->min[1]; p[7].z = it->min[2];
    p[8].x = it->min[0]; p[8].y = it->min[1]; p[8].z = it->min[2];
    p[9].x = it->min[0]; p[9].y = it->max[1]; p[9].z = it->min[2];
    p[10].x = it->min[0]; p[10].y = it->min[1]; p[10].z = it->min[2];
    p[11].x = it->min[0]; p[11].y = it->min[1]; p[11].z = it->max[2];
    p[12].x = it->min[0]; p[12].y = it->max[1]; p[12].z = it->max[2];
    p[13].x = it->min[0]; p[13].y = it->max[1]; p[13].z = it->min[2];
    p[14].x = it->min[0]; p[14].y = it->max[1]; p[14].z = it->max[2];
    p[15].x = it->min[0]; p[15].y = it->min[1]; p[15].z = it->max[2];
    p[16].x = it->max[0]; p[16].y = it->min[1]; p[16].z = it->max[2];
    p[17].x = it->max[0]; p[17].y = it->min[1]; p[17].z = it->min[2];
    p[18].x = it->max[0]; p[18].y = it->min[1]; p[18].z = it->max[2];
    p[19].x = it->min[0]; p[19].y = it->min[1]; p[19].z = it->max[2];
    p[20].x = it->max[0]; p[20].y = it->max[1]; p[20].z = it->min[2];
    p[21].x = it->min[0]; p[21].y = it->max[1]; p[21].z = it->min[2];
    p[22].x = it->max[0]; p[22].y = it->max[1]; p[22].z = it->min[2];
    p[23].x = it->max[0]; p[23].y = it->min[1]; p[23].z = it->min[2];

    for(int i = 0; i < 24; i++)
      marker.points.push_back(p[i]);

    marker.scale.x = 0.02;
    marker.color.a = 1.0;
    marker.color.r = 0.0;
    marker.color.g = 0.5;
    marker.color.b = 1.0; // blue color
    
    marker.lifetime = ros::Duration(0.1); // 0.1초 지속됬다가 사라짐.ㄹ
    marker_array.markers.push_back(marker);
    
    geometry_msgs::Pose pose;
    pose.position.x = it->centroid[0];
    pose.position.y = it->centroid[1];
    pose.position.z = it->centroid[2];
    pose.orientation.w = 1;
    pose_array.poses.push_back(pose);

    // From vertices of cluster box, calculate bounding box on image.
    nesfr3_msgs::BoundingBox bounding_box;
    float A = float(IMAGE_WIDTH) - (std::atan2(it->min[1], it->min[0]) / (2 * M_PI) * (float)IMAGE_WIDTH + (float)IMAGE_WIDTH / 2);
    float B = float(IMAGE_WIDTH) - (std::atan2(it->max[1], it->max[0]) / (2 * M_PI) * (float)IMAGE_WIDTH + (float)IMAGE_WIDTH / 2);
    float C = float(IMAGE_WIDTH) - (std::atan2(it->min[1], it->max[0]) / (2 * M_PI) * (float)IMAGE_WIDTH + (float)IMAGE_WIDTH / 2);
    float D = float(IMAGE_WIDTH) - (std::atan2(it->max[1], it->min[0]) / (2 * M_PI) * (float)IMAGE_WIDTH + (float)IMAGE_WIDTH / 2);
    std::pair<int, int> box_A = xyz2rt2image(double(it->min[0]), double(it->min[1]), double(it->min[2]));
    std::pair<int, int> box_B = xyz2rt2image(double(it->min[0]), double(it->min[1]), double(it->max[2]));
    std::pair<int, int> box_C = xyz2rt2image(double(it->min[0]), double(it->max[1]), double(it->min[2]));
    std::pair<int, int> box_D = xyz2rt2image(double(it->min[0]), double(it->max[1]), double(it->max[2]));
    std::pair<int, int> box_E = xyz2rt2image(double(it->max[0]), double(it->min[1]), double(it->min[2]));
    std::pair<int, int> box_F = xyz2rt2image(double(it->max[0]), double(it->min[1]), double(it->max[2]));
    std::pair<int, int> box_G = xyz2rt2image(double(it->max[0]), double(it->max[1]), double(it->min[2]));
    std::pair<int, int> box_H = xyz2rt2image(double(it->max[0]), double(it->max[1]), double(it->max[2]));
    int blob_x = ceil(IMAGE_WIDTH /(LIDAR_WIDTH+0.0) );
    int blob_y = ceil(IMAGE_HEIGHT/(LIDAR_HEIGHT+0.0) );
    int box_xmin = std::min({box_A.first, box_B.first, box_C.first, box_D.first, box_E.first, box_F.first, box_G.first, box_H.first}) - int(blob_x / 2); 
    int box_xmax = std::max({box_A.first, box_B.first, box_C.first, box_D.first, box_E.first, box_F.first, box_G.first, box_H.first}) - int(blob_x / 2) + blob_x - 1;
    int box_ymin = std::min({box_A.second, box_B.second, box_C.second, box_D.second, box_E.second, box_F.second, box_G.second, box_H.second}) - int(blob_y / 2);
    int box_ymax = std::max({box_A.second, box_B.second, box_C.second, box_D.second, box_E.second, box_F.second, box_G.second, box_H.second}) - int(blob_y / 2) + blob_y - 1;

    // std::cout << box_xmin << "   " << box_xmax << "   " << box_ymin << "   " << box_ymax << std::endl;
    bounding_box.xmin = box_xmin;
    bounding_box.xmax = box_xmax;
    bounding_box.ymin = box_ymin;
    bounding_box.ymax = box_ymax;
    if (bounding_box.xmax - bounding_box.xmin > IMAGE_WIDTH - 200){
      int temp;
      temp = bounding_box.xmin;
      bounding_box.xmin = bounding_box.xmax;
      bounding_box.xmax = temp;
    }
    pose_array.bounding_boxes.push_back(bounding_box);
  }
  
  if(marker_array.markers.size()) {
    marker_array_pub_.publish(marker_array);
  }
  if(pose_array.poses.size()) {
    pose_array.header.stamp = header.stamp;
    pose_array.header.frame_id = frame_id_;
    pose_array_pub_.publish(pose_array);
  }
}

int main(int argc, char **argv) {
  ros::init(argc, argv, "object3d_detector");
  Object3dDetector d;
  ros::spin();
  return 0;
}
