; Auto-generated. Do not edit!


(cl:in-package nesfr3_msgs-msg)


;//! \htmlinclude Actor2d.msg.html

(cl:defclass <Actor2d> (roslisp-msg-protocol:ros-message)
  ((points
    :reader points
    :initarg :points
    :type (cl:vector geometry_msgs-msg:Point)
   :initform (cl:make-array 18 :element-type 'geometry_msgs-msg:Point :initial-element (cl:make-instance 'geometry_msgs-msg:Point))))
)

(cl:defclass Actor2d (<Actor2d>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Actor2d>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Actor2d)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name nesfr3_msgs-msg:<Actor2d> is deprecated: use nesfr3_msgs-msg:Actor2d instead.")))

(cl:ensure-generic-function 'points-val :lambda-list '(m))
(cl:defmethod points-val ((m <Actor2d>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader nesfr3_msgs-msg:points-val is deprecated.  Use nesfr3_msgs-msg:points instead.")
  (points m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Actor2d>) ostream)
  "Serializes a message object of type '<Actor2d>"
  (cl:map cl:nil #'(cl:lambda (ele) (roslisp-msg-protocol:serialize ele ostream))
   (cl:slot-value msg 'points))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Actor2d>) istream)
  "Deserializes a message object of type '<Actor2d>"
  (cl:setf (cl:slot-value msg 'points) (cl:make-array 18))
  (cl:let ((vals (cl:slot-value msg 'points)))
    (cl:dotimes (i 18)
    (cl:setf (cl:aref vals i) (cl:make-instance 'geometry_msgs-msg:Point))
  (roslisp-msg-protocol:deserialize (cl:aref vals i) istream)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Actor2d>)))
  "Returns string type for a message object of type '<Actor2d>"
  "nesfr3_msgs/Actor2d")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Actor2d)))
  "Returns string type for a message object of type 'Actor2d"
  "nesfr3_msgs/Actor2d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Actor2d>)))
  "Returns md5sum for a message object of type '<Actor2d>"
  "3fb3f9dacc279b964c4c8341122c34df")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Actor2d)))
  "Returns md5sum for a message object of type 'Actor2d"
  "3fb3f9dacc279b964c4c8341122c34df")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Actor2d>)))
  "Returns full string definition for message of type '<Actor2d>"
  (cl:format cl:nil "geometry_msgs/Point[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck  ~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Actor2d)))
  "Returns full string definition for message of type 'Actor2d"
  (cl:format cl:nil "geometry_msgs/Point[18] points          # skeleton points from pose estimation~%                                        # 0: nose~%                                        # 1: left eye~%                                        # 2: right eye~%                                        # 3: left ear~%                                        # 4: right ear~%                                        # 5: left shoulder~%                                        # 6: right shoulder~%                                        # 7: left elbow~%                                        # 8: right elbow~%                                        # 9: left wrist~%                                        # 10: right wrist~%                                        # 11: left hip~%                                        # 12: right hip~%                                        # 13: left knee~%                                        # 14: right knee~%                                        # 15: left ankle~%                                        # 16: right ankle~%                                        # 17: neck  ~%~%================================================================================~%MSG: geometry_msgs/Point~%# This contains the position of a point in free space~%float64 x~%float64 y~%float64 z~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Actor2d>))
  (cl:+ 0
     0 (cl:reduce #'cl:+ (cl:slot-value msg 'points) :key #'(cl:lambda (ele) (cl:declare (cl:ignorable ele)) (cl:+ (roslisp-msg-protocol:serialization-length ele))))
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Actor2d>))
  "Converts a ROS message object to a list"
  (cl:list 'Actor2d
    (cl:cons ':points (points msg))
))
