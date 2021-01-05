;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::BlobsArray)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'BlobsArray (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::BLOBSARRAY")
  (make-package "NESFR3_MSGS::BLOBSARRAY"))

(in-package "ROS")
;;//! \htmlinclude BlobsArray.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass nesfr3_msgs::BlobsArray
  :super ros::object
  :slots (_header _poses _blobsArray _tracking_id ))

(defmethod nesfr3_msgs::BlobsArray
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:poses __poses) (let (r) (dotimes (i 0) (push (instance geometry_msgs::Pose :init) r)) r))
    ((:blobsArray __blobsArray) (let (r) (dotimes (i 0) (push (instance nesfr3_msgs::Blobs :init) r)) r))
    ((:tracking_id __tracking_id) (make-array 0 :initial-element 0 :element-type :integer))
    )
   (send-super :init)
   (setq _header __header)
   (setq _poses __poses)
   (setq _blobsArray __blobsArray)
   (setq _tracking_id __tracking_id)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:poses
   (&rest __poses)
   (if (keywordp (car __poses))
       (send* _poses __poses)
     (progn
       (if __poses (setq _poses (car __poses)))
       _poses)))
  (:blobsArray
   (&rest __blobsArray)
   (if (keywordp (car __blobsArray))
       (send* _blobsArray __blobsArray)
     (progn
       (if __blobsArray (setq _blobsArray (car __blobsArray)))
       _blobsArray)))
  (:tracking_id
   (&optional __tracking_id)
   (if __tracking_id (setq _tracking_id __tracking_id)) _tracking_id)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; geometry_msgs/Pose[] _poses
    (apply #'+ (send-all _poses :serialization-length)) 4
    ;; nesfr3_msgs/Blobs[] _blobsArray
    (apply #'+ (send-all _blobsArray :serialization-length)) 4
    ;; int32[] _tracking_id
    (* 4    (length _tracking_id)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; geometry_msgs/Pose[] _poses
     (write-long (length _poses) s)
     (dolist (elem _poses)
       (send elem :serialize s)
       )
     ;; nesfr3_msgs/Blobs[] _blobsArray
     (write-long (length _blobsArray) s)
     (dolist (elem _blobsArray)
       (send elem :serialize s)
       )
     ;; int32[] _tracking_id
     (write-long (length _tracking_id) s)
     (dotimes (i (length _tracking_id))
       (write-long (elt _tracking_id i) s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; geometry_msgs/Pose[] _poses
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _poses (let (r) (dotimes (i n) (push (instance geometry_msgs::Pose :init) r)) r))
     (dolist (elem- _poses)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;; nesfr3_msgs/Blobs[] _blobsArray
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _blobsArray (let (r) (dotimes (i n) (push (instance nesfr3_msgs::Blobs :init) r)) r))
     (dolist (elem- _blobsArray)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;; int32[] _tracking_id
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _tracking_id (instantiate integer-vector n))
     (dotimes (i n)
     (setf (elt _tracking_id i) (sys::peek buf ptr- :integer)) (incf ptr- 4)
     ))
   ;;
   self)
  )

(setf (get nesfr3_msgs::BlobsArray :md5sum-) "a4470e8359735d32f7fb025238b974ce")
(setf (get nesfr3_msgs::BlobsArray :datatype-) "nesfr3_msgs/BlobsArray")
(setf (get nesfr3_msgs::BlobsArray :definition-)
      "Header header

geometry_msgs/Pose[] poses
Blobs[] blobsArray
int32[] tracking_id
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
MSG: nesfr3_msgs/Blobs
int32 cluster_id
Blob[] blobs
================================================================================
MSG: nesfr3_msgs/Blob
int32 x
int32 y
int32 width
int32 height

")



(provide :nesfr3_msgs/BlobsArray "a4470e8359735d32f7fb025238b974ce")


