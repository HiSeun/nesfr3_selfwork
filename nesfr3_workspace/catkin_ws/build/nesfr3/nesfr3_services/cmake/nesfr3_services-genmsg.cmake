# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "nesfr3_services: 0 messages, 1 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/melodic/share/std_msgs/cmake/../msg;-Inav_msgs:/opt/ros/melodic/share/nav_msgs/cmake/../msg;-Inesfr3_msgs:/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg;-Igeometry_msgs:/opt/ros/melodic/share/geometry_msgs/cmake/../msg;-Iactionlib_msgs:/opt/ros/melodic/share/actionlib_msgs/cmake/../msg;-Isensor_msgs:/opt/ros/melodic/share/sensor_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(nesfr3_services_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" NAME_WE)
add_custom_target(_nesfr3_services_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "nesfr3_services" "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" ""
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(nesfr3_services
  "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/nesfr3_services
)

### Generating Module File
_generate_module_cpp(nesfr3_services
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/nesfr3_services
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(nesfr3_services_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(nesfr3_services_generate_messages nesfr3_services_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" NAME_WE)
add_dependencies(nesfr3_services_generate_messages_cpp _nesfr3_services_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(nesfr3_services_gencpp)
add_dependencies(nesfr3_services_gencpp nesfr3_services_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS nesfr3_services_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages

### Generating Services
_generate_srv_eus(nesfr3_services
  "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/nesfr3_services
)

### Generating Module File
_generate_module_eus(nesfr3_services
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/nesfr3_services
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(nesfr3_services_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(nesfr3_services_generate_messages nesfr3_services_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" NAME_WE)
add_dependencies(nesfr3_services_generate_messages_eus _nesfr3_services_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(nesfr3_services_geneus)
add_dependencies(nesfr3_services_geneus nesfr3_services_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS nesfr3_services_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(nesfr3_services
  "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/nesfr3_services
)

### Generating Module File
_generate_module_lisp(nesfr3_services
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/nesfr3_services
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(nesfr3_services_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(nesfr3_services_generate_messages nesfr3_services_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" NAME_WE)
add_dependencies(nesfr3_services_generate_messages_lisp _nesfr3_services_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(nesfr3_services_genlisp)
add_dependencies(nesfr3_services_genlisp nesfr3_services_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS nesfr3_services_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages

### Generating Services
_generate_srv_nodejs(nesfr3_services
  "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/nesfr3_services
)

### Generating Module File
_generate_module_nodejs(nesfr3_services
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/nesfr3_services
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(nesfr3_services_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(nesfr3_services_generate_messages nesfr3_services_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" NAME_WE)
add_dependencies(nesfr3_services_generate_messages_nodejs _nesfr3_services_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(nesfr3_services_gennodejs)
add_dependencies(nesfr3_services_gennodejs nesfr3_services_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS nesfr3_services_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(nesfr3_services
  "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/nesfr3_services
)

### Generating Module File
_generate_module_py(nesfr3_services
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/nesfr3_services
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(nesfr3_services_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(nesfr3_services_generate_messages nesfr3_services_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/mnt/catkin_ws/src/nesfr3/nesfr3_services/srv/FollowActor.srv" NAME_WE)
add_dependencies(nesfr3_services_generate_messages_py _nesfr3_services_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(nesfr3_services_genpy)
add_dependencies(nesfr3_services_genpy nesfr3_services_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS nesfr3_services_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/nesfr3_services)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/nesfr3_services
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(nesfr3_services_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()
if(TARGET nav_msgs_generate_messages_cpp)
  add_dependencies(nesfr3_services_generate_messages_cpp nav_msgs_generate_messages_cpp)
endif()
if(TARGET nesfr3_msgs_generate_messages_cpp)
  add_dependencies(nesfr3_services_generate_messages_cpp nesfr3_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/nesfr3_services)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/nesfr3_services
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(nesfr3_services_generate_messages_eus std_msgs_generate_messages_eus)
endif()
if(TARGET nav_msgs_generate_messages_eus)
  add_dependencies(nesfr3_services_generate_messages_eus nav_msgs_generate_messages_eus)
endif()
if(TARGET nesfr3_msgs_generate_messages_eus)
  add_dependencies(nesfr3_services_generate_messages_eus nesfr3_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/nesfr3_services)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/nesfr3_services
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(nesfr3_services_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()
if(TARGET nav_msgs_generate_messages_lisp)
  add_dependencies(nesfr3_services_generate_messages_lisp nav_msgs_generate_messages_lisp)
endif()
if(TARGET nesfr3_msgs_generate_messages_lisp)
  add_dependencies(nesfr3_services_generate_messages_lisp nesfr3_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/nesfr3_services)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/nesfr3_services
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(nesfr3_services_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()
if(TARGET nav_msgs_generate_messages_nodejs)
  add_dependencies(nesfr3_services_generate_messages_nodejs nav_msgs_generate_messages_nodejs)
endif()
if(TARGET nesfr3_msgs_generate_messages_nodejs)
  add_dependencies(nesfr3_services_generate_messages_nodejs nesfr3_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/nesfr3_services)
  install(CODE "execute_process(COMMAND \"/usr/bin/python2\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/nesfr3_services\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/nesfr3_services
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(nesfr3_services_generate_messages_py std_msgs_generate_messages_py)
endif()
if(TARGET nav_msgs_generate_messages_py)
  add_dependencies(nesfr3_services_generate_messages_py nav_msgs_generate_messages_py)
endif()
if(TARGET nesfr3_msgs_generate_messages_py)
  add_dependencies(nesfr3_services_generate_messages_py nesfr3_msgs_generate_messages_py)
endif()
