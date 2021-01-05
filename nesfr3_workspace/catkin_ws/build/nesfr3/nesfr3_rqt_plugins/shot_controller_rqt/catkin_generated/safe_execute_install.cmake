execute_process(COMMAND "/mnt/catkin_ws/build/nesfr3/nesfr3_rqt_plugins/shot_controller_rqt/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/mnt/catkin_ws/build/nesfr3/nesfr3_rqt_plugins/shot_controller_rqt/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
