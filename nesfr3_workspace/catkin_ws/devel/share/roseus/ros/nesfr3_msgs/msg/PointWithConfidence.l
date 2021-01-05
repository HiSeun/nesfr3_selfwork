;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::PointWithConfidence)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'PointWithConfidence (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::POINTWITHCONFIDENCE")
  (make-package "NESFR3_MSGS::POINTWITHCONFIDENCE"))

(in-package "ROS")
;;//! \htmlinclude PointWithConfidence.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass nesfr3_msgs::PointWithConfidence
  :super ros::object
  :slots (_point _confidence ))

(defmethod nesfr3_msgs::PointWithConfidence
  (:init
   (&key
    ((:point __point) (instance geometry_msgs::Point :init))
    ((:confidence __confidence) 0.0)
    )
   (send-super :init)
   (setq _point __point)
   (setq _confidence (float __confidence))
   self)
  (:point
   (&rest __point)
   (if (keywordp (car __point))
       (send* _point __point)
     (progn
       (if __point (setq _point (car __point)))
       _point)))
  (:confidence
   (&optional __confidence)
   (if __confidence (setq _confidence __confidence)) _confidence)
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/Point _point
    (send _point :serialization-length)
    ;; float32 _confidence
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/Point _point
       (send _point :serialize s)
     ;; float32 _confidence
       (sys::poke _confidence (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/Point _point
     (send _point :deserialize buf ptr-) (incf ptr- (send _point :serialization-length))
   ;; float32 _confidence
     (setq _confidence (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get nesfr3_msgs::PointWithConfidence :md5sum-) "47cab856215e2b01d6eb9ac884ec9042")
(setf (get nesfr3_msgs::PointWithConfidence :datatype-) "nesfr3_msgs/PointWithConfidence")
(setf (get nesfr3_msgs::PointWithConfidence :definition-)
      "geometry_msgs/Point point
float32 confidence

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :nesfr3_msgs/PointWithConfidence "47cab856215e2b01d6eb9ac884ec9042")


