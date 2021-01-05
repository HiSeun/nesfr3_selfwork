execute_process(COMMAND "/mnt/catkin_ws/build/nesfr3/wu_ros_tools/easy_markers/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/mnt/catkin_ws/build/nesfr3/wu_ros_tools/easy_markers/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
