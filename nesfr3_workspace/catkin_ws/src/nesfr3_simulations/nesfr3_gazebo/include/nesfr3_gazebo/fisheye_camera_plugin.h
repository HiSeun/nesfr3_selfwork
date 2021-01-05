#ifndef GAZEBO_ROS_FISHEYE_CAMERA_HH
#define GAZEBO_ROS_FISHEYE_CAMERA_HH

#include <string>
#include <opencv2/opencv.hpp>
// library for processing camera data for gazebo / ros conversions
#include <nesfr3_gazebo/CameraPlugin.hh>
#include <gazebo_plugins/gazebo_ros_camera_utils.h>

namespace gazebo
{
  class GazeboRosFisheyeCamera : public CameraPlugin, public GazeboRosCameraUtils
  {
    /// \brief Constructor
    /// \param parent The parent entity, must be a Model or a Sensor
    public: GazeboRosFisheyeCamera();

    /// \brief Destructor
    public: ~GazeboRosFisheyeCamera();

    /// \brief Load the plugin
    /// \param take in SDF root element
    public: void Load(sensors::SensorPtr _parent, sdf::ElementPtr _sdf);
    /// \brief Update the controller
    protected: virtual void OnNewFrame(const unsigned char *_image,
                   unsigned int _width, unsigned int _height,
                   unsigned int _depth, const std::string &_format);
    
    private: int new_w;
    private: int new_h;
    private: cv::Mat map_x;
    private: cv::Mat map_y;
    

  };
  
}
#endif
