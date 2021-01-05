;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::Actors2d)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'Actors2d (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::ACTORS2D")
  (make-package "NESFR3_MSGS::ACTORS2D"))

(in-package "ROS")
;;//! \htmlinclude Actors2d.msg.html
(if (not (find-package "STD_MSGS"))
  (ros::roseus-add-msgs "std_msgs"))


(defclass nesfr3_msgs::Actors2d
  :super ros::object
  :slots (_header _actors2d ))

(defmethod nesfr3_msgs::Actors2d
  (:init
   (&key
    ((:header __header) (instance std_msgs::Header :init))
    ((:actors2d __actors2d) (let (r) (dotimes (i 0) (push (instance nesfr3_msgs::Actor2d :init) r)) r))
    )
   (send-super :init)
   (setq _header __header)
   (setq _actors2d __actors2d)
   self)
  (:header
   (&rest __header)
   (if (keywordp (car __header))
       (send* _header __header)
     (progn
       (if __header (setq _header (car __header)))
       _header)))
  (:actors2d
   (&rest __actors2d)
   (if (keywordp (car __actors2d))
       (send* _actors2d __actors2d)
     (progn
       (if __actors2d (setq _actors2d (car __actors2d)))
       _actors2d)))
  (:serialization-length
   ()
   (+
    ;; std_msgs/Header _header
    (send _header :serialization-length)
    ;; nesfr3_msgs/Actor2d[] _actors2d
    (apply #'+ (send-all _actors2d :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; std_msgs/Header _header
       (send _header :serialize s)
     ;; nesfr3_msgs/Actor2d[] _actors2d
     (write-long (length _actors2d) s)
     (dolist (elem _actors2d)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; std_msgs/Header _header
     (send _header :deserialize buf ptr-) (incf ptr- (send _header :serialization-length))
   ;; nesfr3_msgs/Actor2d[] _actors2d
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _actors2d (let (r) (dotimes (i n) (push (instance nesfr3_msgs::Actor2d :init) r)) r))
     (dolist (elem- _actors2d)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get nesfr3_msgs::Actors2d :md5sum-) "c1bee49e25f0b078e91e5e00c305ebd5")
(setf (get nesfr3_msgs::Actors2d :datatype-) "nesfr3_msgs/Actors2d")
(setf (get nesfr3_msgs::Actors2d :definition-)
      "Header header   # For frame_id and timestamp
Actor2d[] actors2d

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
MSG: nesfr3_msgs/Actor2d
geometry_msgs/Point[18] points          # skeleton points from pose estimation
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

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :nesfr3_msgs/Actors2d "c1bee49e25f0b078e91e5e00c305ebd5")


