import cv2
import rospy
import time
import sys
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

if len(sys.argv) == 2:
    robot_index = sys.argv[1]
else:
    print("There needs to be precisely one argument, the robot's index.")
    quit()

rospy.init_node('video_publisher_' + robot_index, anonymous=True)

video_pub = rospy.Publisher("/nesfr3/" + robot_index + "/main_camera/image_raw",Image, queue_size=1)
input_movie = cv2.VideoCapture("hamilton_clip.mp4")

while True:
    # Grab a single frame of video
    ret, frame = input_movie.read()
    img_msg = CvBridge().cv2_to_imgmsg(frame, "bgr8")
    video_pub.publish(img_msg)
    time.sleep(0.1)
