
(cl:in-package :asdf)

(defsystem "nesfr3_gazebo-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :sensor_msgs-msg
)
  :components ((:file "_package")
    (:file "shot" :depends-on ("_package_shot"))
    (:file "_package_shot" :depends-on ("_package"))
  ))