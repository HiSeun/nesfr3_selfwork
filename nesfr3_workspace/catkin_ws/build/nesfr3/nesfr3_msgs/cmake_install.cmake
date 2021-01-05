# Install script for directory: /mnt/catkin_ws/src/nesfr3/nesfr3_msgs

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/mnt/catkin_ws/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/nesfr3_msgs/msg" TYPE FILE FILES
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/PointWithConfidence.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/Actor2d.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/Actor.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/Actors2d.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/Actors.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/Blob.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/Blobs.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/BlobsArray.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/BoundingBox.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/BoundingBoxes.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/ClusterProps.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/ClusterPropsArray.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/PoseArrayWithBoxes.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/PoseArrayWithClusters.msg"
    "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/msg/TrackingData.msg"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/nesfr3_msgs/cmake" TYPE FILE FILES "/mnt/catkin_ws/build/nesfr3/nesfr3_msgs/catkin_generated/installspace/nesfr3_msgs-msg-paths.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/mnt/catkin_ws/devel/include/nesfr3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/mnt/catkin_ws/devel/share/roseus/ros/nesfr3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/mnt/catkin_ws/devel/share/common-lisp/ros/nesfr3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/mnt/catkin_ws/devel/share/gennodejs/ros/nesfr3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/usr/bin/python2" -m compileall "/mnt/catkin_ws/devel/lib/python2.7/dist-packages/nesfr3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python2.7/dist-packages" TYPE DIRECTORY FILES "/mnt/catkin_ws/devel/lib/python2.7/dist-packages/nesfr3_msgs")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/mnt/catkin_ws/build/nesfr3/nesfr3_msgs/catkin_generated/installspace/nesfr3_msgs.pc")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/nesfr3_msgs/cmake" TYPE FILE FILES "/mnt/catkin_ws/build/nesfr3/nesfr3_msgs/catkin_generated/installspace/nesfr3_msgs-msg-extras.cmake")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/nesfr3_msgs/cmake" TYPE FILE FILES
    "/mnt/catkin_ws/build/nesfr3/nesfr3_msgs/catkin_generated/installspace/nesfr3_msgsConfig.cmake"
    "/mnt/catkin_ws/build/nesfr3/nesfr3_msgs/catkin_generated/installspace/nesfr3_msgsConfig-version.cmake"
    )
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/nesfr3_msgs" TYPE FILE FILES "/mnt/catkin_ws/src/nesfr3/nesfr3_msgs/package.xml")
endif()

