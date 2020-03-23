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

# Bump cmake version to 3.14
RUN cd /tmp && \
    wget https://github.com/Kitware/CMake/releases/download/v3.14.4/cmake-3.14.4-Linux-x86_64.sh && \
    chmod +x cmake-3.14.4-Linux-x86_64.sh && \
    ./cmake-3.14.4-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir --skip-license && \
    rm ./cmake-3.14.4-Linux-x86_64.sh

RUN mkdir -p /root/.gazebo &&\
        cd /root/.gazebo &&\
        hg clone https://bitbucket.org/osrf/gazebo_models models

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin &&\
        mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 &&\
        wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb &&\
        dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb &&\
        apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub &&\
        apt-get update &&\
        apt-get -y install cuda-toolkit-10-2

RUN apt-get install -y python-pip &&\
        pip --no-cache-dir install torch torchvision yacs future pycocotools tqdm

RUN apt-get install -y ros-melodic-joy ros-melodic-cartographer-ros ros-melodic-velodyne-simulator

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list' &&\
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2486D2DD83DB69272AFE98867170598AF249743 &&\
        apt update &&\
        apt upgrade -y

RUN sed -i '/_TIMEOUT_SIGINT/s/15.0/0.5/g' /opt/ros/melodic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py &&\
        sed -i '/_TIMEOUT_SIGTERM/s/2.0/0.5/g' /opt/ros/melodic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py

RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1BXgxGIXM6E6TNP4-2JDRmPU4ln7ZjcDC' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1BXgxGIXM6E6TNP4-2JDRmPU4ln7ZjcDC" -O libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb && \
   rm -rf /tmp/cookies.txt  && \
   dpkg -i libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb && \
   wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1i36naZvF4RtPM_MPHPLv6HKLYUCnL17e' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1i36naZvF4RtPM_MPHPLv6HKLYUCnL17e" -O libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb && \
   rm -rf /tmp/cookies.txt  &&\
   dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb && \
   wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1ftZp3WATRcfGlIgBWxLQqMr8QI8MJDaA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1ftZp3WATRcfGlIgBWxLQqMr8QI8MJDaA" -O nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.0.0.11-ga-20191216_1-1_amd64.deb && \
   rm -rf /tmp/cookies.txt  &&\
   dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.0.0.11-ga-20191216_1-1_amd64.deb && \
   apt update

#Install face_recognition and dependencies
RUN git clone -b 'v19.16' --single-branch https://github.com/davisking/dlib.git &&\
    sed -i 's/${cuda_blas_path}/\/usr\/local\/cuda\/targets\/x86_64-linux\/lib/g' /dlib/dlib/CMakeLists.txt &&\
    mkdir -p /dlib/build &&\
    cmake -H/dlib -B/dlib/build -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 &&\
    cmake --build /dlib/build &&\
    cd /dlib &&\
    python /dlib/setup.py install &&\
    pip install opencv_python &&\
    pip install face_recognition &&\
    pip install scipy

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

ENV CUDACXX /usr/local/cuda/bin/nvcc
ENV PATH $PATH:/usr/local/cuda/bin

WORKDIR /mnt
CMD /bin/bash

RUN echo 'source /mnt/catkin_ws/devel/setup.bash' >> /etc/bash.bashrc