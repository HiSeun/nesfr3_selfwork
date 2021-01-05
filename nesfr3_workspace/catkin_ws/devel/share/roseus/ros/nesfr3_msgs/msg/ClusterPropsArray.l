;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::ClusterPropsArray)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'ClusterPropsArray (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::CLUSTERPROPSARRAY")
  (make-package "NESFR3_MSGS::CLUSTERPROPSARRAY"))

(in-package "ROS")
;;//! \htmlinclude ClusterPropsArray.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass nesfr3_msgs::ClusterPropsArray
  :super ros::object
  :slots (_header _ClusterPropsArray ))

(defmethod nesfr3_msgs::ClusterPropsArray
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:ClusterPropsArray __ClusterPropsArray) (let (r) (dotimes (i 0) (push (instance nesfr3_msgs::ClusterProps :init) r)) r))
    )
   (send-super :init)
   (setq _header __header)
   (setq _ClusterPropsArray __ClusterPropsArray)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:ClusterPropsArray
   (&rest __ClusterPropsArray)
   (if (keywordp (car __ClusterPropsArray))
       (send* _ClusterPropsArray __ClusterPropsArray)
     (progn
       (if __ClusterPropsArray (setq _ClusterPropsArray (car __ClusterPropsArray)))
       _ClusterPropsArray)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; nesfr3_msgs/ClusterProps[] _ClusterPropsArray
    (apply #'+ (send-all _ClusterPropsArray :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; nesfr3_msgs/ClusterProps[] _ClusterPropsArray
     (write-long (length _ClusterPropsArray) s)
     (dolist (elem _ClusterPropsArray)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; nesfr3_msgs/ClusterProps[] _ClusterPropsArray
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _ClusterPropsArray (let (r) (dotimes (i n) (push (instance nesfr3_msgs::ClusterProps :init) r)) r))
     (dolist (elem- _ClusterPropsArray)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get nesfr3_msgs::ClusterPropsArray :md5sum-) "4608baf7edd9b6be483773f66e382aa3")
(setf (get nesfr3_msgs::ClusterPropsArray :datatype-) "nesfr3_msgs/ClusterPropsArray")
(setf (get nesfr3_msgs::ClusterPropsArray :definition-)
      "Header header

ClusterProps[] ClusterPropsArray
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
MSG: nesfr3_msgs/ClusterProps
geometry_msgs/Point min
geometry_msgs/Point max
geometry_msgs/Point centroid
================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :nesfr3_msgs/ClusterPropsArray "4608baf7edd9b6be483773f66e382aa3")


