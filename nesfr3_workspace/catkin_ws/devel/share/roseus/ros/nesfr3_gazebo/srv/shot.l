;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_gazebo::shot)
  (if (not (find-package "NESFR3_GAZEBO"))
    (make-package "NESFR3_GAZEBO"))
  (shadow 'shot (find-package "NESFR3_GAZEBO")))
(unless (find-package "NESFR3_GAZEBO::SHOT")
  (make-package "NESFR3_GAZEBO::SHOT"))
(unless (find-package "NESFR3_GAZEBO::SHOTREQUEST")
  (make-package "NESFR3_GAZEBO::SHOTREQUEST"))
(unless (find-package "NESFR3_GAZEBO::SHOTRESPONSE")
  (make-package "NESFR3_GAZEBO::SHOTRESPONSE"))

(in-package "ROS")

(if (not (find-package "GEOMETRY_MSGS"))
  (ros::roseus-add-msgs "geometry_msgs"))


(if (not (find-package "SENSOR_MSGS"))
  (ros::roseus-add-msgs "sensor_msgs"))


(defclass nesfr3_gazebo::shotRequest
  :super ros::object
  :slots (_human_id _distance _direction _shot_size ))

(defmethod nesfr3_gazebo::shotRequest
  (:init
   (&key
    ((:human_id __human_id) 0)
    ((:distance __distance) 0.0)
    ((:direction __direction) (instance geometry_msgs::Vector3 :init))
    ((:shot_size __shot_size) "")
    )
   (send-super :init)
   (setq _human_id (round __human_id))
   (setq _distance (float __distance))
   (setq _direction __direction)
   (setq _shot_size (string __shot_size))
   self)
  (:human_id
   (&optional __human_id)
   (if __human_id (setq _human_id __human_id)) _human_id)
  (:distance
   (&optional __distance)
   (if __distance (setq _distance __distance)) _distance)
  (:direction
   (&rest __direction)
   (if (keywordp (car __direction))
       (send* _direction __direction)
     (progn
       (if __direction (setq _direction (car __direction)))
       _direction)))
  (:shot_size
   (&optional __shot_size)
   (if __shot_size (setq _shot_size __shot_size)) _shot_size)
  (:serialization-length
   ()
   (+
    ;; int64 _human_id
    8
    ;; float64 _distance
    8
    ;; geometry_msgs/Vector3 _direction
    (send _direction :serialization-length)
    ;; string _shot_size
    4 (length _shot_size)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int64 _human_id
#+(or :alpha :irix6 :x86_64)
       (progn (sys::poke _human_id (send s :buffer) (send s :count) :long) (incf (stream-count s) 8))
#-(or :alpha :irix6 :x86_64)
       (cond ((and (class _human_id) (= (length (_human_id . bv)) 2)) ;; bignum
              (write-long (ash (elt (_human_id . bv) 0) 0) s)
              (write-long (ash (elt (_human_id . bv) 1) -1) s))
             ((and (class _human_id) (= (length (_human_id . bv)) 1)) ;; big1
              (write-long (elt (_human_id . bv) 0) s)
              (write-long (if (>= _human_id 0) 0 #xffffffff) s))
             (t                                         ;; integer
              (write-long _human_id s)(write-long (if (>= _human_id 0) 0 #xffffffff) s)))
     ;; float64 _distance
       (sys::poke _distance (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; geometry_msgs/Vector3 _direction
       (send _direction :serialize s)
     ;; string _shot_size
       (write-long (length _shot_size) s) (princ _shot_size s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int64 _human_id
#+(or :alpha :irix6 :x86_64)
      (setf _human_id (prog1 (sys::peek buf ptr- :long) (incf ptr- 8)))
#-(or :alpha :irix6 :x86_64)
      (setf _human_id (let ((b0 (prog1 (sys::peek buf ptr- :integer) (incf ptr- 4)))
                  (b1 (prog1 (sys::peek buf ptr- :integer) (incf ptr- 4))))
              (cond ((= b1 -1) b0)
                     ((and (= b1  0)
                           (<= lisp::most-negative-fixnum b0 lisp::most-positive-fixnum))
                      b0)
                    ((= b1  0) (make-instance bignum :size 1 :bv (integer-vector b0)))
                    (t (make-instance bignum :size 2 :bv (integer-vector b0 (ash b1 1)))))))
   ;; float64 _distance
     (setq _distance (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; geometry_msgs/Vector3 _direction
     (send _direction :deserialize buf ptr-) (incf ptr- (send _direction :serialization-length))
   ;; string _shot_size
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _shot_size (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;;
   self)
  )

(defclass nesfr3_gazebo::shotResponse
  :super ros::object
  :slots (_shot ))

(defmethod nesfr3_gazebo::shotResponse
  (:init
   (&key
    ((:shot __shot) (instance sensor_msgs::Image :init))
    )
   (send-super :init)
   (setq _shot __shot)
   self)
  (:shot
   (&rest __shot)
   (if (keywordp (car __shot))
       (send* _shot __shot)
     (progn
       (if __shot (setq _shot (car __shot)))
       _shot)))
  (:serialization-length
   ()
   (+
    ;; sensor_msgs/Image _shot
    (send _shot :serialization-length)
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; sensor_msgs/Image _shot
       (send _shot :serialize s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; sensor_msgs/Image _shot
     (send _shot :deserialize buf ptr-) (incf ptr- (send _shot :serialization-length))
   ;;
   self)
  )

(defclass nesfr3_gazebo::shot
  :super ros::object
  :slots ())

(setf (get nesfr3_gazebo::shot :md5sum-) "635e9215bafe4f59d545a92d1d2ef52b")
(setf (get nesfr3_gazebo::shot :datatype-) "nesfr3_gazebo/shot")
(setf (get nesfr3_gazebo::shot :request) nesfr3_gazebo::shotRequest)
(setf (get nesfr3_gazebo::shot :response) nesfr3_gazebo::shotResponse)

(defmethod nesfr3_gazebo::shotRequest
  (:response () (instance nesfr3_gazebo::shotResponse :init)))

(setf (get nesfr3_gazebo::shotRequest :md5sum-) "635e9215bafe4f59d545a92d1d2ef52b")
(setf (get nesfr3_gazebo::shotRequest :datatype-) "nesfr3_gazebo/shotRequest")
(setf (get nesfr3_gazebo::shotRequest :definition-)
      "int64 human_id
float64 distance
geometry_msgs/Vector3 direction
string shot_size


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
---

sensor_msgs/Image shot




================================================================================
MSG: sensor_msgs/Image
# This message contains an uncompressed image
# (0, 0) is at top-left corner of image
#

Header header        # Header timestamp should be acquisition time of image
                     # Header frame_id should be optical frame of camera
                     # origin of frame should be optical center of camera
                     # +x should point to the right in the image
                     # +y should point down in the image
                     # +z should point into to plane of the image
                     # If the frame_id here and the frame_id of the CameraInfo
                     # message associated with the image conflict
                     # the behavior is undefined

uint32 height         # image height, that is, number of rows
uint32 width          # image width, that is, number of columns

# The legal values for encoding are in file src/image_encodings.cpp
# If you want to standardize a new string format, join
# ros-users@lists.sourceforge.net and send an email proposing a new encoding.

string encoding       # Encoding of pixels -- channel meaning, ordering, size
                      # taken from the list of strings in include/sensor_msgs/image_encodings.h

uint8 is_bigendian    # is this data bigendian?
uint32 step           # Full row length in bytes
uint8[] data          # actual matrix data, size is (step * rows)

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

(setf (get nesfr3_gazebo::shotResponse :md5sum-) "635e9215bafe4f59d545a92d1d2ef52b")
(setf (get nesfr3_gazebo::shotResponse :datatype-) "nesfr3_gazebo/shotResponse")
(setf (get nesfr3_gazebo::shotResponse :definition-)
      "int64 human_id
float64 distance
geometry_msgs/Vector3 direction
string shot_size


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
---

sensor_msgs/Image shot




================================================================================
MSG: sensor_msgs/Image
# This message contains an uncompressed image
# (0, 0) is at top-left corner of image
#

Header header        # Header timestamp should be acquisition time of image
                     # Header frame_id should be optical frame of camera
                     # origin of frame should be optical center of camera
                     # +x should point to the right in the image
                     # +y should point down in the image
                     # +z should point into to plane of the image
                     # If the frame_id here and the frame_id of the CameraInfo
                     # message associated with the image conflict
                     # the behavior is undefined

uint32 height         # image height, that is, number of rows
uint32 width          # image width, that is, number of columns

# The legal values for encoding are in file src/image_encodings.cpp
# If you want to standardize a new string format, join
# ros-users@lists.sourceforge.net and send an email proposing a new encoding.

string encoding       # Encoding of pixels -- channel meaning, ordering, size
                      # taken from the list of strings in include/sensor_msgs/image_encodings.h

uint8 is_bigendian    # is this data bigendian?
uint32 step           # Full row length in bytes
uint8[] data          # actual matrix data, size is (step * rows)

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



(provide :nesfr3_gazebo/shot "635e9215bafe4f59d545a92d1d2ef52b")


