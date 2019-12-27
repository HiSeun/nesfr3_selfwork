FROM osrf/ros:melodic-desktop-full
RUN apt-get update && apt-get upgrade -y --no-install-recommends

RUN mkdir -p /root/.gazebo &&\
        cd /root/.gazebo &&\
        hg clone https://bitbucket.org/osrf/gazebo_models models

WORKDIR /mnt
CMD /bin/bash
