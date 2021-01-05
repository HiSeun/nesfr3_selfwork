; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude Actor.msg.html

(cl:defclass <Actor> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (name
    :reader name
    :initarg :name
    :type cl:string
    :initform "")
   (tracking_id
    :reader tracking_id
    :initarg :tracking_id
    :type cl:integer
    :initform 0)
   (pose
    :reader pose
    :initarg :pose
    :type geometry_msgs-msg:PoseWithCovariance
    :initform (cl:make-instance 'geometry_msgs-msg:PoseWithCovariance))
   (points
    :reader points
    :initarg :points
    :type (cl:vector nesfr3_msgs-msg:PointWithConfidence)
   :initform (cl:make-array 18 :element-type 'nesfr3_msgs-msg:PointWithConfidence :initial-element (cl:make-instance 'nesfr3_msgs-msg:PointWithConfidence)))
   (nose_point
    :reader nose_point
    :initarg :nose_point
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point)))
)

(cl:defclass Actor (<Actor>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Actor>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Actor)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<Actor> is deprecated: use nesfr3_msgs-msg:Actor instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Actor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:header-val is deprecated.  Use nesfr3_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'name-val :lambda-list '(m))
(cl:defmethod name-val ((m <Actor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:name-val is deprecated.  Use nesfr3_msgs-msg:name instead.")
  (name m))

(cl:ensure-generic-function 'tracking_id-val :lambda-list '(m))
(cl:defmethod tracking_id-val ((m <Actor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:tracking_id-val is deprecated.  Use nesfr3_msgs-msg:tracking_id instead.")
  (tracking_id m))

(cl:ensure-generic-function 'pose-val :lambda-list '(m))
(cl:defmethod pose-val ((m <Actor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:pose-val is deprecated.  Use nesfr3_msgs-msg:pose instead.")
  (pose m))

(cl:ensure-generic-function 'points-val :lambda-list '(m))
(cl:defmethod points-val ((m <Actor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:points-val is deprecated.  Use nesfr3_msgs-msg:points instead.")
  (points m))

(cl:ensure-generic-function 'nose_point-val :lambda-list '(m))
(cl:defmethod nose_point-val ((m <Actor>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:nose_point-val is deprecated.  Use nesfr3_msgs-msg:nose_point instead.")
  (nose_point m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Actor>) ostream)
  "Serializes a message object of type '<Actor>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'name))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'name))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tracking_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tracking_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'tracking_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'tracking_id)) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'pose) ostream)
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'points))
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'nose_point) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Actor>) istream)
  "Deserializes a message object of type '<Actor>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'name) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'name) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'tracking_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'tracking_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'tracking_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'tracking_id)) (cl:read-byte istream))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'pose) istream)
  (cl:setf (cl:slot-value msg 'points) (cl:make-array 18))
  (cl:let ((vals (cl:slot-value msg 'points)))
    (cl:dotimes (i 18)
    (cl:setf (cl:aref vals i) (cl:make-instance 'nesfr3_msgs-msg:PointWithConfidence))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream)))
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'nose_point) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Actor>)))
  "Returns string type for a message object of type '<Actor>"
  "nesfr3_msgs/Actor")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Actor)))
  "Returns string type for a message object of type 'Actor"
  "nesfr3_msgs/Actor")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Actor>)))
  "Returns md5sum for a message object of type '<Actor>"
  "e66ab061dc9fde49d29081c40910f1a1")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Actor)))
  "Returns md5sum for a message object of type 'Actor"
  "e66ab061dc9fde49d29081c40910f1a1")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Actor>)))
  "Returns full string definition for message of type '<Actor>"
  (cl:format cl:nil "Header header                           # frame_id and timestamp~%string name                             # name for face recognition~%uint32 tracking_id                      # identification for tracking~%geometry_msgs/PoseWithCovariance pose   # position from detection and ~%                                        # orientation from EKF~%PointWithConfidence[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck~%geometry_msgs/Point nose_point          # nose_point for facerec~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: nesfr3_msgs/PointWithConfidence~%geometry_msgs/Point point~%float32 confidence~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Actor)))
  "Returns full string definition for message of type 'Actor"
  (cl:format cl:nil "Header header                           # frame_id and timestamp~%string name                             # name for face recognition~%uint32 tracking_id                      # identification for tracking~%geometry_msgs/PoseWithCovariance pose   # position from detection and ~%                                        # orientation from EKF~%PointWithConfidence[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck~%geometry_msgs/Point nose_point          # nose_point for facerec~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: nesfr3_msgs/PointWithConfidence~%geometry_msgs/Point point~%float32 confidence~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Actor>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:length (cl:slot-value msg 'name))
     4
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'pose))
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'points) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'nose_point))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Actor>))
  "Converts a ROS message object to a list"
  (cl:list 'Actor
    (cl:cons ':header (header msg))
    (cl:cons ':name (name msg))
    (cl:cons ':tracking_id (tracking_id msg))
    (cl:cons ':pose (pose msg))
    (cl:cons ':points (points msg))
    (cl:cons ':nose_point (nose_point msg))
))
