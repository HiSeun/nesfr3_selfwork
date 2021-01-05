;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::ClusterProps)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'ClusterProps (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::CLUSTERPROPS")
  (make-package "NESFR3_MSGS::CLUSTERPROPS"))

(in-package "ROS")
;;//! \htmlinclude ClusterProps.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass nesfr3_msgs::ClusterProps
  :super ros::object
  :slots (_min _max _centroid ))

(defmethod nesfr3_msgs::ClusterProps
  (:init
   (&key
    ((:min __min) (instance geometry_msgs::Point :init))
    ((:max __max) (instance geometry_msgs::Point :init))
    ((:centroid __centroid) (instance geometry_msgs::Point :init))
    )
   (send-super :init)
   (setq _min __min)
   (setq _max __max)
   (setq _centroid __centroid)
   self)
  (:min
   (&rest __min)
   (if (keywordp (car __min))
       (send* _min __min)
     (progn
       (if __min (setq _min (car __min)))
       _min)))
  (:max
   (&rest __max)
   (if (keywordp (car __max))
       (send* _max __max)
     (progn
       (if __max (setq _max (car __max)))
       _max)))
  (:centroid
   (&rest __centroid)
   (if (keywordp (car __centroid))
       (send* _centroid __centroid)
     (progn
       (if __centroid (setq _centroid (car __centroid)))
       _centroid)))
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/Point _min
    (send _min :serialization-length)
    ;; geometry_msgs/Point _max
    (send _max :serialization-length)
    ;; geometry_msgs/Point _centroid
    (send _centroid :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/Point _min
       (send _min :serialize s)
     ;; geometry_msgs/Point _max
       (send _max :serialize s)
     ;; geometry_msgs/Point _centroid
       (send _centroid :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/Point _min
     (send _min :deserialize buf ptr-) (incf ptr- (send _min :serialization-length))
   ;; geometry_msgs/Point _max
     (send _max :deserialize buf ptr-) (incf ptr- (send _max :serialization-length))
   ;; geometry_msgs/Point _centroid
     (send _centroid :deserialize buf ptr-) (incf ptr- (send _centroid :serialization-length))
   ;;
   self)
  )

(setf (get nesfr3_msgs::ClusterProps :md5sum-) "bf114ed0bf971d15566ddf96d426a32a")
(setf (get nesfr3_msgs::ClusterProps :datatype-) "nesfr3_msgs/ClusterProps")
(setf (get nesfr3_msgs::ClusterProps :definition-)
      "geometry_msgs/Point min
geometry_msgs/Point max
geometry_msgs/Point centroid
================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

")



(provide :nesfr3_msgs/ClusterProps "bf114ed0bf971d15566ddf96d426a32a")


