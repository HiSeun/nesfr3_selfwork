#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/mnt/catkin_ws/src/nesfr3/wu_ros_tools/kalman_filter"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/mnt/catkin_ws/install/lib/python2.7/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/mnt/catkin_ws/install/lib/python2.7/dist-packages:/mnt/catkin_ws/build/lib/python2.7/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/mnt/catkin_ws/build" \
    "/usr/bin/python2" \
    "/mnt/catkin_ws/src/nesfr3/wu_ros_tools/kalman_filter/setup.py" \
     \
    build --build-base "/mnt/catkin_ws/build/nesfr3/wu_ros_tools/kalman_filter" \
    install \
    --root="${DESTDIR-/}" \
    --install-layout=deb --prefix="/mnt/catkin_ws/install" --install-scripts="/mnt/catkin_ws/install/bin"
