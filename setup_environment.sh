xhost +local:docker
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run --gpus all -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all osrf/ros:melodic-desktop-full bash

