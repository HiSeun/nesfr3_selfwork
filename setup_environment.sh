xhost +local:docker
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

echo "Stopping nesfr3 container"
docker stop nesfr3
echo "Removing nesfr3 container"
docker rm nesfr3

NESFR3_VERSION=v202006230
if [ ! -z $(docker images -q nesfr3:$NESFR3_VERSION) ]; then
	echo "Dockerfile has already been built"
else
	echo "Building nesfr3 image"
	docker build -f Dockerfile --tag=nesfr3:$NESFR3_VERSION .
fi

JOYSTICK=/dev/input/js0
if [ -c "$JOYSTICK" ]; then
    docker run --gpus all --privileged --cap-add=SYS_ADMIN -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt --device=$JOYSTICK -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all nesfr3:$NESFR3_VERSION
else
	echo "Cannot find joystick. It's okay though."
    docker run --gpus all --privileged --cap-add=SYS_ADMIN -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all nesfr3:$NESFR3_VERSION
fi
