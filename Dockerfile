FROM osrf/ros:melodic-desktop-full
RUN apt-get update && apt-get upgrade -y --no-install-recommends

WORKDIR /mnt
CMD /bin/bash
