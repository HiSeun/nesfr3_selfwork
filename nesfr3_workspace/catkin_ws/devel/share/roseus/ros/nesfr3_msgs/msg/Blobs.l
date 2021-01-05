;; Auto-generated. Do not edit!


(when (boundp 'nesfr3_msgs::Blobs)
  (if (not (find-package "NESFR3_MSGS"))
    (make-package "NESFR3_MSGS"))
  (shadow 'Blobs (find-package "NESFR3_MSGS")))
(unless (find-package "NESFR3_MSGS::BLOBS")
  (make-package "NESFR3_MSGS::BLOBS"))

(in-package "ROS")
;;//! \htmlinclude Blobs.msg.html


(defclass nesfr3_msgs::Blobs
  :super ros::object
  :slots (_cluster_id _blobs ))

(defmethod nesfr3_msgs::Blobs
  (:init
   (&key
    ((:cluster_id __cluster_id) 0)
    ((:blobs __blobs) (let (r) (dotimes (i 0) (push (instance nesfr3_msgs::Blob :init) r)) r))
    )
   (send-super :init)
   (setq _cluster_id (round __cluster_id))
   (setq _blobs __blobs)
   self)
  (:cluster_id
   (&optional __cluster_id)
   (if __cluster_id (setq _cluster_id __cluster_id)) _cluster_id)
  (:blobs
   (&rest __blobs)
   (if (keywordp (car __blobs))
       (send* _blobs __blobs)
     (progn
       (if __blobs (setq _blobs (car __blobs)))
       _blobs)))
  (:serialization-length
   ()
   (+
    ;; int32 _cluster_id
    4
    ;; nesfr3_msgs/Blob[] _blobs
    (apply #'+ (send-all _blobs :serialization-length)) 4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; int32 _cluster_id
       (write-long _cluster_id s)
     ;; nesfr3_msgs/Blob[] _blobs
     (write-long (length _blobs) s)
     (dolist (elem _blobs)
       (send elem :serialize s)
       )
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; int32 _cluster_id
     (setq _cluster_id (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; nesfr3_msgs/Blob[] _blobs
   (let (n)
     (setq n (sys::peek buf ptr- :integer)) (incf ptr- 4)
     (setq _blobs (let (r) (dotimes (i n) (push (instance nesfr3_msgs::Blob :init) r)) r))
     (dolist (elem- _blobs)
     (send elem- :deserialize buf ptr-) (incf ptr- (send elem- :serialization-length))
     ))
   ;;
   self)
  )

(setf (get nesfr3_msgs::Blobs :md5sum-) "38502a899cca6d893c4fabfdf43cd8e8")
(setf (get nesfr3_msgs::Blobs :datatype-) "nesfr3_msgs/Blobs")
(setf (get nesfr3_msgs::Blobs :definition-)
      "int32 cluster_id
Blob[] blobs
================================================================================
MSG: nesfr3_msgs/Blob
int32 x
int32 y
int32 width
int32 height

")



(provide :nesfr3_msgs/Blobs "38502a899cca6d893c4fabfdf43cd8e8")


