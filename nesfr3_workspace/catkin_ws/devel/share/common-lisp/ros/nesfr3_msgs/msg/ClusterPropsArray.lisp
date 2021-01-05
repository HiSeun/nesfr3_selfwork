; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude ClusterPropsArray.msg.html

(cl:defclass <ClusterPropsArray> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (ClusterPropsArray
    :reader ClusterPropsArray
    :initarg :ClusterPropsArray
    :type (cl:vector nesfr3_msgs-msg:ClusterProps)
   :initform (cl:make-array 0 :element-type 'nesfr3_msgs-msg:ClusterProps :initial-element (cl:make-instance 'nesfr3_msgs-msg:ClusterProps))))
)

(cl:defclass ClusterPropsArray (<ClusterPropsArray>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ClusterPropsArray>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ClusterPropsArray)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<ClusterPropsArray> is deprecated: use nesfr3_msgs-msg:ClusterPropsArray instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <ClusterPropsArray>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:header-val is deprecated.  Use nesfr3_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'ClusterPropsArray-val :lambda-list '(m))
(cl:defmethod ClusterPropsArray-val ((m <ClusterPropsArray>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:ClusterPropsArray-val is deprecated.  Use nesfr3_msgs-msg:ClusterPropsArray instead.")
  (ClusterPropsArray m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ClusterPropsArray>) ostream)
  "Serializes a message object of type '<ClusterPropsArray>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'ClusterPropsArray))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'ClusterPropsArray))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ClusterPropsArray>) istream)
  "Deserializes a message object of type '<ClusterPropsArray>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'ClusterPropsArray) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'ClusterPropsArray)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'nesfr3_msgs-msg:ClusterProps))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ClusterPropsArray>)))
  "Returns string type for a message object of type '<ClusterPropsArray>"
  "nesfr3_msgs/ClusterPropsArray")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ClusterPropsArray)))
  "Returns string type for a message object of type 'ClusterPropsArray"
  "nesfr3_msgs/ClusterPropsArray")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ClusterPropsArray>)))
  "Returns md5sum for a message object of type '<ClusterPropsArray>"
  "4608baf7edd9b6be483773f66e382aa3")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ClusterPropsArray)))
  "Returns md5sum for a message object of type 'ClusterPropsArray"
  "4608baf7edd9b6be483773f66e382aa3")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ClusterPropsArray>)))
  "Returns full string definition for message of type '<ClusterPropsArray>"
  (cl:format cl:nil "Header header~%~%ClusterProps[] ClusterPropsArray~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: nesfr3_msgs/ClusterProps~%geometry_msgs/Point min~%geometry_msgs/Point max~%geometry_msgs/Point centroid~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ClusterPropsArray)))
  "Returns full string definition for message of type 'ClusterPropsArray"
  (cl:format cl:nil "Header header~%~%ClusterProps[] ClusterPropsArray~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: nesfr3_msgs/ClusterProps~%geometry_msgs/Point min~%geometry_msgs/Point max~%geometry_msgs/Point centroid~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ClusterPropsArray>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'ClusterPropsArray) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ClusterPropsArray>))
  "Converts a ROS message object to a list"
  (cl:list 'ClusterPropsArray
    (cl:cons ':header (header msg))
    (cl:cons ':ClusterPropsArray (ClusterPropsArray msg))
))
