xhost +local:docker
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

echo "Stopping nesfr3 container"
docker stop nesfr3
echo "Removing nesfr3 container"
docker rm nesfr3

# Download the VOC dataset for INT8 Calibration
#DATA_DIR=VOCdevkit
#if [ -d "$DATA_DIR" ]; then
#	echo "$DATA_DIR has already been downloaded"
#else
#	echo "Downloading VOC dataset"
#	wget http://host.robots.ox.ac.uk/pascal/VOC/voc2007/VOCtest_06-Nov-2007.tar
#	tar -xf VOCtest_06-Nov-2007.tar
#fi

if [ ! -z $(docker images -q nesfr3:v201912260) ]; then
	echo "Dockerfile has already been built"
else
	echo "Building nesfr3 image"
	docker build -f Dockerfile --tag=nesfr3:v201912260 .
fi

docker run --gpus all -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all nesfr3:v201912260

