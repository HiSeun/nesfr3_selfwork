; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude Actors.msg.html

(cl:defclass <Actors> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (actors
    :reader actors
    :initarg :actors
    :type (cl:vector nesfr3_msgs-msg:Actor)
   :initform (cl:make-array 0 :element-type 'nesfr3_msgs-msg:Actor :initial-element (cl:make-instance 'nesfr3_msgs-msg:Actor))))
)

(cl:defclass Actors (<Actors>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Actors>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Actors)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<Actors> is deprecated: use nesfr3_msgs-msg:Actors instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Actors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:header-val is deprecated.  Use nesfr3_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'actors-val :lambda-list '(m))
(cl:defmethod actors-val ((m <Actors>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:actors-val is deprecated.  Use nesfr3_msgs-msg:actors instead.")
  (actors m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Actors>) ostream)
  "Serializes a message object of type '<Actors>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'actors))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'actors))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Actors>) istream)
  "Deserializes a message object of type '<Actors>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'actors) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'actors)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'nesfr3_msgs-msg:Actor))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Actors>)))
  "Returns string type for a message object of type '<Actors>"
  "nesfr3_msgs/Actors")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Actors)))
  "Returns string type for a message object of type 'Actors"
  "nesfr3_msgs/Actors")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Actors>)))
  "Returns md5sum for a message object of type '<Actors>"
  "3cb6e6b906cb00a49df587adf340a00b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Actors)))
  "Returns md5sum for a message object of type 'Actors"
  "3cb6e6b906cb00a49df587adf340a00b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Actors>)))
  "Returns full string definition for message of type '<Actors>"
  (cl:format cl:nil "Header header   # For frame_id and timestamp~%Actor[] actors~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: nesfr3_msgs/Actor~%Header header                           # frame_id and timestamp~%string name                             # name for face recognition~%uint32 tracking_id                      # identification for tracking~%geometry_msgs/PoseWithCovariance pose   # position from detection and ~%                                        # orientation from EKF~%PointWithConfidence[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck~%geometry_msgs/Point nose_point          # nose_point for facerec~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: nesfr3_msgs/PointWithConfidence~%geometry_msgs/Point point~%float32 confidence~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Actors)))
  "Returns full string definition for message of type 'Actors"
  (cl:format cl:nil "Header header   # For frame_id and timestamp~%Actor[] actors~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: nesfr3_msgs/Actor~%Header header                           # frame_id and timestamp~%string name                             # name for face recognition~%uint32 tracking_id                      # identification for tracking~%geometry_msgs/PoseWithCovariance pose   # position from detection and ~%                                        # orientation from EKF~%PointWithConfidence[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck~%geometry_msgs/Point nose_point          # nose_point for facerec~%================================================================================~%MSG: geometry_msgs/PoseWithCovariance~%# This represents a pose in free space with uncertainty.~%~%Pose pose~%~%# Row-major representation of the 6x6 covariance matrix~%# The orientation parameters use a fixed-axis representation.~%# In order, the parameters are:~%# (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)~%float64[36] covariance~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: nesfr3_msgs/PointWithConfidence~%geometry_msgs/Point point~%float32 confidence~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Actors>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'actors) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Actors>))
  "Converts a ROS message object to a list"
  (cl:list 'Actors
    (cl:cons ':header (header msg))
    (cl:cons ':actors (actors msg))
))
