#!/bin/bash
sudo apt install -y ros-melodic-desktop-full \
    ros-melodic-image-exposure-msgs ros-melodic-wfov-camera-msgs ros-melodic-cob-perception-msgs \
    ros-melodic-joy ros-melodic-bfl \
    libglfw3-dev libglew-dev libtclap-dev \
    ros-melodic-cartographer-ros

# xbox controller bluetooth setup
sudo apt install sysfsutils
sudo sh -c 'echo /module/bluetooth/parameters/disable_ertm=1 >> /etc/sysfs.conf'
sudo service bluetooth restart
