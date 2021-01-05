cmake_minimum_required(VERSION 2.8.3)
project(pcl_transformer)

find_package(catkin REQUIRED COMPONENTS 
  roscpp 
  sensor_msgs 
  std_msgs 
  visualization_msgs 
  nesfr3_msgs 
  cob_perception_msgs 
  geometry_msgs 
  pcl_conversions 
  pcl_ros 
  message_filters
  cv_bridge
  image_transport
)


find_package(PCL REQUIRED)
find_package(OpenCV REQUIRED)

include_directories(include ${catkin_INCLUDE_DIRS} ${OpenCV_INCLUDE_DIRS})

catkin_package(INCLUDE_DIRS)

add_executable(${PROJECT_NAME}_node src/pcl_transformer.cpp)

target_link_libraries(${PROJECT_NAME}_node ${catkin_LIBRARIES} ${OpenCV_LIBRARIES})
if(catkin_EXPORTED_TARGETS)
  add_dependencies(${PROJECT_NAME}_node ${catkin_EXPORTED_TARGETS})
endif()
