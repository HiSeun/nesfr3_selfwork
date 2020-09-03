FROM osrf/ros:melodic-desktop-full

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    wget \
    zlib1g-dev \
    git \
    pkg-config \
    python3 \
    python3-pip \
    python3-dev \
    python3-setuptools \
    python3-wheel \
    sudo \
    ssh \
    pbzip2 \
    pv \
    bzip2 \
    tmux \
    unzip \
    vim

# Bump cmake version to 3.18.2
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.18.2/cmake-3.18.2-Linux-x86_64.sh && \
    chmod +x cmake-3.18.2-Linux-x86_64.sh && \
    ./cmake-3.18.2-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
    rm ./cmake-3.18.2-Linux-x86_64.sh

RUN mkdir -p /root/.gazebo &&\
        cd /root/.gazebo &&\
        git clone https://github.com/osrf/gazebo_models.git models

ENV DEBIAN_FRONTEND noninteractive
ENV os ubuntu1804

# cuda 10.1: used 10.1 for using tensorrt engine built on cuda 10.1
# From https://developer.nvidia.com/cuda-10.1-download-archive-base?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=1804&target_type=deblocal
ENV cudatag 10-1-local-10.1.105-418.39
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1J5g516QdN8DB5IIgw-59cRYxxEgZUZjZ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1J5g516QdN8DB5IIgw-59cRYxxEgZUZjZ" -O cuda-repo-${os}-${cudatag}_1.0-1_amd64.deb && \
    rm -rf /tmp/cookies.txt && \
    dpkg -i cuda-repo-${os}-${cudatag}_1.0-1_amd64.deb && \
    apt-key add /var/cuda-repo-${cudatag}/7fa2af80.pub && \
    apt-get update && apt-get -y install cuda-toolkit-10-1 && \
    rm cuda-repo-${os}-${cudatag}_1.0-1_amd64.deb

RUN apt-get install -y python-pip &&\
        pip --no-cache-dir install torch torchvision yacs future pycocotools tqdm

RUN apt-get install -y ros-melodic-joy ros-melodic-cartographer-ros ros-melodic-velodyne-simulator

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list' &&\
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2486D2DD83DB69272AFE98867170598AF249743 &&\
        apt update &&\
        apt upgrade -y

RUN sed -i '/_TIMEOUT_SIGINT/s/15.0/0.5/g' /opt/ros/melodic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py &&\
        sed -i '/_TIMEOUT_SIGTERM/s/2.0/0.5/g' /opt/ros/melodic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py

# TensorRT 6.0.1 with cuda 10.1
# From https://developer.nvidia.com/nvidia-tensorrt-6x-download
ENV trttag cuda10.1-trt6.0.1.5-ga-20190913
RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1vMA6PuW5ZESxtTmqNub9FS_9G0fl1Cxv' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1vMA6PuW5ZESxtTmqNub9FS_9G0fl1Cxv" -O nv-tensorrt-repo-${os}-${trttag}_1-1_amd64.deb && \
    rm -rf /tmp/cookies.txt && \
    dpkg -i nv-tensorrt-repo-${os}-${trttag}_1-1_amd64.deb && \
    apt-key add /var/nv-tensorrt-repo-${trttag}/7fa2af80.pub && \
    apt-get update && apt-get install -y tensorrt && apt-get install -y python-libnvinfer-dev && \
    rm nv-tensorrt-repo-${os}-${trttag}_1-1_amd64.deb

#Install face_recognition and dependencies
RUN git clone -b 'v19.16' --single-branch https://github.com/davisking/dlib.git &&\
    sed -i 's/${cuda_blas_path}/\/usr\/local\/cuda\/targets\/x86_64-linux\/lib/g' /dlib/dlib/CMakeLists.txt &&\
    mkdir -p /dlib/build &&\
    cmake -H/dlib -B/dlib/build -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 &&\
    cmake --build /dlib/build &&\
    cd /dlib &&\
    python /dlib/setup.py install &&\
    pip install -U scikit-build &&\
    pip install opencv_python &&\
    pip install face_recognition &&\
    pip install scipy &&\
    pip install -U scikit-learn

#Install torch2trt
RUN git clone https://github.com/NVIDIA-AI-IOT/torch2trt.git && \
    cd torch2trt && \
    python setup.py install

#Install trt_pose
RUN git clone https://github.com/NVIDIA-AI-IOT/trt_pose.git && \
    cd trt_pose && \
    python setup.py install

RUN apt update && apt install -y \
    libnvinfer-dev \
    libnvparsers-dev \
    python-libnvinfer-dev

# install numba and its dependency
RUN apt-get install -y llvm &&\
    pip install llvmlite==0.31 &&\
    pip install colorama==0.3.9 &&\
    pip install numba

ENV CUDACXX /usr/local/cuda/bin/nvcc
ENV PATH $PATH:/usr/local/cuda/bin

# install pycuda
RUN pip install pycuda==2019.1
# install pytools compatible with python2 for pycuda
RUN pip install pytools==2020.2

# install nsight-sys
RUN apt-get update -y && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        dbus \
        fontconfig \
        gnupg \
        libfreetype6 \
        libglib2.0-0 \
        libsqlite3-0 \
        libx11-xcb1 \
        libxcb-glx0 \
        libxcb-xkb1 \
        libxcomposite1 \
        libxi6 \
        libxml2 \
        libxrender1 \
        openssh-client \
        wget \
        xcb \
        xkb-data && \
    wget -qO - https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/7fa2af80.pub | apt-key add -  && \ 
    echo "deb https://developer.download.nvidia.com/devtools/repo-deb/x86_64/ /" >> /etc/apt/sources.list.d/nsight.list && \
    apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    nsight-systems-2020.2.1 && \   
    rm -rf /var/lib/apt/lists/* 

# env for nsight-sys
ENV LC_ALL=C

RUN apt-get update
RUN apt-get install -y ros-melodic-bfl ros-melodic-velodyne* ros-melodic-cob-perception-msgs

# env for ouster-ros
RUN apt-get install -y libglfw3-dev libglew-dev libtclap-dev
ENV ouster_client_DIR /mnt/catkin_ws/src/nesfr3/nesfr3_ouster/ouster_client/cmake/
ENV ouster_viz_DIR /mnt/catkin_ws/src/nesfr3/nesfr3_ouster/ouster_viz/cmake/

WORKDIR /mnt
CMD /bin/bash

RUN echo 'source /mnt/catkin_ws/devel/setup.bash' >> /etc/bash.bashrc
