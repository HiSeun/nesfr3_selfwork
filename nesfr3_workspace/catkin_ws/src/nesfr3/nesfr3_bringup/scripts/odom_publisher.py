#!/usr/bin/env python
import rospy
import tf
from geometry_msgs.msg import Twist
from nav_msgs.msg import Odometry

if __name__ == '__main__':
    rospy.init_node('odom_publisher')

    listener = tf.TransformListener()
    odom_pub = rospy.Publisher("/nesfr3/1/map", Odometry, queue_size=1)
    rate = rospy.Rate(100.0)
    listener.waitForTransform('nesfr3/1/map', 'nesfr3/1/base_link', rospy.Time(), rospy.Duration(10))
    while not rospy.is_shutdown():
        try:
            (trans,rot) = listener.lookupTransform('nesfr3/1/map', 'nesfr3/1/base_link', rospy.Time(0))
        except (tf.LookupException, tf.ConnectivityException, tf.ExtrapolationException):
            continue

        msg = Odometry()
        msg.header.stamp = rospy.Time.now()
        msg.header.frame_id = "nesfr3/1/map"
        msg.pose.pose.position.x = trans[0]
        msg.pose.pose.position.y = trans[1]
        msg.pose.pose.orientation.x = rot[0]
        msg.pose.pose.orientation.y = rot[1]
        msg.pose.pose.orientation.z = rot[2]
        msg.pose.pose.orientation.w = rot[3]
        odom_pub.publish(msg)

        rate.sleep()



