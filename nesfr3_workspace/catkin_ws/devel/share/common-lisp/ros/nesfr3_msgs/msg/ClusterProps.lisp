; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude ClusterProps.msg.html

(cl:defclass <ClusterProps> (roslisp-msg-protocol:ros-message)
  ((min
    :reader min
    :initarg :min
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (max
    :reader max
    :initarg :max
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (centroid
    :reader centroid
    :initarg :centroid
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point)))
)

(cl:defclass ClusterProps (<ClusterProps>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ClusterProps>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ClusterProps)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<ClusterProps> is deprecated: use nesfr3_msgs-msg:ClusterProps instead.")))

(cl:ensure-generic-function 'min-val :lambda-list '(m))
(cl:defmethod min-val ((m <ClusterProps>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:min-val is deprecated.  Use nesfr3_msgs-msg:min instead.")
  (min m))

(cl:ensure-generic-function 'max-val :lambda-list '(m))
(cl:defmethod max-val ((m <ClusterProps>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:max-val is deprecated.  Use nesfr3_msgs-msg:max instead.")
  (max m))

(cl:ensure-generic-function 'centroid-val :lambda-list '(m))
(cl:defmethod centroid-val ((m <ClusterProps>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:centroid-val is deprecated.  Use nesfr3_msgs-msg:centroid instead.")
  (centroid m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ClusterProps>) ostream)
  "Serializes a message object of type '<ClusterProps>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'min) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'max) ostream)
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'centroid) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ClusterProps>) istream)
  "Deserializes a message object of type '<ClusterProps>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'min) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'max) istream)
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'centroid) istream)
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ClusterProps>)))
  "Returns string type for a message object of type '<ClusterProps>"
  "nesfr3_msgs/ClusterProps")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ClusterProps)))
  "Returns string type for a message object of type 'ClusterProps"
  "nesfr3_msgs/ClusterProps")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ClusterProps>)))
  "Returns md5sum for a message object of type '<ClusterProps>"
  "bf114ed0bf971d15566ddf96d426a32a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ClusterProps)))
  "Returns md5sum for a message object of type 'ClusterProps"
  "bf114ed0bf971d15566ddf96d426a32a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ClusterProps>)))
  "Returns full string definition for message of type '<ClusterProps>"
  (cl:format cl:nil "geometry_msgs/Point min~%geometry_msgs/Point max~%geometry_msgs/Point centroid~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ClusterProps)))
  "Returns full string definition for message of type 'ClusterProps"
  (cl:format cl:nil "geometry_msgs/Point min~%geometry_msgs/Point max~%geometry_msgs/Point centroid~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ClusterProps>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'min))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'max))
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'centroid))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ClusterProps>))
  "Converts a ROS message object to a list"
  (cl:list 'ClusterProps
    (cl:cons ':min (min msg))
    (cl:cons ':max (max msg))
    (cl:cons ':centroid (centroid msg))
))
