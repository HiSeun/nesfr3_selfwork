; Auto-generated. Do not edit!


(cl:in-package nesfr3_gazebo-srv)


;//! \htmlinclude shot-request.msg.html

(cl:defclass <shot-request> (roslisp-msg-protocol:ros-message)
  ((human_id
    :reader human_id
    :initarg :human_id
    :type cl:integer
    :initform 0)
   (distance
    :reader distance
    :initarg :distance
    :type cl:float
    :initform 0.0)
   (direction
    :reader direction
    :initarg :direction
    :type geometry_msgs-msg:Vector3
    :initform (cl:make-instance 'geometry_msgs-msg:Vector3))
   (shot_size
    :reader shot_size
    :initarg :shot_size
    :type cl:string
    :initform ""))
)

(cl:defclass shot-request (<shot-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <shot-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'shot-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_gazebo-srv:<shot-request> is deprecated: use nesfr3_gazebo-srv:shot-request instead.")))

(cl:ensure-generic-function 'human_id-val :lambda-list '(m))
(cl:defmethod human_id-val ((m <shot-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_gazebo-srv:human_id-val is deprecated.  Use nesfr3_gazebo-srv:human_id instead.")
  (human_id m))

(cl:ensure-generic-function 'distance-val :lambda-list '(m))
(cl:defmethod distance-val ((m <shot-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_gazebo-srv:distance-val is deprecated.  Use nesfr3_gazebo-srv:distance instead.")
  (distance m))

(cl:ensure-generic-function 'direction-val :lambda-list '(m))
(cl:defmethod direction-val ((m <shot-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_gazebo-srv:direction-val is deprecated.  Use nesfr3_gazebo-srv:direction instead.")
  (direction m))

(cl:ensure-generic-function 'shot_size-val :lambda-list '(m))
(cl:defmethod shot_size-val ((m <shot-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_gazebo-srv:shot_size-val is deprecated.  Use nesfr3_gazebo-srv:shot_size instead.")
  (shot_size m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <shot-request>) ostream)
  "Serializes a message object of type '<shot-request>"
  (cl:let* ((signed (cl:slot-value msg 'human_id)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 18446744073709551616) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) unsigned) ostream)
    )
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'distance))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'direction) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'shot_size))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'shot_size))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <shot-request>) istream)
  "Deserializes a message object of type '<shot-request>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'human_id) (cl:if (cl:< unsigned 9223372036854775808) unsigned (cl:- unsigned 18446744073709551616))))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'distance) (roslisp-utils:decode-double-float-bits bits)))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'direction) istream)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'shot_size) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'shot_size) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<shot-request>)))
  "Returns string type for a service object of type '<shot-request>"
  "nesfr3_gazebo/shotRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'shot-request)))
  "Returns string type for a service object of type 'shot-request"
  "nesfr3_gazebo/shotRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<shot-request>)))
  "Returns md5sum for a message object of type '<shot-request>"
  "635e9215bafe4f59d545a92d1d2ef52b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'shot-request)))
  "Returns md5sum for a message object of type 'shot-request"
  "635e9215bafe4f59d545a92d1d2ef52b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<shot-request>)))
  "Returns full string definition for message of type '<shot-request>"
  (cl:format cl:nil "int64 human_id~%float64 distance~%geometry_msgs/Vector3 direction~%string shot_size~%~%~%================================================================================~%MSG: geometry_msgs/Vector3~%# This represents a vector in free space. ~%# It is only meant to represent a direction. Therefore, it does not~%# make sense to apply a translation to it (e.g., when applying a ~%# generic rigid transformation to a Vector3, tf2 will only apply the~%# rotation). If you want your data to be translatable too, use the~%# geometry_msgs/Point message instead.~%~%float64 x~%float64 y~%float64 z~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'shot-request)))
  "Returns full string definition for message of type 'shot-request"
  (cl:format cl:nil "int64 human_id~%float64 distance~%geometry_msgs/Vector3 direction~%string shot_size~%~%~%================================================================================~%MSG: geometry_msgs/Vector3~%# This represents a vector in free space. ~%# It is only meant to represent a direction. Therefore, it does not~%# make sense to apply a translation to it (e.g., when applying a ~%# generic rigid transformation to a Vector3, tf2 will only apply the~%# rotation). If you want your data to be translatable too, use the~%# geometry_msgs/Point message instead.~%~%float64 x~%float64 y~%float64 z~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <shot-request>))
  (cl:+ 0
     8
     8
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'direction))
     4 (cl:length (cl:slot-value msg 'shot_size))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <shot-request>))
  "Converts a ROS message object to a list"
  (cl:list 'shot-request
    (cl:cons ':human_id (human_id msg))
    (cl:cons ':distance (distance msg))
    (cl:cons ':direction (direction msg))
    (cl:cons ':shot_size (shot_size msg))
))
;//! \htmlinclude shot-response.msg.html

(cl:defclass <shot-response> (roslisp-msg-protocol:ros-message)
  ((shot
    :reader shot
    :initarg :shot
    :type sensor_msgs-msg:Image
    :initform (cl:make-instance 'sensor_msgs-msg:Image)))
)

(cl:defclass shot-response (<shot-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <shot-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'shot-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_gazebo-srv:<shot-response> is deprecated: use nesfr3_gazebo-srv:shot-response instead.")))

(cl:ensure-generic-function 'shot-val :lambda-list '(m))
(cl:defmethod shot-val ((m <shot-response>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_gazebo-srv:shot-val is deprecated.  Use nesfr3_gazebo-srv:shot instead.")
  (shot m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <shot-response>) ostream)
  "Serializes a message object of type '<shot-response>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'shot) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <shot-response>) istream)
  "Deserializes a message object of type '<shot-response>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'shot) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<shot-response>)))
  "Returns string type for a service object of type '<shot-response>"
  "nesfr3_gazebo/shotResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'shot-response)))
  "Returns string type for a service object of type 'shot-response"
  "nesfr3_gazebo/shotResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<shot-response>)))
  "Returns md5sum for a message object of type '<shot-response>"
  "635e9215bafe4f59d545a92d1d2ef52b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'shot-response)))
  "Returns md5sum for a message object of type 'shot-response"
  "635e9215bafe4f59d545a92d1d2ef52b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<shot-response>)))
  "Returns full string definition for message of type '<shot-response>"
  (cl:format cl:nil "~%sensor_msgs/Image shot~%~%~%~%~%================================================================================~%MSG: sensor_msgs/Image~%# This message contains an uncompressed image~%# (0, 0) is at top-left corner of image~%#~%~%Header header        # Header timestamp should be acquisition time of image~%                     # Header frame_id should be optical frame of camera~%                     # origin of frame should be optical center of camera~%                     # +x should point to the right in the image~%                     # +y should point down in the image~%                     # +z should point into to plane of the image~%                     # If the frame_id here and the frame_id of the CameraInfo~%                     # message associated with the image conflict~%                     # the behavior is undefined~%~%uint32 height         # image height, that is, number of rows~%uint32 width          # image width, that is, number of columns~%~%# The legal values for encoding are in file src/image_encodings.cpp~%# If you want to standardize a new string format, join~%# ros-users@lists.sourceforge.net and send an email proposing a new encoding.~%~%string encoding       # Encoding of pixels -- channel meaning, ordering, size~%                      # taken from the list of strings in include/sensor_msgs/image_encodings.h~%~%uint8 is_bigendian    # is this data bigendian?~%uint32 step           # Full row length in bytes~%uint8[] data          # actual matrix data, size is (step * rows)~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'shot-response)))
  "Returns full string definition for message of type 'shot-response"
  (cl:format cl:nil "~%sensor_msgs/Image shot~%~%~%~%~%================================================================================~%MSG: sensor_msgs/Image~%# This message contains an uncompressed image~%# (0, 0) is at top-left corner of image~%#~%~%Header header        # Header timestamp should be acquisition time of image~%                     # Header frame_id should be optical frame of camera~%                     # origin of frame should be optical center of camera~%                     # +x should point to the right in the image~%                     # +y should point down in the image~%                     # +z should point into to plane of the image~%                     # If the frame_id here and the frame_id of the CameraInfo~%                     # message associated with the image conflict~%                     # the behavior is undefined~%~%uint32 height         # image height, that is, number of rows~%uint32 width          # image width, that is, number of columns~%~%# The legal values for encoding are in file src/image_encodings.cpp~%# If you want to standardize a new string format, join~%# ros-users@lists.sourceforge.net and send an email proposing a new encoding.~%~%string encoding       # Encoding of pixels -- channel meaning, ordering, size~%                      # taken from the list of strings in include/sensor_msgs/image_encodings.h~%~%uint8 is_bigendian    # is this data bigendian?~%uint32 step           # Full row length in bytes~%uint8[] data          # actual matrix data, size is (step * rows)~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <shot-response>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'shot))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <shot-response>))
  "Converts a ROS message object to a list"
  (cl:list 'shot-response
    (cl:cons ':shot (shot msg))
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'shot)))
  'shot-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'shot)))
  'shot-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'shot)))
  "Returns string type for a service object of type '<shot>"
  "nesfr3_gazebo/shot")