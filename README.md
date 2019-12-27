# NESFR3
NESFR3 Docker Environment

## Joystick setup
It needs joystick connection to run docker.
To setup joystick,
Install sysfsutils
```
$ sudo apt install sysfsutils
```
Edit `/etc/sysfs.conf` (as root), add this line at the end of the file:
```
$ /module/bluetooth/parameters/disable_ertm=1
```
Save changes and restart

Reference:

https://askubuntu.com/questions/1038001/xbox-one-controller-ubuntu-18-04

## Docker

### Clone the repository
```
### DO NOT FORGET to include --recurse-submodules when cloning
$ git clone --recurse-submodules git@github.com:wom-ai/nesfr3_workspace.git
```

### Setup or update environment
```
$ ./setup_environment.sh
```

### If container is stopped
```
### Restart stopped container
$ ./start_container.sh
### Execute interactive `bash`
$ docker exec -it nesfr3 bash
```

### Installing dependencies and catkin_make
```
$ cd catkin_ws
$ rosdep install --from-paths src --ignore-src -r -y
$ catkin_make

```

### If there's `OCI runtime create failed: ` error
```
$ sudo rm -rf /tmp/.docker.xauth/
$ touch /tmp/.docker.xauth
```

## Trouble Shooting

### Gazebo CURL SSL error

To fix the CURL SSL error, refer below.
https://bitbucket.org/osrf/gazebo/issues/2607/error-restcc-205-during-startup-gazebo

```
You need to change ~/.ignition/fuel/config.yaml as following.

url: https://api.ignitionfuel.org
to

url: https://api.ignitionrobotics.org
```

