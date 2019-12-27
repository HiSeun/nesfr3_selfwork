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
	echo "Downloading HRNet dataset"
    wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1AHb0TSp1O2PGarZW_MO2nF-ygQY2_fm7' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1AHb0TSp1O2PGarZW_MO2nF-ygQY2_fm7" -O hrnet.zip && rm -rf /tmp/cookies.txt
	unzip hrnet.zip -d $DATA_DIR
fi

NESFR3_VERSION=v201912272
if [ ! -z $(docker images -q nesfr3:$NESFR3_VERSION) ]; then
	echo "Dockerfile has already been built"
else
	echo "Building nesfr3 image"
	docker build -f Dockerfile --tag=nesfr3:$NESFR3_VERSION .
fi

docker run --gpus all -it --name nesfr3 -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -v `pwd`:/mnt -v /dev/input:/dev/input -e XAUTHORITY=$XAUTH -e QT_X11_NO_MITSHM=1 -e NVIDIA_DRIVER_CAPABILITIES=all nesfr3:$NESFR3_VERSION

