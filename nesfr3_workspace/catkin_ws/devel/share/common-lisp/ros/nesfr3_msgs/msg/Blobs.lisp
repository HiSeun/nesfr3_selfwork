; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude Blobs.msg.html

(cl:defclass <Blobs> (roslisp-msg-protocol:ros-message)
  ((cluster_id
    :reader cluster_id
    :initarg :cluster_id
    :type cl:integer
    :initform 0)
   (blobs
    :reader blobs
    :initarg :blobs
    :type (cl:vector nesfr3_msgs-msg:Blob)
   :initform (cl:make-array 0 :element-type 'nesfr3_msgs-msg:Blob :initial-element (cl:make-instance 'nesfr3_msgs-msg:Blob))))
)

(cl:defclass Blobs (<Blobs>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Blobs>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Blobs)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<Blobs> is deprecated: use nesfr3_msgs-msg:Blobs instead.")))

(cl:ensure-generic-function 'cluster_id-val :lambda-list '(m))
(cl:defmethod cluster_id-val ((m <Blobs>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:cluster_id-val is deprecated.  Use nesfr3_msgs-msg:cluster_id instead.")
  (cluster_id m))

(cl:ensure-generic-function 'blobs-val :lambda-list '(m))
(cl:defmethod blobs-val ((m <Blobs>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:blobs-val is deprecated.  Use nesfr3_msgs-msg:blobs instead.")
  (blobs m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Blobs>) ostream)
  "Serializes a message object of type '<Blobs>"
  (cl:let* ((signed (cl:slot-value msg 'cluster_id)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'blobs))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'blobs))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Blobs>) istream)
  "Deserializes a message object of type '<Blobs>"
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'cluster_id) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'blobs) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'blobs)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'nesfr3_msgs-msg:Blob))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Blobs>)))
  "Returns string type for a message object of type '<Blobs>"
  "nesfr3_msgs/Blobs")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Blobs)))
  "Returns string type for a message object of type 'Blobs"
  "nesfr3_msgs/Blobs")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Blobs>)))
  "Returns md5sum for a message object of type '<Blobs>"
  "38502a899cca6d893c4fabfdf43cd8e8")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Blobs)))
  "Returns md5sum for a message object of type 'Blobs"
  "38502a899cca6d893c4fabfdf43cd8e8")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Blobs>)))
  "Returns full string definition for message of type '<Blobs>"
  (cl:format cl:nil "int32 cluster_id~%Blob[] blobs~%================================================================================~%MSG: nesfr3_msgs/Blob~%int32 x~%int32 y~%int32 width~%int32 height~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Blobs)))
  "Returns full string definition for message of type 'Blobs"
  (cl:format cl:nil "int32 cluster_id~%Blob[] blobs~%================================================================================~%MSG: nesfr3_msgs/Blob~%int32 x~%int32 y~%int32 width~%int32 height~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Blobs>))
  (cl:+ 0
     4
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'blobs) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Blobs>))
  "Converts a ROS message object to a list"
  (cl:list 'Blobs
    (cl:cons ':cluster_id (cluster_id msg))
    (cl:cons ':blobs (blobs msg))
))
