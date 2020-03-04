# NESFR3
NESFR3 Docker Environment

# [Quickstart]

[Quickstart]: https://github.com/wom-ai/nesfr3_workspace/wiki/Quickstart

# [Overview]
[Overview]: https://github.com/wom-ai/nesfr3_workspace/wiki/Overview

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
### If there's `OCI runtime create failed: ` error
```
$ sudo rm -rf /tmp/.docker.xauth/
$ touch /tmp/.docker.xauth
```

## Trouble Shooting

