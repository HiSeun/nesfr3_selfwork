;; Auto-generated. Do not edit!


(when (boundp 'hdl_people_tracking::Track)
  (if (not (find-package "HDL_PEOPLE_TRACKING"))
    (make-package "HDL_PEOPLE_TRACKING"))
  (shadow 'Track (find-package "HDL_PEOPLE_TRACKING")))
(unless (find-package "HDL_PEOPLE_TRACKING::TRACK")
  (make-package "HDL_PEOPLE_TRACKING::TRACK"))

(in-package "ROS")
;;//! \htmlinclude Track.msg.html
(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(defclass hdl_people_tracking::Track
  :super ros::object
  :slots (_id _age _pos _vel _pos_cov _vel_cov _associated ))

(defmethod hdl_people_tracking::Track
  (:init
   (&key
    ((:id __id) 0)
    ((:age __age) 0.0)
    ((:pos __pos) (instance geometry_msgs::Point :init))
    ((:vel __vel) (instance geometry_msgs::Vector3 :init))
    ((:pos_cov __pos_cov) (make-array 9 :initial-element 0.0 :element-type :float))
    ((:vel_cov __vel_cov) (make-array 9 :initial-element 0.0 :element-type :float))
    ((:associated __associated) (let (r) (dotimes (i 0) (push (instance hdl_people_tracking::Cluster :init) r)) r))
    )
   (send-super :init)
   (setq _id (round __id))
   (setq _age (float __age))
   (setq _pos __pos)
   (setq _vel __vel)
   (setq _pos_cov __pos_cov)
   (setq _vel_cov __vel_cov)
   (setq _associated __associated)
   self)
  (:id
   (&optional __id)
   (if __id (setq _id __id)) _id)
  (:age
   (&optional __age)
   (if __age (setq _age __age)) _age)
  (:pos
   (&rest __pos)
   (if (keywordp (car __pos))
       (send* _pos __pos)
     (progn
       (if __pos (setq _pos (car __pos)))
       _pos)))
  (:vel
   (&rest __vel)
   (if (keywordp (car __vel))
       (send* _vel __vel)
     (progn
       (if __vel (setq _vel (car __vel)))
       _vel)))
  (:pos_cov
   (&optional __pos_cov)
   (if __pos_cov (setq _pos_cov __pos_cov)) _pos_cov)
  (:vel_cov
   (&optional __vel_cov)
   (if __vel_cov (setq _vel_cov __vel_cov)) _vel_cov)
  (:associated
   (&rest __associated)
   (if (keywordp (car __associated))
       (send* _associated __associated)
     (progn
       (if __associated (setq _associated (car __associated)))
       _associated)))
  (:serialization-length
   ()
   (+
    ;; int32 _id
    4
    ;; float64 _age
    8
    ;; geometry_msgs/Point _pos
    (send _pos :serialization-length)
    ;; geometry_msgs/Vector3 _vel
    (send _vel :serialization-length)
    ;; float64[9] _pos_cov
    (* 8    9)
    ;; float64[9] _vel_cov
    (* 8    9)
    ;; hdl_people_tracking/Cluster[] _associated
    (apply #'+ (send-all _associated :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _id
       (write-long _id s)
     ;; float64 _age
       (sys::poke _age (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; geometry_msgs/Point _pos
       (send _pos :serialize s)
     ;; geometry_msgs/Vector3 _vel
       (send _vel :serialize s)
     ;; float64[9] _pos_cov
     (dotimes (i 9)
       (sys::poke (elt _pos_cov i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; float64[9] _vel_cov
     (dotimes (i 9)
       (sys::poke (elt _vel_cov i) (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
       )
     ;; hdl_people_tracking/Cluster[] _associated
     (write-long (length _associated) s)
     (dolist (elem _associated)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _id
     (setq _id (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; float64 _age
     (setq _age (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; geometry_msgs/Point _pos
     (send _pos :deserialize buf ptr-) (incf ptr- (send _pos :serialization-length))
   ;; geometry_msgs/Vector3 _vel
     (send _vel :deserialize buf ptr-) (incf ptr- (send _vel :serialization-length))
   ;; float64[9] _pos_cov
   (dotimes (i (length _pos_cov))
     (setf (elt _pos_cov i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     )
   ;; float64[9] _vel_cov
   (dotimes (i (length _vel_cov))
     (setf (elt _vel_cov i) (sys::peek buf ptr- :double)) (incf ptr- 8)
     )
   ;; hdl_people_tracking/Cluster[] _associated
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _associated (let (r) (dotimes (i n) (push (instance hdl_people_tracking::Cluster :init) r)) r))
     (dolist (elem- _associated)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get hdl_people_tracking::Track :md5sum-) "527d334e3f10954bd65c67a79b62ccc6")
(setf (get hdl_people_tracking::Track :datatype-) "hdl_people_tracking/Track")
(setf (get hdl_people_tracking::Track :definition-)
      "int32 id
float64 age
geometry_msgs/Point pos
geometry_msgs/Vector3 vel

float64[9] pos_cov
float64[9] vel_cov

hdl_people_tracking/Cluster[] associated

================================================================================
MSG: geometry_msgs/Point
# This contains the position of a point in free space
float64 x
float64 y
float64 z

================================================================================
MSG: geometry_msgs/Vector3
# This represents a vector in free space. 
# It is only meant to represent a direction. Therefore, it does not
# make sense to apply a translation to it (e.g., when applying a 
# generic rigid transformation to a Vector3, tf2 will only apply the
# rotation). If you want your data to be translatable too, use the
# geometry_msgs/Point message instead.

float64 x
float64 y
float64 z
================================================================================
MSG: hdl_people_tracking/Cluster
bool is_human

geometry_msgs/Point min_pt
geometry_msgs/Point max_pt
geometry_msgs/Vector3 size
geometry_msgs/Point centroid

")



(provide :hdl_people_tracking/Track "527d334e3f10954bd65c67a79b62ccc6")


