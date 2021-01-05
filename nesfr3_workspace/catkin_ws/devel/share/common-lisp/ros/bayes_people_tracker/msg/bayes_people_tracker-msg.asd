
(cl:in-package :asdf)

(defsystem "bayes_people_tracker-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils :geometry_msgs-msg
               :std_msgs-msg
)
  :components ((:file "_package")
    (:file "PeopleTracker" :depends-on ("_package_PeopleTracker"))
    (:file "_package_PeopleTracker" :depends-on ("_package"))
  ))