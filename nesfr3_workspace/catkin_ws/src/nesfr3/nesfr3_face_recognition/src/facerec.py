#!/usr/bin/env python

import cv2
import face_recognition
import math
import numpy as np
import os
import rospy
import sys
from sensor_msgs.msg import Image
from nesfr3_msgs.msg import Actor
from nesfr3_msgs.msg import Actors
from nesfr3_pose_estimation.srv import SetActorName
from cv_bridge import CvBridge, CvBridgeError
import message_filters

if len(sys.argv) == 4:
    robot_index = sys.argv[1]
else:
    print("There needs to be precisely one argument, the robot's index.")
    quit()

bridge = CvBridge()
face_pub = rospy.Publisher("/nesfr3/" + robot_index + "/face_recognition",Image, queue_size=1)
face_img_pub = rospy.Publisher("/nesfr3/" + robot_index + "/face_image",Image, queue_size=1)
# Create arrays of known face encodings and their names
known_face_encodings = []
known_face_names = []

# Dictionary for actor location info
actor_faces = {}

# Load known faces
data_dir = os.path.join('/mnt/catkin_ws/src/nesfr3/nesfr3_face_recognition/faces') # hard coded
for dir_name in os.listdir(data_dir):
    img_dir = os.path.join(data_dir , dir_name)
    for img_name in os.listdir(img_dir):
        img_path = os.path.join(img_dir , img_name)
        image = face_recognition.load_image_file(img_path)
        image_encoding = face_recognition.face_encodings(image)[0]
        known_face_encodings.append(image_encoding)
        known_face_names.append(dir_name)

def ActorsCallback(data,actors):

    global actor_faces
    for msg in actors.actors:
        nose_point = msg.nose_point
        actor_faces = {}
        if not np.isnan(nose_point.x):
            actor_faces[msg.tracking_id] = (nose_point.x, nose_point.y, 0)
    ImageCallback(data)


def set_actor_name_client(tracking_id, name):
    #rospy.wait_for_service('set_actor_name')
    try:
        set_actor_name = rospy.ServiceProxy('set_actor_name', SetActorName)
        resp1 = set_actor_name(tracking_id, name)
        return resp1.result
    except rospy.ServiceException, e:
        print "Service call failed: %s"%e



def ImageCallback(data):
    try:
        frame = bridge.imgmsg_to_cv2(data, "bgr8")

    except CvBridgeError as e:
        print(e)

    rgb_frame = frame[:, :, ::-1]
    
    face_encodings = []
    face_locations = []
    face_names = []
    faces = actor_faces.copy()
    for uid, (x, y, dist) in faces.iteritems():
        #if(dist < 6):
        x = int(x)
        y = int(y)
        face_img = rgb_frame[y - 50:y + 100, x - 100:x + 100]
        color = (0, 255, 0)
        locations_in_face_img = face_recognition.face_locations(face_img)
        visualize_img = np.array(face_img)
        for location in locations_in_face_img:
            cv2.circle(visualize_img, (location[1], location[0]), 3, color, 2)
            cv2.circle(visualize_img, (location[3], location[2]), 3, color, 2)
            cv2.putText(visualize_img, str(uid), (location[3], location[2]), cv2.FONT_HERSHEY_DUPLEX, 0.5, (255, 255, 255), 1)
            face_img_msg = bridge.cv2_to_imgmsg(visualize_img, encoding="passthrough")
            face_img_pub.publish(face_img_msg)

        for location in locations_in_face_img:
            face_locations.append((location[0] + y - 80, location[1] + x - 50,
                                    location[2] + y - 80, location[3] + x - 50))

        encodings_in_face_img = face_recognition.face_encodings(face_img, locations_in_face_img)

        for encoding in encodings_in_face_img:
            # See if the face is a match for the known face(s)
            matches = face_recognition.compare_faces(known_face_encodings, encoding, 0.5)
            name = "Unknown"

            # use the known face with the smallest distance to the new face
            face_distances = face_recognition.face_distance(known_face_encodings, encoding)
            best_match_index = np.argmin(face_distances)
            if matches[best_match_index]:
                name = known_face_names[best_match_index]
            set_actor_name_client(uid, name)
            face_names.append(str(uid) + ": " + name)
    
    # Display the results
    for (top, right, bottom, left), name in zip(face_locations, face_names):
        # Draw a box around the face
        cv2.rectangle(frame, (left, top), (right, bottom), (0, 0, 255), 2)

        # Draw a label with a uid below the face
        cv2.rectangle(frame, (left, bottom - 35), (right, bottom), (0, 0, 255), cv2.FILLED)
        font = cv2.FONT_HERSHEY_DUPLEX
        cv2.putText(frame, name, (left + 6, bottom - 6), font, 0.5, (255, 255, 255), 1)
        print(name)

    img_msg = bridge.cv2_to_imgmsg(frame, encoding="passthrough")
    face_pub.publish(img_msg)


def main(args):
  rospy.init_node('face_recognizer', anonymous=True)
#   image_sub = rospy.Subscriber("/nesfr3/" + robot_index + "/fisheye_camera/image_raw", Image, ImageCallback, queue_size=1)
#   actors_sub = rospy.Subscriber("/nesfr3/" + robot_index + "/Actors", Actors, ActorsCallback, queue_size=1)

  image_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/fisheye_camera/image_raw", Image)
  actors_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/Actors", Actors)
  ts = message_filters.ApproximateTimeSynchronizer([image_sub, actors_sub],10,0.1,allow_headerless=True)
  ts.registerCallback(ActorsCallback)

  try:
    rospy.spin()
  except KeyboardInterrupt:
    print("Shutting down")

if __name__ == '__main__':
    main(sys.argv)