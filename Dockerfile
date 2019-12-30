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
        pip --no-cache-dir install torch torchvision yacs

WORKDIR /mnt
CMD /bin/bash
