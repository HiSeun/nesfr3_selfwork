#!/usr/bin/env python
import rospy
import sys
import tf
import time
from geometry_msgs.msg import Twist

if __name__ == '__main__':
    rospy.init_node('vel_cmd_sender')
    if len(sys.argv) < 4:
        print("usage:  send_vel_cmd.py x y t")
    cmd_pub = rospy.Publisher("/nesfr3/1/cmd_vel", Twist, queue_size=1)
    time.sleep(1)
    msg = Twist();
    msg.linear.x  = float(sys.argv[1])
    print(msg.linear.x)
    msg.linear.y  = float(sys.argv[2])
    cmd_pub.publish(msg)
    time.sleep(float(sys.argv[3]))
    msg.linear.x = 0
    msg.linear.y = 0
    cmd_pub.publish(msg)

