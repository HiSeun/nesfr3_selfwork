;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::TrackingData)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'TrackingData (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::TRACKINGDATA")
  (make-package "NESFR3_MSGS::TRACKINGDATA"))

(in-package "ROS")
;;//! \htmlinclude TrackingData.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass nesfr3_msgs::TrackingData
  :super ros::object
  :slots (_header _id_num _tracking_id ))

(defmethod nesfr3_msgs::TrackingData
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:id_num __id_num) (make-array 0 :initial-element 0 :element-type :integer))
    ((:tracking_id __tracking_id) (make-array 0 :initial-element 0 :element-type :integer))
    )
   (send-super :init)
   (setq _header __header)
   (setq _id_num __id_num)
   (setq _tracking_id __tracking_id)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:id_num
   (&optional __id_num)
   (if __id_num (setq _id_num __id_num)) _id_num)
  (:tracking_id
   (&optional __tracking_id)
   (if __tracking_id (setq _tracking_id __tracking_id)) _tracking_id)
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; int32[] _id_num
    (* 4    (length _id_num)) 4
    ;; int32[] _tracking_id
    (* 4    (length _tracking_id)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; int32[] _id_num
     (write-long (length _id_num) s)
     (dotimes (i (length _id_num))
       (write-long (elt _id_num i) s)
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
   ;; int32[] _id_num
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _id_num (instantiate integer-vector n))
     (dotimes (i n)
     (setf (elt _id_num i) (sys::peek buf ptr- :integer)) (incf ptr- 4)
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

(setf (get nesfr3_msgs::TrackingData :md5sum-) "248c310616213a43cbb9e8c32deef897")
(setf (get nesfr3_msgs::TrackingData :datatype-) "nesfr3_msgs/TrackingData")
(setf (get nesfr3_msgs::TrackingData :definition-)
      "Header header

int32[] id_num
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

")



(provide :nesfr3_msgs/TrackingData "248c310616213a43cbb9e8c32deef897")


