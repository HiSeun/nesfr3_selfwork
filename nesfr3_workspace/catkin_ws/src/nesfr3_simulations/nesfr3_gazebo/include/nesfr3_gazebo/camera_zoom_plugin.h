#ifndef GAZEBO_ROS_ZOOM_CAMERA_HH
#define GAZEBO_ROS_ZOOM_CAMERA_HH

#include <string>

// library for processing camera data for gazebo / ros conversions
#include <nesfr3_gazebo/CameraPlugin.hh>
#include <gazebo_plugins/gazebo_ros_camera_utils.h>

namespace gazebo
{
  class GazeboRosZoomCamera : public CameraPlugin, public GazeboRosCameraUtils
  {
    /// \brief Constructor
    /// \param parent The parent entity, must be a Model or a Sensor
    public: GazeboRosZoomCamera();

    /// \brief Destructor
    public: ~GazeboRosZoomCamera();

    /// \brief Load the plugin
    /// \param take in SDF root element
    public: void Load(sensors::SensorPtr _parent, sdf::ElementPtr _sdf);
    public: void SetHFOV_(const std_msgs::Float64::ConstPtr& hfov);
    /// \brief Update the controller
    protected: virtual void OnNewFrame(const unsigned char *_image,
                   unsigned int _width, unsigned int _height,
                   unsigned int _depth, const std::string &_format);

    protected: void PublishCameraInfo_(ros::Publisher camera_info_publisher);
    protected: void PublishCameraInfo_(common::Time &last_update_time);
    protected: void PublishCameraInfo_();

    private: ros::Subscriber cameraHFOVSubscriber;

    private: ros::NodeHandle nh;
    private: uint32_t index;
  };
  
}
#endif
