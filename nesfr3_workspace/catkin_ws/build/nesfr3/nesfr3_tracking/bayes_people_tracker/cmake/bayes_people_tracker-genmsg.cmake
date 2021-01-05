# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "bayes_people_tracker: 1 messages, 0 services")

set(MSG_I_FLAGS "-Ibayes_people_tracker:/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg;-Istd_msgs:/opt/ros/melodic/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/melodic/share/geometry_msgs/cmake/../msg;-Inesfr3_msgs:/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg;-Isensor_msgs:/opt/ros/melodic/share/sensor_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(bayes_people_tracker_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" NAME_WE)
add_custom_target(_bayes_people_tracker_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "bayes_people_tracker" "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" "geometry_msgs/Pose:geometry_msgs/Point:geometry_msgs/Quaternion:std_msgs/Header"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(bayes_people_tracker
  "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/melodic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bayes_people_tracker
)

### Generating Services

### Generating Module File
_generate_module_cpp(bayes_people_tracker
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bayes_people_tracker
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(bayes_people_tracker_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(bayes_people_tracker_generate_messages bayes_people_tracker_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" NAME_WE)
add_dependencies(bayes_people_tracker_generate_messages_cpp _bayes_people_tracker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bayes_people_tracker_gencpp)
add_dependencies(bayes_people_tracker_gencpp bayes_people_tracker_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bayes_people_tracker_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(bayes_people_tracker
  "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/melodic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bayes_people_tracker
)

### Generating Services

### Generating Module File
_generate_module_eus(bayes_people_tracker
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bayes_people_tracker
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(bayes_people_tracker_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(bayes_people_tracker_generate_messages bayes_people_tracker_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" NAME_WE)
add_dependencies(bayes_people_tracker_generate_messages_eus _bayes_people_tracker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bayes_people_tracker_geneus)
add_dependencies(bayes_people_tracker_geneus bayes_people_tracker_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bayes_people_tracker_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(bayes_people_tracker
  "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/melodic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bayes_people_tracker
)

### Generating Services

### Generating Module File
_generate_module_lisp(bayes_people_tracker
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bayes_people_tracker
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(bayes_people_tracker_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(bayes_people_tracker_generate_messages bayes_people_tracker_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" NAME_WE)
add_dependencies(bayes_people_tracker_generate_messages_lisp _bayes_people_tracker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bayes_people_tracker_genlisp)
add_dependencies(bayes_people_tracker_genlisp bayes_people_tracker_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bayes_people_tracker_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(bayes_people_tracker
  "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/melodic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bayes_people_tracker
)

### Generating Services

### Generating Module File
_generate_module_nodejs(bayes_people_tracker
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bayes_people_tracker
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(bayes_people_tracker_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(bayes_people_tracker_generate_messages bayes_people_tracker_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" NAME_WE)
add_dependencies(bayes_people_tracker_generate_messages_nodejs _bayes_people_tracker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bayes_people_tracker_gennodejs)
add_dependencies(bayes_people_tracker_gennodejs bayes_people_tracker_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bayes_people_tracker_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(bayes_people_tracker
  "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/melodic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/melodic/share/std_msgs/cmake/../msg/Header.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bayes_people_tracker
)

### Generating Services

### Generating Module File
_generate_module_py(bayes_people_tracker
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bayes_people_tracker
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(bayes_people_tracker_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(bayes_people_tracker_generate_messages bayes_people_tracker_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_tracking/bayes_people_tracker/msg/PeopleTracker.msg" NAME_WE)
add_dependencies(bayes_people_tracker_generate_messages_py _bayes_people_tracker_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(bayes_people_tracker_genpy)
add_dependencies(bayes_people_tracker_genpy bayes_people_tracker_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS bayes_people_tracker_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bayes_people_tracker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/bayes_people_tracker
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(bayes_people_tracker_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(bayes_people_tracker_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET nesfr3_msgs_generate_messages_cpp)
  add_dependencies(bayes_people_tracker_generate_messages_cpp nesfr3_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bayes_people_tracker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/bayes_people_tracker
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(bayes_people_tracker_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(bayes_people_tracker_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()
if(TARGET nesfr3_msgs_generate_messages_eus)
  add_dependencies(bayes_people_tracker_generate_messages_eus nesfr3_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bayes_people_tracker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/bayes_people_tracker
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(bayes_people_tracker_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(bayes_people_tracker_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET nesfr3_msgs_generate_messages_lisp)
  add_dependencies(bayes_people_tracker_generate_messages_lisp nesfr3_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bayes_people_tracker)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/bayes_people_tracker
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(bayes_people_tracker_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(bayes_people_tracker_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()
if(TARGET nesfr3_msgs_generate_messages_nodejs)
  add_dependencies(bayes_people_tracker_generate_messages_nodejs nesfr3_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bayes_people_tracker)
  install(CODE "execute_process(COMMAND \"/usr/bin/python2\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bayes_people_tracker\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/bayes_people_tracker
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(bayes_people_tracker_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(bayes_people_tracker_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET nesfr3_msgs_generate_messages_py)
  add_dependencies(bayes_people_tracker_generate_messages_py nesfr3_msgs_generate_messages_py)
endif()
