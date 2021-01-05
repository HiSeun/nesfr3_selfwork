;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_services::FollowActor)
  (if (not (find-package "NESFR3_SERVICES"))
    (make-package "NESFR3_SERVICES"))
  (shadow 'FollowActor (find-package "NESFR3_SERVICES")))
(unless (find-package "NESFR3_SERVICES::FOLLOWACTOR")
  (make-package "NESFR3_SERVICES::FOLLOWACTOR"))
(unless (find-package "NESFR3_SERVICES::FOLLOWACTORREQUEST")
  (make-package "NESFR3_SERVICES::FOLLOWACTORREQUEST"))
(unless (find-package "NESFR3_SERVICES::FOLLOWACTORRESPONSE")
  (make-package "NESFR3_SERVICES::FOLLOWACTORRESPONSE"))

(in-package "ROS")





(defclass nesfr3_services::FollowActorRequest
  :super ros::object
  :slots (_actor_id _robot_id _distance _angle _shot_size _use_gt ))

(defmethod nesfr3_services::FollowActorRequest
  (:init
   (&key
    ((:actor_id __actor_id) 0)
    ((:robot_id __robot_id) 0)
    ((:distance __distance) 0.0)
    ((:angle __angle) 0.0)
    ((:shot_size __shot_size) "")
    ((:use_gt __use_gt) 0)
    )
   (send-super :init)
   (setq _actor_id (round __actor_id))
   (setq _robot_id (round __robot_id))
   (setq _distance (float __distance))
   (setq _angle (float __angle))
   (setq _shot_size (string __shot_size))
   (setq _use_gt (round __use_gt))
   self)
  (:actor_id
   (&optional __actor_id)
   (if __actor_id (setq _actor_id __actor_id)) _actor_id)
  (:robot_id
   (&optional __robot_id)
   (if __robot_id (setq _robot_id __robot_id)) _robot_id)
  (:distance
   (&optional __distance)
   (if __distance (setq _distance __distance)) _distance)
  (:angle
   (&optional __angle)
   (if __angle (setq _angle __angle)) _angle)
  (:shot_size
   (&optional __shot_size)
   (if __shot_size (setq _shot_size __shot_size)) _shot_size)
  (:use_gt
   (&optional __use_gt)
   (if __use_gt (setq _use_gt __use_gt)) _use_gt)
  (:serialization-length
   ()
   (+
    ;; uint32 _actor_id
    4
    ;; uint32 _robot_id
    4
    ;; float64 _distance
    8
    ;; float64 _angle
    8
    ;; string _shot_size
    4 (length _shot_size)
    ;; uint32 _use_gt
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint32 _actor_id
       (write-long _actor_id s)
     ;; uint32 _robot_id
       (write-long _robot_id s)
     ;; float64 _distance
       (sys::poke _distance (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _angle
       (sys::poke _angle (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; string _shot_size
       (write-long (length _shot_size) s) (princ _shot_size s)
     ;; uint32 _use_gt
       (write-long _use_gt s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint32 _actor_id
     (setq _actor_id (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint32 _robot_id
     (setq _robot_id (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; float64 _distance
     (setq _distance (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _angle
     (setq _angle (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; string _shot_size
     (let (n) (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4) (setq _shot_size (subseq buf ptr- (+ ptr- n))) (incf ptr- n))
   ;; uint32 _use_gt
     (setq _use_gt (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;;
   self)
  )

(defclass nesfr3_services::FollowActorResponse
  :super ros::object
  :slots ())

(defmethod nesfr3_services::FollowActorResponse
  (:init
   (&key
    )
   (send-super :init)
   self)
  (:serialization-length
   ()
   (+
    0
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;;
   self)
  )

(defclass nesfr3_services::FollowActor
  :super ros::object
  :slots ())

(setf (get nesfr3_services::FollowActor :md5sum-) "99227585c2a2e2d95dc78c237396ff04")
(setf (get nesfr3_services::FollowActor :datatype-) "nesfr3_services/FollowActor")
(setf (get nesfr3_services::FollowActor :request) nesfr3_services::FollowActorRequest)
(setf (get nesfr3_services::FollowActor :response) nesfr3_services::FollowActorResponse)

(defmethod nesfr3_services::FollowActorRequest
  (:response () (instance nesfr3_services::FollowActorResponse :init)))

(setf (get nesfr3_services::FollowActorRequest :md5sum-) "99227585c2a2e2d95dc78c237396ff04")
(setf (get nesfr3_services::FollowActorRequest :datatype-) "nesfr3_services/FollowActorRequest")
(setf (get nesfr3_services::FollowActorRequest :definition-)
      "uint32 actor_id
uint32 robot_id			
float64 distance	
float64 angle 		
string shot_size
uint32 use_gt
---
")

(setf (get nesfr3_services::FollowActorResponse :md5sum-) "99227585c2a2e2d95dc78c237396ff04")
(setf (get nesfr3_services::FollowActorResponse :datatype-) "nesfr3_services/FollowActorResponse")
(setf (get nesfr3_services::FollowActorResponse :definition-)
      "uint32 actor_id
uint32 robot_id			
float64 distance	
float64 angle 		
string shot_size
uint32 use_gt
---
")



(provide :nesfr3_services/FollowActor "99227585c2a2e2d95dc78c237396ff04")


