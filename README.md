# NESFR3
NESFR3 Docker Environment

## Docker

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

