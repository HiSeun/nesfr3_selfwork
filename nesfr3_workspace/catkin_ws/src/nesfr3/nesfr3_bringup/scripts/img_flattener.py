#!/usr/bin/env python2
import cv2
import rospy
import math
import numpy as np
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

IMG_WIDTH = 4000
IMG_HEIGHT = 1000
pixelMapX = np.zeros((IMG_HEIGHT, IMG_WIDTH), dtype='float32')
pixelMapY = np.zeros((IMG_HEIGHT, IMG_WIDTH), dtype='float32')

for j in range(IMG_HEIGHT):
    for i in range(IMG_WIDTH):
        theta = math.pi * i / (2 * IMG_HEIGHT)
        pixelMapX[j][i] = j * math.cos(theta) + IMG_HEIGHT
        pixelMapY[j][i] = -j * math.sin(theta) + IMG_HEIGHT


class viewer():
    def __init__(self):
        self.image_pub = rospy.Publisher('/nesfr3/1/fisheye/image_flat', Image, queue_size=1)
        self.image_sub = rospy.Subscriber('/nesfr3/1/fisheye/image_color', Image, self.callback)
        self.bridge = CvBridge()

    def callback(self, data):
        try:
            cv_image = self.bridge.imgmsg_to_cv2(data, "rgb8")
        except CvBridgeError as e:
            print(e)
            return

        img_out = cv2.remap(cv_image, pixelMapX, pixelMapY, interpolation = cv2.INTER_LINEAR)
        cv2.imshow("Image window", img_out)

        image = self.bridge.cv2_to_imgmsg(img_out, "rgb8")
        try:
            self.image_pub.publish(image)
        except CvBridgeError as e:
            print(e)


def main():
    rospy.init_node('flattener', anonymous=False, log_level=rospy.DEBUG)
    s = viewer()
    try:
        rospy.spin()
    except:
        pass
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()

