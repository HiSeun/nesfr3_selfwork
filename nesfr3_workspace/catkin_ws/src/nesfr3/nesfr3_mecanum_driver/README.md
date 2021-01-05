## Mecanum wheel driver for NESFR3

## External dependencies
no external dependency required.

## Launching
1. Basic joystick control  
`roslaunch nesfr3_bringup nesfr3_remote_basic.launch`
2. Joystick control with cartographer  
`roslaunch nesfr3_bringup nesfr3_remote_carto.launch`

## Useful scripts
1. Sending constant velocity command  
`rosrun nesfr3_bringup vel_cmd_sender.py x_vel y_vel timetostop`
