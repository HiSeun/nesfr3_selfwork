#include "nesfr3_gazebo/camera_zoom_plugin.h"

#include <string>
#include <gazebo/sensors/Sensor.hh>
#include <gazebo/sensors/CameraSensor.hh>
#include <gazebo/sensors/SensorTypes.hh>

namespace gazebo
{
    // Register this plugin with the simulator
    GZ_REGISTER_SENSOR_PLUGIN(GazeboRosZoomCamera)

        ////////////////////////////////////////////////////////////////////////////////
        // Constructor
        GazeboRosZoomCamera::GazeboRosZoomCamera()
        {
        }

    ////////////////////////////////////////////////////////////////////////////////
    // Destructor
    GazeboRosZoomCamera::~GazeboRosZoomCamera()
    {
        ROS_DEBUG_STREAM_NAMED("camera","Unloaded");
    }

    void GazeboRosZoomCamera::Load(sensors::SensorPtr _parent, sdf::ElementPtr _sdf)
    {
        // Make sure the ROS node for Gazebo has already been initialized
        if (!ros::isInitialized())
        {
            ROS_FATAL_STREAM_NAMED("camera", "A ROS node for Gazebo has not been initialized, unable to load plugin. "
                    << "Load the Gazebo system plugin 'libgazebo_ros_api_plugin.so' in the gazebo_ros package)");
            return;
        }

        this->index = _sdf->Get<int>("index");

        CameraPlugin::Load(_parent, _sdf);

        // copying from CameraPlugin into GazeboRosCameraUtils
        this->parentSensor_ = this->parentSensor;
        this->width_ = this->width;
        this->height_ = this->height;
        this->depth_ = this->depth;
        this->format_ = this->format;
        this->camera_ = this->camera;


        GazeboRosCameraUtils::Load(_parent, _sdf);
        
        this->cameraHFOVSubscriber = this->nh.subscribe("nesfr3/main_camera/set_hfov", 1, &GazeboRosZoomCamera::SetHFOV_, this);


        //if this->rosnode_ is used instead of this->nh, the node crashes
        this->cameraHFOVSubscriber = this->nh.subscribe("nesfr3/" + std::to_string(this->index) + "/main_camera/set_hfov",
         1, &GazeboRosZoomCamera::SetHFOV_, this);
    }

    ////////////////////////////////////////////////////////////////////////////////
    // Update the controller
    void GazeboRosZoomCamera::OnNewFrame(const unsigned char *_image,
            unsigned int _width, unsigned int _height, unsigned int _depth,
            const std::string &_format)
    {
# if GAZEBO_MAJOR_VERSION >= 7
        common::Time sensor_update_time = this->parentSensor_->LastMeasurementTime();
# else
        common::Time sensor_update_time = this->parentSensor_->GetLastMeasurementTime();
# endif

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
                    this->PutCameraData(_image, sensor_update_time);
                    this->PublishCameraInfo_(sensor_update_time);
                    this->last_update_time_ = sensor_update_time;
                }
            }
        }
    }

    ///// Set HFOV

    void GazeboRosZoomCamera::SetHFOV_(const std_msgs::Float64::ConstPtr& hfov)
    {
      if (this->initialized_)
      {
      #if GAZEBO_MAJOR_VERSION >= 7
        const ignition::math::Angle &angle_ = hfov->data;
      #else
        const gazebo::math::Angle &angle_ = hfov->data;
      #endif
        this->camera_->sdf->GetElement("horizontal_fov")->Set(angle_.Radian());
        if (this->camera_->viewport){
          double ratio = static_cast<double>(this->camera_->viewport->getActualWidth()) /
            static_cast<double>(this->camera_->viewport->getActualHeight());
          double hfov_ = this->camera_->HFOV().Radian();
          double vfov_ = 2.0 * atan(tan(hfov_ / 2.0) / ratio);

          this->camera_->camera->setAspectRatio(ratio);
          this->camera_->camera->setFOVy(Ogre::Radian(vfov_));
        }
      }
    }

    void GazeboRosZoomCamera::PublishCameraInfo_(common::Time &last_update_time)
    {
        if (!this->initialized_ || this->height_ <=0 || this->width_ <=0)
            return;

        this->sensor_update_time_ = last_update_time;
        this->PublishCameraInfo_();
    }

    void GazeboRosZoomCamera::PublishCameraInfo_()
    {
        if (!this->initialized_ || this->height_ <=0 || this->width_ <=0)
            return;

        if (this->camera_info_pub_.getNumSubscribers() > 0)
        {
            this->sensor_update_time_ = this->parentSensor_->LastMeasurementTime();
            if (this->sensor_update_time_ - this->last_info_update_time_ >= this->update_period_)
            {
                this->PublishCameraInfo_(this->camera_info_pub_);
                this->last_info_update_time_ = this->sensor_update_time_;
            }
        }
    }

    void GazeboRosZoomCamera::PublishCameraInfo_(
            ros::Publisher camera_info_publisher)
    {
        sensor_msgs::CameraInfo camera_info_msg = camera_info_manager_->getCameraInfo();

        camera_info_msg.header.stamp.sec = this->sensor_update_time_.sec;
        camera_info_msg.header.stamp.nsec = this->sensor_update_time_.nsec;

        double hfov = this->camera_->HFOV().Radian();
        double focal_length = (static_cast<double>(this->width_)) / (2.0 * tan(hfov / 2.0));

        camera_info_msg.K[0] = focal_length;
        camera_info_msg.K[4] = focal_length;
        camera_info_msg.P[0] = focal_length;
        camera_info_msg.P[3] = -focal_length * this->hack_baseline_;
        camera_info_msg.P[5] = focal_length;

        camera_info_publisher.publish(camera_info_msg);
    }

}

