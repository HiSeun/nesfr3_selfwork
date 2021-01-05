; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude PoseArrayWithBoxes.msg.html

(cl:defclass <PoseArrayWithBoxes> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (poses
    :reader poses
    :initarg :poses
    :type (cl:vector geometry_msgs-msg:Pose)
   :initform (cl:make-array 0 :element-type 'geometry_msgs-msg:Pose :initial-element (cl:make-instance 'geometry_msgs-msg:Pose)))
   (bounding_boxes
    :reader bounding_boxes
    :initarg :bounding_boxes
    :type (cl:vector nesfr3_msgs-msg:BoundingBox)
   :initform (cl:make-array 0 :element-type 'nesfr3_msgs-msg:BoundingBox :initial-element (cl:make-instance 'nesfr3_msgs-msg:BoundingBox))))
)

(cl:defclass PoseArrayWithBoxes (<PoseArrayWithBoxes>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PoseArrayWithBoxes>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PoseArrayWithBoxes)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<PoseArrayWithBoxes> is deprecated: use nesfr3_msgs-msg:PoseArrayWithBoxes instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <PoseArrayWithBoxes>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:header-val is deprecated.  Use nesfr3_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'poses-val :lambda-list '(m))
(cl:defmethod poses-val ((m <PoseArrayWithBoxes>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:poses-val is deprecated.  Use nesfr3_msgs-msg:poses instead.")
  (poses m))

(cl:ensure-generic-function 'bounding_boxes-val :lambda-list '(m))
(cl:defmethod bounding_boxes-val ((m <PoseArrayWithBoxes>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:bounding_boxes-val is deprecated.  Use nesfr3_msgs-msg:bounding_boxes instead.")
  (bounding_boxes m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PoseArrayWithBoxes>) ostream)
  "Serializes a message object of type '<PoseArrayWithBoxes>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'poses))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'poses))
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'bounding_boxes))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'bounding_boxes))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PoseArrayWithBoxes>) istream)
  "Deserializes a message object of type '<PoseArrayWithBoxes>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'poses) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'poses)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'geometry_msgs-msg:Pose))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'bounding_boxes) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'bounding_boxes)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'nesfr3_msgs-msg:BoundingBox))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PoseArrayWithBoxes>)))
  "Returns string type for a message object of type '<PoseArrayWithBoxes>"
  "nesfr3_msgs/PoseArrayWithBoxes")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PoseArrayWithBoxes)))
  "Returns string type for a message object of type 'PoseArrayWithBoxes"
  "nesfr3_msgs/PoseArrayWithBoxes")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PoseArrayWithBoxes>)))
  "Returns md5sum for a message object of type '<PoseArrayWithBoxes>"
  "7b78df7f80c14eac173abb6782c52b5b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PoseArrayWithBoxes)))
  "Returns md5sum for a message object of type 'PoseArrayWithBoxes"
  "7b78df7f80c14eac173abb6782c52b5b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PoseArrayWithBoxes>)))
  "Returns full string definition for message of type '<PoseArrayWithBoxes>"
  (cl:format cl:nil "Header header~%~%geometry_msgs/Pose[] poses~%BoundingBox[] bounding_boxes~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: nesfr3_msgs/BoundingBox~%float64 score~%int64 xmin~%int64 ymin~%int64 xmax~%int64 ymax~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PoseArrayWithBoxes)))
  "Returns full string definition for message of type 'PoseArrayWithBoxes"
  (cl:format cl:nil "Header header~%~%geometry_msgs/Pose[] poses~%BoundingBox[] bounding_boxes~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: geometry_msgs/Pose~%# A representation of pose in free space, composed of position and orientation. ~%Point position~%Quaternion orientation~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%================================================================================~%MSG: geometry_msgs/Quaternion~%# This represents an orientation in free space in quaternion form.~%~%float64 x~%float64 y~%float64 z~%float64 w~%~%================================================================================~%MSG: nesfr3_msgs/BoundingBox~%float64 score~%int64 xmin~%int64 ymin~%int64 xmax~%int64 ymax~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PoseArrayWithBoxes>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'poses) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'bounding_boxes) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PoseArrayWithBoxes>))
  "Converts a ROS message object to a list"
  (cl:list 'PoseArrayWithBoxes
    (cl:cons ':header (header msg))
    (cl:cons ':poses (poses msg))
    (cl:cons ':bounding_boxes (bounding_boxes msg))
))
