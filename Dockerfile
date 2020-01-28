FROM osrf/ros:melodic-desktop-full
RUN apt-get update && apt-get upgrade -y --no-install-recommends

RUN mkdir -p /root/.gazebo &&\
        cd /root/.gazebo &&\
        hg clone https://bitbucket.org/osrf/gazebo_models models

RUN apt-get install -y tmux vim wget

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin &&\
        mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 &&\
        wget http://developer.download.nvidia.com/compute/cuda/10.2/Prod/local_installers/cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb &&\
        dpkg -i cuda-repo-ubuntu1804-10-2-local-10.2.89-440.33.01_1.0-1_amd64.deb &&\
        apt-key add /var/cuda-repo-10-2-local-10.2.89-440.33.01/7fa2af80.pub &&\
        apt-get update &&\
        apt-get -y install cuda-toolkit-10-2

RUN apt-get install -y python-pip &&\
        pip --no-cache-dir install torch torchvision yacs future

RUN apt-get install -y ros-melodic-joy ros-melodic-cartographer-ros ros-melodic-velodyne-simulator

RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/gazebo-stable.list' &&\
        apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D2486D2DD83DB69272AFE98867170598AF249743 &&\
        apt update &&\
        apt upgrade -y

RUN sed -i '/_TIMEOUT_SIGINT/s/15.0/0.5/g' /opt/ros/melodic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py &&\
        sed -i '/_TIMEOUT_SIGTERM/s/2.0/0.5/g' /opt/ros/melodic/lib/python2.7/dist-packages/roslaunch/nodeprocess.py

RUN wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1BXgxGIXM6E6TNP4-2JDRmPU4ln7ZjcDC' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1BXgxGIXM6E6TNP4-2JDRmPU4ln7ZjcDC" -O libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb && rm -rf /tmp/cookies.txt  &&\
        dpkg -i libcudnn7_7.6.5.32-1+cuda10.2_amd64.deb &&\
        wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1i36naZvF4RtPM_MPHPLv6HKLYUCnL17e' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1i36naZvF4RtPM_MPHPLv6HKLYUCnL17e" -O libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb && rm -rf /tmp/cookies.txt  &&\
        dpkg -i libcudnn7-dev_7.6.5.32-1+cuda10.2_amd64.deb

#Install face_recognition and dependencies
RUN git clone -b 'v19.16' --single-branch https://github.com/davisking/dlib.git &&\
        sed -i 's/${cuda_blas_path}/\/usr\/local\/cuda\/targets\/x86_64-linux\/lib/g' /dlib/dlib/CMakeLists.txt &&\
        mkdir -p /dlib/build &&\
        cmake -H/dlib -B/dlib/build -DDLIB_USE_CUDA=1 -DUSE_AVX_INSTRUCTIONS=1 &&\
        cmake --build /dlib/build &&\
        cd /dlib &&\
        python /dlib/setup.py install &&\
        pip install opencv_python &&\
        pip install face_recognition


WORKDIR /mnt
CMD /bin/bash
