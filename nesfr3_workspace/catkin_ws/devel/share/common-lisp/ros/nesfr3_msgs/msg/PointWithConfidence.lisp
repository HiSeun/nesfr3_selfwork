; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude PointWithConfidence.msg.html

(cl:defclass <PointWithConfidence> (roslisp-msg-protocol:ros-message)
  ((point
    :reader point
    :initarg :point
    :type geometry_msgs-msg:Point
    :initform (cl:make-instance 'geometry_msgs-msg:Point))
   (confidence
    :reader confidence
    :initarg :confidence
    :type cl:float
    :initform 0.0))
)

(cl:defclass PointWithConfidence (<PointWithConfidence>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <PointWithConfidence>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'PointWithConfidence)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<PointWithConfidence> is deprecated: use nesfr3_msgs-msg:PointWithConfidence instead.")))

(cl:ensure-generic-function 'point-val :lambda-list '(m))
(cl:defmethod point-val ((m <PointWithConfidence>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:point-val is deprecated.  Use nesfr3_msgs-msg:point instead.")
  (point m))

(cl:ensure-generic-function 'confidence-val :lambda-list '(m))
(cl:defmethod confidence-val ((m <PointWithConfidence>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:confidence-val is deprecated.  Use nesfr3_msgs-msg:confidence instead.")
  (confidence m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <PointWithConfidence>) ostream)
  "Serializes a message object of type '<PointWithConfidence>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'point) ostream)
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'confidence))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <PointWithConfidence>) istream)
  "Deserializes a message object of type '<PointWithConfidence>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'point) istream)
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'confidence) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<PointWithConfidence>)))
  "Returns string type for a message object of type '<PointWithConfidence>"
  "nesfr3_msgs/PointWithConfidence")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'PointWithConfidence)))
  "Returns string type for a message object of type 'PointWithConfidence"
  "nesfr3_msgs/PointWithConfidence")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<PointWithConfidence>)))
  "Returns md5sum for a message object of type '<PointWithConfidence>"
  "47cab856215e2b01d6eb9ac884ec9042")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'PointWithConfidence)))
  "Returns md5sum for a message object of type 'PointWithConfidence"
  "47cab856215e2b01d6eb9ac884ec9042")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<PointWithConfidence>)))
  "Returns full string definition for message of type '<PointWithConfidence>"
  (cl:format cl:nil "geometry_msgs/Point point~%float32 confidence~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'PointWithConfidence)))
  "Returns full string definition for message of type 'PointWithConfidence"
  (cl:format cl:nil "geometry_msgs/Point point~%float32 confidence~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <PointWithConfidence>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'point))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <PointWithConfidence>))
  "Converts a ROS message object to a list"
  (cl:list 'PointWithConfidence
    (cl:cons ':point (point msg))
    (cl:cons ':confidence (confidence msg))
))
