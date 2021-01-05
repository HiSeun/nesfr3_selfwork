;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::Actor2d)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'Actor2d (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::ACTOR2D")
  (make-package "NESFR3_MSGS::ACTOR2D"))

(in-package "ROS")
;;//! \htmlinclude Actor2d.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass nesfr3_msgs::Actor2d
  :super ros::object
  :slots (_points ))

(defmethod nesfr3_msgs::Actor2d
  (:init
   (&key
    ((:points __points) (let (r) (dotimes (i 18) (push (instance geometry_msgs::Point :init) r)) r))
    )
   (send-super :init)
   (setq _points __points)
   self)
  (:points
   (&rest __points)
   (if (keywordp (car __points))
       (send* _points __points)
     (progn
       (if __points (setq _points (car __points)))
       _points)))
  (:serialization-length
   ()
   (+
    ;; geometry_msgs/Point[18] _points
    (apply #'+ (send-all _points :serialization-length))
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; geometry_msgs/Point[18] _points
     (dolist (elem _points)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; geometry_msgs/Point[18] _points
   (dotimes (i 18)
     (send (elt _points i) :deserialize buf ptr-) (incf ptr- (send (elt _points i) :serialization-length))
     )
   ;;
   self)
  )

(setf (get nesfr3_msgs::Actor2d :md5sum-) "3fb3f9dacc279b964c4c8341122c34df")
(setf (get nesfr3_msgs::Actor2d :datatype-) "nesfr3_msgs/Actor2d")
(setf (get nesfr3_msgs::Actor2d :definition-)
      "geometry_msgs/Point[18] points          # skeleton points from pose estimation
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



(provide :nesfr3_msgs/Actor2d "3fb3f9dacc279b964c4c8341122c34df")


