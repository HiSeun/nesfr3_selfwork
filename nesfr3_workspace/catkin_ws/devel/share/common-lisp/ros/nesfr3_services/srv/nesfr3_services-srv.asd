
(cl:in-package :asdf)

(defsystem "nesfr3_services-srv"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "FollowActor" :depends-on ("_package_FollowActor"))
    (:file "_package_FollowActor" :depends-on ("_package"))
  ))