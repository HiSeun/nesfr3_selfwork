#!/bin/bash
# A script that configures the CAN interface. restart-ms 1 is required
# to be persistent in high load environment

# NOTE: You can make it run on startup by executing it inside /etc/rc.local before the exit 0

sudo busybox devmem 0x0c303000 32 0x0000C400
sudo busybox devmem 0x0c303008 32 0x0000C458
sudo busybox devmem 0x0c303010 32 0x0000C400
sudo busybox devmem 0x0c303018 32 0x0000C458
sudo insmod /lib/modules/4.9.140-tegra/kernel/net/can/can.ko
sudo insmod /lib/modules/4.9.140-tegra/kernel/net/can/can-raw.ko
sudo insmod /lib/modules/4.9.140-tegra/kernel/net/can/can-bcm.ko
sudo insmod /lib/modules/4.9.140-tegra/kernel/net/can/can-gw.ko
sudo insmod /lib/modules/4.9.140-tegra/kernel/drivers/net/can/can-dev.ko
sudo insmod /lib/modules/4.9.140-tegra/kernel/drivers/net/can/mttcan/native/mttcan.ko
sudo ip link set can0 type can bitrate 1000000
sudo ip link set can0 type can restart-ms 1
sudo ip link set up can0
exit 0

