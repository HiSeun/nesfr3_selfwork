# NESFR3
NESFR3 Docker Environment

## Docker

### Setup environment
```
$ ./setup_environment.sh
```

### Start stopped container
```
$ ./run_container.sh
```

If there's `OCI runtime create failed: ` error
```
$ sudo rm -rf /tmp/.docker.xauth/
$ touch /tmp/.docker.xauth
```

### Execute interactive `bash`
```
$ docker exec -it nesfr_185 bash
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

