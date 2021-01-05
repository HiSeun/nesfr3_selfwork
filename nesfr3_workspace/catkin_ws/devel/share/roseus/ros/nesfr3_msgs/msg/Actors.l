;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::Actors)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'Actors (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::ACTORS")
  (make-package "NESFR3_MSGS::ACTORS"))

(in-package "ROS")
;;//! \htmlinclude Actors.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass nesfr3_msgs::Actors
  :super ros::object
  :slots (_header _actors ))

(defmethod nesfr3_msgs::Actors
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:actors __actors) (let (r) (dotimes (i 0) (push (instance nesfr3_msgs::Actor :init) r)) r))
    )
   (send-super :init)
   (setq _header __header)
   (setq _actors __actors)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:actors
   (&rest __actors)
   (if (keywordp (car __actors))
       (send* _actors __actors)
     (progn
       (if __actors (setq _actors (car __actors)))
       _actors)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; nesfr3_msgs/Actor[] _actors
    (apply #'+ (send-all _actors :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; nesfr3_msgs/Actor[] _actors
     (write-long (length _actors) s)
     (dolist (elem _actors)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; nesfr3_msgs/Actor[] _actors
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _actors (let (r) (dotimes (i n) (push (instance nesfr3_msgs::Actor :init) r)) r))
     (dolist (elem- _actors)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get nesfr3_msgs::Actors :md5sum-) "3cb6e6b906cb00a49df587adf340a00b")
(setf (get nesfr3_msgs::Actors :datatype-) "nesfr3_msgs/Actors")
(setf (get nesfr3_msgs::Actors :definition-)
      "Header header   # For frame_id and timestamp
Actor[] actors

================================================================================
MSG: std_msgs/Header
# Standard metadata for higher-level stamped data types.
# This is generally used to communicate timestamped data 
# in a particular coordinate frame.
# 
# sequence ID: consecutively increasing ID 
uint32 seq
#Two-integer timestamp that is expressed as:
# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
# time-handling sugar is provided by the client library
time stamp
#Frame this data is associated with
string frame_id

================================================================================
MSG: nesfr3_msgs/Actor
Header header                           # frame_id and timestamp
string name                             # name for face recognition
uint32 tracking_id                      # identification for tracking
geometry_msgs/PoseWithCovariance pose   # position from detection and 
                                        # orientation from EKF
PointWithConfidence[18] points          # skeleton points from pose estimation
                                        # 0: nose
                                        # 1: left eye
                                        # 2: right eye
                                        # 3: left ear
                                        # 4: right ear
                                        # 5: left shoulder
                                        # 6: right shoulder
                                        # 7: left elbow
                                        # 8: right elbow
                                        # 9: left wrist
                                        # 10: right wrist
                                        # 11: left hip
                                        # 12: right hip
                                        # 13: left knee
                                        # 14: right knee
                                        # 15: left ankle
                                        # 16: right ankle
                                        # 17: neck
geometry_msgs/Point nose_point          # nose_point for facerec
================================================================================
MSG: geometry_msgs/PoseWithCovariance
# This represents a pose in free space with uncertainty.

Pose pose

# Row-major representation of the 6x6 covariance matrix
# The orientation parameters use a fixed-axis representation.
# In order, the parameters are:
# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)
float64[36] covariance

================================================================================
MSG: geometry_msgs/Pose
# A representation of pose in free space, composed of position and orientation. 
Point position
Quaternion orientation

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Quaternion
# This represents an orientation in free space in quaternion form.

float64 x
float64 y
float64 z
float64 w

================================================================================
MSG: nesfr3_msgs/PointWithConfidence
geometry_msgs/Point point
float32 confidence

")



(provide :nesfr3_msgs/Actors "3cb6e6b906cb00a49df587adf340a00b")


