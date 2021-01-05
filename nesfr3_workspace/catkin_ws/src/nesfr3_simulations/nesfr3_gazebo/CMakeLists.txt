cmake_minimum_required(VERSION 2.8.3)
project(nesfr3_gazebo)

find_package(catkin REQUIRED COMPONENTS
  dynamic_reconfigure
  gazebo_ros
  gazebo_plugins
  geometry_msgs
  joy
  message_generation
  roscpp
  rospy
  sensor_msgs
  std_msgs
)


find_package(gazebo REQUIRED)

add_service_files(FILES shot.srv)

generate_messages(DEPENDENCIES std_msgs geometry_msgs sensor_msgs)

catkin_package(
  INCLUDE_DIRS include ${GAZEBO_INCLUDE_DIRS}
  LIBRARIES gazebo_ros_utils gazebo_ros_camera_utils
  DEPENDS gazebo_ros joy roscpp rospy std_msgs
)

include_directories(include)
link_directories(${GAZEBO_LIBRARY_DIRS})
include_directories(
  ${Boost_INCLUDE_DIR}
  ${catkin_INCLUDE_DIRS}
  ${GAZEBO_INCLUDE_DIRS}
)


install(DIRECTORY models worlds
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

add_library(planar_move_plugin src/planar_move_plugin.cpp)
target_link_libraries(planar_move_plugin ${catkin_LIBRARIES} ${GAZEBO_LIBRARIES})

add_library(camera_zoom_plugin src/camera_zoom_plugin.cpp)
target_link_libraries(camera_zoom_plugin CameraPlugin ${catkin_LIBRARIES})

add_library(gimbal_pos_plugin src/gimbal_pos_plugin.cpp)
target_link_libraries(gimbal_pos_plugin ${catkin_LIBRARIES} ${GAZEBO_LIBRARIES})

add_library(actor_plugin src/actor_plugin.cpp)
add_dependencies(actor_plugin nesfr3_msgs_generate_messages_cpp)
target_link_libraries(actor_plugin ${catkin_LIBRARIES} ${GAZEBO_LIBRARIES})

add_library(fisheye_camera_plugin src/fisheye_camera_plugin.cpp)
target_link_libraries(fisheye_camera_plugin CameraPlugin ${catkin_LIBRARIES})


