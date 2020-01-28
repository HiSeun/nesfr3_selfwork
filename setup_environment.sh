xhost +local:docker
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

echo "Stopping nesfr3 container"
docker stop nesfr3
echo "Removing nesfr3 container"
docker rm nesfr3

# Download the HRNet dataset for INT8 Calibration
DATA_DIR=HRNetData
if [ -d "$DATA_DIR" ]; then
	echo "$DATA_DIR has already been downloaded"
else
	echo "Downloading HRNet dataset 001"
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1FmolGX7-pqimz6t8cwjuJWfrwDUsgwmW' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1FmolGX7-pqimz6t8cwjuJWfrwDUsgwmW" -O hrnet-001.zip && rm -rf /tmp/cookies.txt
	echo "Downloading HRNet dataset 002"
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1EIc9zwtHcT-nTEit6dMmiqFVTI3bh3KO' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1EIc9zwtHcT-nTEit6dMmiqFVTI3bh3KO" -O hrnet-002.zip && rm -rf /tmp/cookies.txt
	unzip hrnet-001.zip -d $DATA_DIR
	unzip hrnet-002.zip -d $DATA_DIR
fi

# Download the Yolov3 weight for human(object) detection
WEIGHT_DIR=catkin_ws/src/nesfr3/nesfr3_detection/weight
if [ -d "$WEIGHT_DIR" ]; then
	echo "Yolov3 weight has already been downloaded"
else
	echo "Downloading Yolov3 weight"
    wget -P catkin_ws/src/nesfr3/nesfr3_detection/weight https://pjreddie.com/media/files/yolov3.weights
fi

NESFR3_VERSION=v202001280
if [ ! -z $(docker images -q nesfr3:$NESFR3_VERSION) ]; then
	echo "Dockerfile has already been built"
else
	echo "Building nesfr3 image"
	docker build -f Dockerfile --tag=nesfr3:$NESFR3_VERSION .
fi

JOYSTICK=/dev/input/js0
if [ -c "$JOYSTICK" ]; then
    docker run --gpus all -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt --device=$JOYSTICK -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all nesfr3:$NESFR3_VERSION
else
	echo "Cannot find joystick. It's okay though."
    docker run --gpus all -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all nesfr3:$NESFR3_VERSION
fi
