; Auto-generated. Do not edit!


(cl:in-package nesfr3_services-srv)


;//! \htmlinclude FollowActor-request.msg.html

(cl:defclass <FollowActor-request> (roslisp-msg-protocol:ros-message)
  ((actor_id
    :reader actor_id
    :initarg :actor_id
    :type cl:integer
    :initform 0)
   (robot_id
    :reader robot_id
    :initarg :robot_id
    :type cl:integer
    :initform 0)
   (distance
    :reader distance
    :initarg :distance
    :type cl:float
    :initform 0.0)
   (angle
    :reader angle
    :initarg :angle
    :type cl:float
    :initform 0.0)
   (shot_size
    :reader shot_size
    :initarg :shot_size
    :type cl:string
    :initform "")
   (use_gt
    :reader use_gt
    :initarg :use_gt
    :type cl:integer
    :initform 0))
)

(cl:defclass FollowActor-request (<FollowActor-request>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FollowActor-request>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FollowActor-request)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_services-srv:<FollowActor-request> is deprecated: use nesfr3_services-srv:FollowActor-request instead.")))

(cl:ensure-generic-function 'actor_id-val :lambda-list '(m))
(cl:defmethod actor_id-val ((m <FollowActor-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_services-srv:actor_id-val is deprecated.  Use nesfr3_services-srv:actor_id instead.")
  (actor_id m))

(cl:ensure-generic-function 'robot_id-val :lambda-list '(m))
(cl:defmethod robot_id-val ((m <FollowActor-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_services-srv:robot_id-val is deprecated.  Use nesfr3_services-srv:robot_id instead.")
  (robot_id m))

(cl:ensure-generic-function 'distance-val :lambda-list '(m))
(cl:defmethod distance-val ((m <FollowActor-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_services-srv:distance-val is deprecated.  Use nesfr3_services-srv:distance instead.")
  (distance m))

(cl:ensure-generic-function 'angle-val :lambda-list '(m))
(cl:defmethod angle-val ((m <FollowActor-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_services-srv:angle-val is deprecated.  Use nesfr3_services-srv:angle instead.")
  (angle m))

(cl:ensure-generic-function 'shot_size-val :lambda-list '(m))
(cl:defmethod shot_size-val ((m <FollowActor-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_services-srv:shot_size-val is deprecated.  Use nesfr3_services-srv:shot_size instead.")
  (shot_size m))

(cl:ensure-generic-function 'use_gt-val :lambda-list '(m))
(cl:defmethod use_gt-val ((m <FollowActor-request>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_services-srv:use_gt-val is deprecated.  Use nesfr3_services-srv:use_gt instead.")
  (use_gt m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FollowActor-request>) ostream)
  "Serializes a message object of type '<FollowActor-request>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'actor_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'actor_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'actor_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'actor_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'robot_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'robot_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'robot_id)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'robot_id)) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'distance))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'angle))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((__ros_str_len (cl:length (cl:slot-value msg 'shot_size))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_str_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_str_len) ostream))
  (cl:map cl:nil #'(cl:lambda (c) (cl:write-byte (cl:char-code c) ostream)) (cl:slot-value msg 'shot_size))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'use_gt)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'use_gt)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'use_gt)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'use_gt)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FollowActor-request>) istream)
  "Deserializes a message object of type '<FollowActor-request>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'actor_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'actor_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'actor_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'actor_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'robot_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'robot_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'robot_id)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'robot_id)) (cl:read-byte istream))
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
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'angle) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((__ros_str_len 0))
      (cl:setf (cl:ldb (cl:byte 8 0) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) __ros_str_len) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'shot_size) (cl:make-string __ros_str_len))
      (cl:dotimes (__ros_str_idx __ros_str_len msg)
        (cl:setf (cl:char (cl:slot-value msg 'shot_size) __ros_str_idx) (cl:code-char (cl:read-byte istream)))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'use_gt)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'use_gt)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) (cl:slot-value msg 'use_gt)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) (cl:slot-value msg 'use_gt)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FollowActor-request>)))
  "Returns string type for a service object of type '<FollowActor-request>"
  "nesfr3_services/FollowActorRequest")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FollowActor-request)))
  "Returns string type for a service object of type 'FollowActor-request"
  "nesfr3_services/FollowActorRequest")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FollowActor-request>)))
  "Returns md5sum for a message object of type '<FollowActor-request>"
  "99227585c2a2e2d95dc78c237396ff04")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FollowActor-request)))
  "Returns md5sum for a message object of type 'FollowActor-request"
  "99227585c2a2e2d95dc78c237396ff04")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FollowActor-request>)))
  "Returns full string definition for message of type '<FollowActor-request>"
  (cl:format cl:nil "uint32 actor_id~%uint32 robot_id			~%float64 distance	~%float64 angle 		~%string shot_size~%uint32 use_gt~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FollowActor-request)))
  "Returns full string definition for message of type 'FollowActor-request"
  (cl:format cl:nil "uint32 actor_id~%uint32 robot_id			~%float64 distance	~%float64 angle 		~%string shot_size~%uint32 use_gt~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FollowActor-request>))
  (cl:+ 0
     4
     4
     8
     8
     4 (cl:length (cl:slot-value msg 'shot_size))
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FollowActor-request>))
  "Converts a ROS message object to a list"
  (cl:list 'FollowActor-request
    (cl:cons ':actor_id (actor_id msg))
    (cl:cons ':robot_id (robot_id msg))
    (cl:cons ':distance (distance msg))
    (cl:cons ':angle (angle msg))
    (cl:cons ':shot_size (shot_size msg))
    (cl:cons ':use_gt (use_gt msg))
))
;//! \htmlinclude FollowActor-response.msg.html

(cl:defclass <FollowActor-response> (roslisp-msg-protocol:ros-message)
  ()
)

(cl:defclass FollowActor-response (<FollowActor-response>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <FollowActor-response>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'FollowActor-response)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_services-srv:<FollowActor-response> is deprecated: use nesfr3_services-srv:FollowActor-response instead.")))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <FollowActor-response>) ostream)
  "Serializes a message object of type '<FollowActor-response>"
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <FollowActor-response>) istream)
  "Deserializes a message object of type '<FollowActor-response>"
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<FollowActor-response>)))
  "Returns string type for a service object of type '<FollowActor-response>"
  "nesfr3_services/FollowActorResponse")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FollowActor-response)))
  "Returns string type for a service object of type 'FollowActor-response"
  "nesfr3_services/FollowActorResponse")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<FollowActor-response>)))
  "Returns md5sum for a message object of type '<FollowActor-response>"
  "99227585c2a2e2d95dc78c237396ff04")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'FollowActor-response)))
  "Returns md5sum for a message object of type 'FollowActor-response"
  "99227585c2a2e2d95dc78c237396ff04")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<FollowActor-response>)))
  "Returns full string definition for message of type '<FollowActor-response>"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'FollowActor-response)))
  "Returns full string definition for message of type 'FollowActor-response"
  (cl:format cl:nil "~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <FollowActor-response>))
  (cl:+ 0
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <FollowActor-response>))
  "Converts a ROS message object to a list"
  (cl:list 'FollowActor-response
))
(cl:defmethod roslisp-msg-protocol:service-request-type ((msg (cl:eql 'FollowActor)))
  'FollowActor-request)
(cl:defmethod roslisp-msg-protocol:service-response-type ((msg (cl:eql 'FollowActor)))
  'FollowActor-response)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'FollowActor)))
  "Returns string type for a service object of type '<FollowActor>"
  "nesfr3_services/FollowActor")