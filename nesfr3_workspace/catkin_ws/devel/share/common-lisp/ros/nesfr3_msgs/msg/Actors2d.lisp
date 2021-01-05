; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude Actors2d.msg.html

(cl:defclass <Actors2d> (roslisp-msg-protocol:ros-message)
  ((header
    :reader header
    :initarg :header
    :type std_msgs-msg:Header
    :initform (cl:make-instance 'std_msgs-msg:Header))
   (actors2d
    :reader actors2d
    :initarg :actors2d
    :type (cl:vector nesfr3_msgs-msg:Actor2d)
   :initform (cl:make-array 0 :element-type 'nesfr3_msgs-msg:Actor2d :initial-element (cl:make-instance 'nesfr3_msgs-msg:Actor2d))))
)

(cl:defclass Actors2d (<Actors2d>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Actors2d>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Actors2d)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<Actors2d> is deprecated: use nesfr3_msgs-msg:Actors2d instead.")))

(cl:ensure-generic-function 'header-val :lambda-list '(m))
(cl:defmethod header-val ((m <Actors2d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:header-val is deprecated.  Use nesfr3_msgs-msg:header instead.")
  (header m))

(cl:ensure-generic-function 'actors2d-val :lambda-list '(m))
(cl:defmethod actors2d-val ((m <Actors2d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:actors2d-val is deprecated.  Use nesfr3_msgs-msg:actors2d instead.")
  (actors2d m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Actors2d>) ostream)
  "Serializes a message object of type '<Actors2d>"
  (roslisp-msg-protocol:serialize (cl:slot-value msg 'header) ostream)
  (cl:let ((__ros_arr_len (cl:length (cl:slot-value msg 'actors2d))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) __ros_arr_len) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) __ros_arr_len) ostream))
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'actors2d))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Actors2d>) istream)
  "Deserializes a message object of type '<Actors2d>"
  (roslisp-msg-protocol:deserialize (cl:slot-value msg 'header) istream)
  (cl:let ((__ros_arr_len 0))
    (cl:setf (cl:ldb (cl:byte 8 0) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 16) __ros_arr_len) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 24) __ros_arr_len) (cl:read-byte istream))
  (cl:setf (cl:slot-value msg 'actors2d) (cl:make-array __ros_arr_len))
  (cl:let ((vals (cl:slot-value msg 'actors2d)))
    (cl:dotimes (i __ros_arr_len)
    (cl:setf (cl:aref vals i) (cl:make-instance 'nesfr3_msgs-msg:Actor2d))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Actors2d>)))
  "Returns string type for a message object of type '<Actors2d>"
  "nesfr3_msgs/Actors2d")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Actors2d)))
  "Returns string type for a message object of type 'Actors2d"
  "nesfr3_msgs/Actors2d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Actors2d>)))
  "Returns md5sum for a message object of type '<Actors2d>"
  "c1bee49e25f0b078e91e5e00c305ebd5")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Actors2d)))
  "Returns md5sum for a message object of type 'Actors2d"
  "c1bee49e25f0b078e91e5e00c305ebd5")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Actors2d>)))
  "Returns full string definition for message of type '<Actors2d>"
  (cl:format cl:nil "Header header   # For frame_id and timestamp~%Actor2d[] actors2d~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: nesfr3_msgs/Actor2d~%geometry_msgs/Point[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck  ~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Actors2d)))
  "Returns full string definition for message of type 'Actors2d"
  (cl:format cl:nil "Header header   # For frame_id and timestamp~%Actor2d[] actors2d~%~%================================================================================~%MSG: std_msgs/Header~%# Standard metadata for higher-level stamped data types.~%# This is generally used to communicate timestamped data ~%# in a particular coordinate frame.~%# ~%# sequence ID: consecutively increasing ID ~%uint32 seq~%#Two-integer timestamp that is expressed as:~%# * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')~%# * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')~%# time-handling sugar is provided by the client library~%time stamp~%#Frame this data is associated with~%string frame_id~%~%================================================================================~%MSG: nesfr3_msgs/Actor2d~%geometry_msgs/Point[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck  ~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Actors2d>))
  (cl:+ 0
     (roslisp-msg-protocol:serialization-length (cl:slot-value msg 'header))
     4 (cl:reduce #'cl:+ (cl:slot-value msg 'actors2d) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Actors2d>))
  "Converts a ROS message object to a list"
  (cl:list 'Actors2d
    (cl:cons ':header (header msg))
    (cl:cons ':actors2d (actors2d msg))
))
