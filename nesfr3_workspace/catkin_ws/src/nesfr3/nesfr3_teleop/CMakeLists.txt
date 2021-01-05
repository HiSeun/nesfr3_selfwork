cmake_minimum_required(VERSION 2.8.3)
project(nesfr3_teleop)

find_package(catkin REQUIRED COMPONENTS
  joy
  pcl_ros
  roscpp
  geometry_msgs
  std_msgs
)

catkin_package(
 INCLUDE_DIRS include
 LIBRARIES drive
 CATKIN_DEPENDS
  pcl_ros
  roscpp
  geometry_msgs
  std_msgs
)

include_directories(
  include
  ${catkin_INCLUDE_DIRS}
)

add_library(drive src/drive.cpp)

add_executable(nesfr3_teleop_node
  src/joystick.cpp
  src/drive.cpp
  )

target_link_libraries(nesfr3_teleop_node
  ${catkin_LIBRARIES}
  )
add_dependencies(nesfr3_teleop_node
  ${catkin_EXPORTED_TARGETS}
  )