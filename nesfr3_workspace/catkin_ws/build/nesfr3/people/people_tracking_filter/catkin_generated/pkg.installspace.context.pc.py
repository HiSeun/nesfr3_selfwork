# generated from catkin/cmake/template/pkg.context.pc.in
CATKIN_PACKAGE_PREFIX = ""
PROJECT_PKG_CONFIG_INCLUDE_DIRS = "${prefix}/include".split(';') if "${prefix}/include" != "" else []
PROJECT_CATKIN_DEPENDS = "geometry_msgs;message_filters;people_msgs;roscpp;sensor_msgs;std_msgs;tf".replace(';', ' ')
PKG_CONFIG_LIBRARIES_WITH_PREFIX = "-lpeople_tracking_filter".split(';') if "-lpeople_tracking_filter" != "" else []
PROJECT_NAME = "people_tracking_filter"
PROJECT_SPACE_DIR = "/mnt/catkin_ws/install"
PROJECT_VERSION = "1.2.0"
