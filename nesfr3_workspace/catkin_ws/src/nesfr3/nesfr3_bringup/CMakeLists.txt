cmake_minimum_required(VERSION 2.8.3)
project(nesfr3_bringup)

add_compile_options(-std=c++11)

find_package(catkin REQUIRED COMPONENTS
)

catkin_package(
  CATKIN_DEPENDS
)

include_directories(
  ${catkin_INCLUDE_DIRS}
)

install(DIRECTORY launch
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

install(DIRECTORY scripts
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)
