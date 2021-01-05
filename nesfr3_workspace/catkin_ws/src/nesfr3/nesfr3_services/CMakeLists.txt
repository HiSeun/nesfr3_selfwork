cmake_minimum_required(VERSION 2.8.3)
project(nesfr3_services)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  std_msgs
  nav_msgs
  message_generation
  nesfr3_teleop
  nesfr3_msgs
)

find_package(gazebo REQUIRED)

## Generate services in the 'srv' folder
add_service_files(
  FILES
  FollowActor.srv
)
## Generate added messages and services with any dependencies listed here
generate_messages(
  DEPENDENCIES
  std_msgs
  nav_msgs
  nesfr3_msgs
)

catkin_package()

include_directories(
  include
  ${GAZEBO_INCLUDE_DIRS}
  ${catkin_INCLUDE_DIRS}
  ${GAZEBO_INCLUDE_DIRS}
)

add_executable(shot_controller src/shot_controller.cpp)
target_link_libraries(shot_controller ${catkin_LIBRARIES})

add_executable(shot_controller_client src/shot_controller_client.cpp)
target_link_libraries(shot_controller_client ${catkin_LIBRARIES})

