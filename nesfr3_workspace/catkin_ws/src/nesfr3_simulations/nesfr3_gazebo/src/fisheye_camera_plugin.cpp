#include "nesfr3_gazebo/fisheye_camera_plugin.h"

#include <string>
#include <math.h>
#include <opencv2/opencv.hpp>

#include <gazebo/sensors/Sensor.hh>
#include <gazebo/sensors/CameraSensor.hh>
#include <gazebo/sensors/SensorTypes.hh>

int map_init = 0;

namespace gazebo
{
// Register this plugin with the simulator
GZ_REGISTER_SENSOR_PLUGIN(GazeboRosFisheyeCamera)

////////////////////////////////////////////////////////////////////////////////
// Constructor
GazeboRosFisheyeCamera::GazeboRosFisheyeCamera()
{
}

////////////////////////////////////////////////////////////////////////////////
// Destructor
GazeboRosFisheyeCamera::~GazeboRosFisheyeCamera()
{
  ROS_DEBUG_STREAM_NAMED("camera","Unloaded");
}

void GazeboRosFisheyeCamera::Load(sensors::SensorPtr _parent, sdf::ElementPtr _sdf)
{
  // Make sure the ROS node for Gazebo has already been initialized
  if (!ros::isInitialized())
  {
    ROS_FATAL_STREAM_NAMED("camera", "A ROS node for Gazebo has not been initialized, unable to load plugin. "
      << "Load the Gazebo system plugin 'libgazebo_ros_api_plugin.so' in the gazebo_ros package)");
    return;
  }

  CameraPlugin::Load(_parent, _sdf);
  // copying from CameraPlugin into GazeboRosCameraUtils
  this->parentSensor_ = this->parentSensor;
  this->width_ = this->width;
  this->height_ = this->height;
  this->depth_ = this->depth;
  this->format_ = this->format;
  this->camera_ = this->camera;


  if(this->height_!=this->width_){
    ROS_ERROR("invalid image. check if width and height are same");
    exit(-1);
  }

  this->new_w = this->height_*2;
  this->new_h = int(this->height_/2);
  
  GazeboRosCameraUtils::Load(_parent, _sdf);
}


////////////////////////////////////////////////////////////////////////////////
// Update the controller
void GazeboRosFisheyeCamera::OnNewFrame(const unsigned char *_image,
    unsigned int _width, unsigned int _height, unsigned int _depth,
    const std::string &_format)
{
  common::Time sensor_update_time = this->parentSensor_->LastMeasurementTime();

  cv::Mat cv_image = cv::Mat(_height, _width, CV_8UC3, (unsigned char*)_image);

  if(_height!=_width){
    ROS_ERROR("invalid image. check if width and height are same");
    exit(-1);
  }

  if(map_init==0){
    
    this->map_x = cv::Mat(this->new_h, this->new_w, CV_32FC1);
    this->map_y = cv::Mat(this->new_h, this->new_w, CV_32FC1);

    for(int j=0; j<this->new_h; j++){
      for(int i=0; i<this->new_w; i++){
        float theta;
        theta = M_PI * i / (2*this->new_h);
        this->map_x.at<float>(j,i) = j * cos(theta) + this->new_h;
        this->map_y.at<float>(j,i) = -j * sin(theta) + this->new_h;
      }
    }
    map_init = 1;
  }

  cv::Mat output_image = cv::Mat(this->new_h, this->new_w, CV_8UC3);
  cv::remap(cv_image, output_image, this->map_x, this->map_y, cv::INTER_LINEAR);

  this->height_ = this->new_h;
  this->width_ = this->new_w;

  if (!this->parentSensor->IsActive())
  {
    if ((*this->image_connect_count_) > 0)
      // do this first so there's chance for sensor to run once after activated
      this->parentSensor->SetActive(true);
  }
  else
  {
    if ((*this->image_connect_count_) > 0)
    {
      if (sensor_update_time < this->last_update_time_)
      {
          ROS_WARN_NAMED("camera", "Negative sensor update time difference detected.");
          this->last_update_time_ = sensor_update_time;
      }

      // OnNewFrame is triggered at the gazebo sensor <update_rate>
      // while there is also a plugin <updateRate> that can throttle the
      // rate down further (but then why not reduce the sensor rate?
      // what is the use case?).
      // Setting the <updateRate> to zero will make this plugin
      // update at the gazebo sensor <update_rate>, update_period_ will be
      // zero and the conditional always will be true.
      if (sensor_update_time - this->last_update_time_ >= this->update_period_)
      {
        this->PutCameraData(output_image.data, sensor_update_time);
        this->PublishCameraInfo(sensor_update_time);
        this->last_update_time_ = sensor_update_time;
      }
    }
  }
}
}
