#include "pcl_transformer.hpp"

void dataCallback(const nesfr3_msgs::PoseArrayWithClusters::ConstPtr &clusters_msg, const sensor_msgs::ImageConstPtr &img_msg, ros::Publisher blobs_array_pub_, bool verbose) {
    unsigned long int number_of_cluster = clusters_msg->segments.size();
    std::vector<bool> is_cluster_human;

    cv_bridge::CvImagePtr cv_ptr;
    try {
        cv_ptr = cv_bridge::toCvCopy(img_msg, sensor_msgs::image_encodings::BGR8);
    } catch (cv_bridge::Exception& e){
        ROS_ERROR("cv_bridge exception: %s", e.what());
        return;
    }

    // For visualization
    cv::Mat filter;
    cv::Mat result;
    if (verbose){
        filter = cv::Mat(IMG_HEIGHT, IMG_WIDTH, CV_8UC1);
        result = cv::Mat(IMG_HEIGHT, IMG_WIDTH, CV_8UC3);
    }

    // Image blob size
    int blob_x = ceil(IMG_WIDTH /(LIDAR_WIDTH+0.0) );
    int blob_y = ceil(IMG_HEIGHT/(LIDAR_HEIGHT+0.0) );

    // BlobsArray Topic 
    nesfr3_msgs::BlobsArray::Ptr blobsArray(new nesfr3_msgs::BlobsArray);     
    blobsArray->header = clusters_msg->header;
    blobsArray->poses = clusters_msg->poses;

    // Cartesian to Spherical
    for(int i=0;i<number_of_cluster;i++){
        
        // cartesian to spherical and spherical to coordinate in image
        // (x,y,z) --> (pi, theta) -> (X,Y)
        std::vector<std::pair<int, int>> base_image(clusters_msg->segments[i].width);
        cart2img(clusters_msg->segments[i], base_image);
       
        sort(base_image.begin(), base_image.end(), cmp);

        // Image blob
        /* crop the image based on coordinate of base_image with 3x3 blob
             _______________________                 _______________________
            |        .              |               |      ▉▉▉              |
            |                       |               |   ▉▉▉▉▉▉▉▉▉▉▉         |
            |     .    .  .         |       --->    |   ▉▉▉  ▉▉▉▉▉▉▉▉▉      |
            |                .      |               |   ▉▉▉  ▉▉▉▉▉▉▉▉▉      |
            |_______________________|               |______________▉▉▉______|
        */
        
        // blobs Topic (one Blobs message represents one cluster)
        nesfr3_msgs::Blobs::Ptr blobs(new nesfr3_msgs::Blobs);     
        blobs->cluster_id = i;

        for(int j=0;j<base_image.size();j++){
            int x = base_image[j].first;
            int y = base_image[j].second;            

            nesfr3_msgs::Blob::Ptr blob(new nesfr3_msgs::Blob);     
            
            blob->x = x;
            blob->y = y;
            blob->width = blob_x;
            blob->height = blob_y;
            blobs->blobs.push_back(*blob);

            // Crop image
            if (verbose){
                cv::Rect rect(x, y, blob_x, blob_y);
                cv::rectangle(filter, rect, (255,255,255), CV_FILLED);
               (cv_ptr->image).copyTo(result, filter);
            }
        }
        blobsArray->blobsArray.push_back(*blobs);
        blobsArray->tracking_id.push_back(-1);
    }

    if (verbose){
        cv::imshow("test", result);
        cv::waitKey(1);        
        result = cv::Scalar(0);
        filter = cv::Scalar(0);
        cv::imshow("test",result);
    }

    blobs_array_pub_.publish(blobsArray);
}

bool cmp(const std::pair<int, int> &p1, const std::pair<int, int> &p2){
    if(p1.first < p2.first){
        return true;
    } else if (p1.first == p2.first){
        return p1.second < p2.second;
    } else {
        return false;
    }
}

// convert pointcloud2 to collection of polar coordinate point
void cart2img(const sensor_msgs::PointCloud2 &pc2, std::vector<std::pair<int, int>> &crop_image) {
        pcl::PCLPointCloud2 pcl_pc2;
        pcl_conversions::toPCL(pc2,pcl_pc2);
        pcl::PointCloud<pcl::PointXYZ>::Ptr temp_cloud(new pcl::PointCloud<pcl::PointXYZ>);
        pcl::fromPCLPointCloud2(pcl_pc2,*temp_cloud);
        pcl::PointCloud<pcl::PointXYZ> pcl_cloud = *temp_cloud;

        for(int j=0;j<pcl_cloud.size();j++){
            crop_image[j] = xyz2rt2image(pcl_cloud.points[j].x,
                                         pcl_cloud.points[j].y,
                                         pcl_cloud.points[j].z);
        }
}

// coordinate system change flow
// xyz -> rt -> xy -> x,L,dL in image
std::pair<int, int> xyz2rt2image(double x, double y, double z){
    assert(x!=0 && z!=0);
    
    // velodyne height : 0.8
    // fisheye camera height : 0.25
    z+=0.55;

    double theta = atan2(sqrt(x*x + y*y),z);
    double phi = atan2(y,x);
    int img_x = IMG_WIDTH - int((phi + PI) / (2*PI) * IMG_WIDTH); 
    int img_y = L(theta); 

    return std::make_pair(img_x,img_y);
} 

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

    return std::ceil(ratioL * IMG_HEIGHT);
}

int dL(double theta){ // theta is radian
    double secant = 1.0/(cos(theta/2));
    double dl = pow(secant,3) / 2.0;
    
    int patch_height  = std::ceil((dl/LENGTH) * IMG_HEIGHT);

    return patch_height; 
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "pcl_transformer");

    std::string robot_id(argv[1]);
    std::string verbose_str(argv[2]);
    bool verbose = verbose_str.compare("true") == 0 ? true : false;

    ros::NodeHandle node_handle_;
    
    message_filters::Subscriber<nesfr3_msgs::PoseArrayWithClusters> cluster_sub_(node_handle_, "/nesfr3/" + robot_id + "/pose_with_cluster", 1);
    message_filters::Subscriber<sensor_msgs::Image> image_sub_(node_handle_, "/nesfr3/" + robot_id + "/fisheye_camera/image_raw", 1);

    ros::Publisher blobs_array_pub_ = node_handle_.advertise<nesfr3_msgs::BlobsArray>("/nesfr3/" + robot_id + "/blobsArray", 1);;

    typedef message_filters::sync_policies::ApproximateTime<nesfr3_msgs::PoseArrayWithClusters, sensor_msgs::Image> MySyncPolicy;
    MySyncPolicy mySyncPolicy(100);
    message_filters::Synchronizer<MySyncPolicy> sync(static_cast<const MySyncPolicy &>(mySyncPolicy), cluster_sub_, image_sub_);
    
    sync.registerCallback(boost::bind(&dataCallback, _1, _2, blobs_array_pub_, verbose));
    
    ros::spin();
    
    return 0;
}
