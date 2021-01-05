cmake_minimum_required(VERSION 2.8.3)
project(nesfr3_tracking)

find_package(catkin REQUIRED COMPONENTS
  roscpp
  std_msgs
  nesfr3_msgs
  message_generation
)

## Generate added messages and services with any dependencies listed here
generate_messages(
  DEPENDENCIES
  std_msgs
  nesfr3_msgs
)

catkin_package(
)

include_directories(
# include
  ${catkin_INCLUDE_DIRS}
)
