;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::Actor)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'Actor (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::ACTOR")
  (make-package "NESFR3_MSGS::ACTOR"))

(in-package "ROS")
;;//! \htmlinclude Actor.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass nesfr3_msgs::Actor
  :super ros::object
  :slots (_header _name _tracking_id _pose _points _nose_point ))

(defmethod nesfr3_msgs::Actor
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:name __name) "")
    ((:tracking_id __tracking_id) 0)
    ((:pose __pose) (instance geometry_msgs::PoseWithCovariance :init))
    ((:points __points) (let (r) (dotimes (i 18) (push (instance nesfr3_msgs::PointWithConfidence :init) r)) r))
    ((:nose_point __nose_point) (instance geometry_msgs::Point :init))
    )
   (send-super :init)
   (setq _header __header)
   (setq _name (string __name))
   (setq _tracking_id (round __tracking_id))
   (setq _pose __pose)
   (setq _points __points)
   (setq _nose_point __nose_point)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:name
   (&optional __name)
   (if __name (setq _name __name)) _name)
  (:tracking_id
   (&optional __tracking_id)
   (if __tracking_id (setq _tracking_id __tracking_id)) _tracking_id)
  (:pose
   (&rest __pose)
   (if (keywordp (car __pose))
       (send* _pose __pose)
     (progn
       (if __pose (setq _pose (car __pose)))
       _pose)))
  (:points
   (&rest __points)
   (if (keywordp (car __points))
       (send* _points __points)
     (progn
       (if __points (setq _points (car __points)))
       _points)))
  (:nose_point
   (&rest __nose_point)
   (if (keywordp (car __nose_point))
       (send* _nose_point __nose_point)
     (progn
       (if __nose_point (setq _nose_point (car __nose_point)))
       _nose_point)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; string _name
    4 (length _name)
    ;; uint32 _tracking_id
    4
    ;; geometry_msgs/PoseWithCovariance _pose
    (send _pose :serialization-length)
    ;; nesfr3_msgs/PointWithConfidence[18] _points
    (apply #'+ (send-all _points :serialization-length))
    ;; geometry_msgs/Point _nose_point
    (send _nose_point :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; string _name
       (write-long (length _name) s) (princ _name s)
     ;; uint32 _tracking_id
       (write-long _tracking_id s)
     ;; geometry_msgs/PoseWithCovariance _pose
       (send _pose :serialize s)
     ;; nesfr3_msgs/PointWithConfidence[18] _points
     (dolist (elem _points)
       (send elem :serialize s)
       )
     ;; geometry_msgs/Point _nose_point
       (send _nose_point :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; string _name
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _name (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; uint32 _tracking_id
     (setq _tracking_id (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; geometry_msgs/PoseWithCovariance _pose
     (send _pose :deserialize buf ptr-) (incf ptr- (send _pose :serialization-length))
   ;; nesfr3_msgs/PointWithConfidence[18] _points
   (dotimes (i 18)
     (send (elt _points i) :deserialize buf ptr-) (incf ptr- (send (elt _points i) :serialization-length))
     )
   ;; geometry_msgs/Point _nose_point
     (send _nose_point :deserialize buf ptr-) (incf ptr- (send _nose_point :serialization-length))
   ;;
   self)
  )

(setf (get nesfr3_msgs::Actor :md5sum-) "e66ab061dc9fde49d29081c40910f1a1")
(setf (get nesfr3_msgs::Actor :datatype-) "nesfr3_msgs/Actor")
(setf (get nesfr3_msgs::Actor :definition-)
      "Header header                           # frame_id and timestamp
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



(provide :nesfr3_msgs/Actor "e66ab061dc9fde49d29081c40910f1a1")


