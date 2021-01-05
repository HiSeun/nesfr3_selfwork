#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import sys
import os
import pickle

import math
import numpy as np
import argparse
import yaml
import cv2
from cv_bridge import CvBridge, CvBridgeError

import rospy
import tf
import message_filters

# Messages
from sensor_msgs.msg import Image, PointCloud2
import sensor_msgs.point_cloud2 as pc2
from geometry_msgs.msg import Point
from geometry_msgs.msg import PoseWithCovariance
from geometry_msgs.msg import PoseArray
from std_msgs.msg import Float64MultiArray
from tf2_msgs.msg import TFMessage
from visualization_msgs.msg import Marker
from people_msgs.msg import People
from std_msgs.msg import Int32
from cob_perception_msgs.msg import PointCloud2Array
from nesfr3_msgs.msg import Actors, Actor, PointWithConfidence
from nesfr3_msgs.msg import BoundingBoxes
from nesfr3_msgs.msg import PoseArrayWithBoxes
from nesfr3_msgs.msg import Actors, Actor, PointWithConfidence
from nesfr3_msgs.msg import Actor2d, Actors2d
from nesfr3_msgs.msg import PoseArrayWithClusters
from nesfr3_msgs.msg import BlobsArray

# Constant
PI = np.pi
nms_conf = 0.2
score_t = 0.15
pc_w = 1024
pc_h = 64
bridge = CvBridge() # ROS library that provides an interface between ROS and OpenCV
hist_list = None
hues = []
##Kalman
np.set_printoptions(formatter={'float_kind': lambda x: "{0:0.2f}".format(x)})
threshold = []
robot_index = "1"

past_prediction = {}
current_prediction = {}
current_detection = {}


# argument check
if len(sys.argv) == 4:
    robot_index = sys.argv[1]
else:
    print("There needs to be precisely one argument, the robot's index.")
    quit()


def onImage(data_bbox, data_cbox, data_cluster):
    # Synchronization Check
    if data_cbox.header.stamp != data_cluster.header.stamp :
        print("Header is different")
        return
    bbox = []

    for i in range(len(data_bbox.bounding_boxes)):
        bbox.append(data_bbox.bounding_boxes[i])

    bbox_spec = []  # (xmin, xmax, index)
    cbox_spec = []  # (xmin, xmax, index)

    # build cbox_spec
    for i, cbox in enumerate(data_cbox.bounding_boxes):
        cbox_spec.append((cbox.xmin, cbox.xmax, i))

    # build bbox_spec
    for i, box in enumerate(bbox):
        bbox_spec.append((box.xmin, box.xmax, i))

    # compare cluster_spec and bbox_spec, and build actors2d
    indexes = []
    for b_spec in bbox_spec:
        max_score = 0
        max_score_ind = -1

        for c_spec in cbox_spec:
            score = scoring(c_spec, b_spec)
            if max_score < score:
                max_score = score
                max_score_ind = c_spec[-1]
                # print("S: " + str(np.var(pc_bbox[clustering.labels_ == c_spec[-1]], axis=0)))
        # there is no cluster matched with bbox
        if max_score_ind == -1:
            continue

        # found matching cluster
        else:
            # for visualization
            indexes.append(max_score_ind)

    poses = PoseArrayWithBoxes()
    pose_with_cluster = PoseArrayWithClusters()
    for i, index in enumerate(indexes):
        poses.header = data_cbox.header
        pose_with_cluster.header = data_cbox.header
        poses.header.stamp = data_bbox.header.stamp
        pose_with_cluster.header.stamp = data_bbox.header.stamp
        poses.poses.append(data_cbox.poses[index])
        pose_with_cluster.poses.append(data_cbox.poses[index])
        poses.bounding_boxes.append(data_bbox.bounding_boxes[i])
        pose_with_cluster.segments.append(data_cluster.segments[index])

    cbox_pub.publish(poses)
    cluster_pub.publish(pose_with_cluster)


def people_callback(data_people, actors_pub):
    actors = Actors()
    actors.header.stamp = data_people.header.stamp
    actors.header.frame_id = "nesfr3/1/map"

    for i in range(len(data_people.people)):
        actor = Actor()
        actor.header.stamp = data_people.header.stamp
        actor.header.frame_id = "nesfr3/1/map"
        actor.tracking_id = int(data_people.people[i].name)
        actor.name = "actor_1"
        actor.pose.pose.position = data_people.people[i].position
        actor.pose.pose.position.z = 1

        roll = np.pi / 2
        pitch = 0

        yaw = np.arctan2(
            data_people.people[i].velocity.x, -data_people.people[i].velocity.y
        )

        if yaw > np.pi:
            yaw = yaw - 2 * np.pi

        human_quaternion = tf.transformations.quaternion_from_euler(roll, pitch, yaw)

        actor.pose.pose.orientation.x = human_quaternion[0]
        actor.pose.pose.orientation.y = human_quaternion[1]
        actor.pose.pose.orientation.z = human_quaternion[2]
        actor.pose.pose.orientation.w = human_quaternion[3]

        actors.actors.append(actor)

    actors_pub.publish(actors)

def load_trimg(folder):
    images = []
    global hues
    for filename in os.listdir(folder):
        img = cv2.imread(os.path.join(folder,filename))
        if img is not None:
            imghue1 = cv2.calcHist([img],[0],None,[256],[0,256])
            #images.append(img)
            cv2.normalize(imghue1, imghue1, 0, 180, cv2.NORM_MINMAX)
            hues.append(imghue1)
    hues = np.array(hues)
    print(hues.shape[0])
    return hues
##kalman
def callback(posearray_data, posearraywithboxes_data):

    global past_prediction
    global current_prediction
    global current_detection

    if posearray_data == None:
        print('no data subscribed')
        return 1

    if past_prediction == {} and current_prediction == {}:
        for i in range(len(posearray_data.poses)):
            current_prediction[i] = [posearray_data.poses[i].position.x, posearray_data.poses[i].position.y]
    else: 
        past_prediction = current_prediction
        for i in range(len(posearray_data.poses)):
            current_prediction[i] = [posearray_data.poses[i].position.x, posearray_data.poses[i].position.y]#not append, make new array
            #todo : if the element of array c is null, does not copy it

    if posearraywithboxes_data == None:
        print('no data subscribed')
        return 1
        # i isn't identical to the actor id
    for i in range(len(posearraywithboxes_data.poses)):
        current_detection[i] = [posearraywithboxes_data.poses[i].position.x, posearraywithboxes_data.poses[i].position.y]#not append, make new array

    if past_prediction != {}: # getting kalman score is only enabled after first prediction finished
        score_array = calc_kalman_score(past_prediction, current_detection)

        kalman_pub.publish(score_array)

def calc_kalman_score(past_prediction, current_detection):

    score_array = Float64MultiArray()
    size = len(past_prediction)
    score_array.data = np.zeros(size)
    print(size)

    for i in range(len(past_prediction)):
        for j in range(len(current_detection)):
            distance = np.sqrt(np.square(current_detection[j][0]-past_prediction[i][0])+np.square(current_detection[j][1]-past_prediction[i][1]))
            #score = score_function(distance)

            # score_array.data[i, j] = score
            # print(str(i) + ", " + str(j) + ", " + str(score_array.data[i]))
            

    return score_array

def score_function(euclidean_distance):
    global threshold
    score = 1/(np.cosh(euclidean_distance))
    if score > 0.7 :
        threshold = threshold_
        threshold.append(threshold_)
    return score
## Find cluster_id!!!!!!
# def hist_callback(data_img, data_hist, data_state, data_id):
def hist_callback(data_img, data_hist):
    print("This is where the error occurs!")
    global bridge
    global hist_list
    global hues
    global threshold

    w = 1200
    h = 300
    
    box_image = []
    hist_hue = []
    box_image_resize = []
    hsv_images = []
    hist_xs = []
    Actor_y = True
    print("This is where the error occurs7")
    image = bridge.imgmsg_to_cv2(data_img) # Converting ROS image messages to OpenCV images
    for i, tracking_id in enumerate(data_hist.tracking_id):
        print("tracking_id : %d"%tracking_id)
        #print("tracking_id : %d"%tracking_id)
        # if tracking_id == data_id.data:
        blob_xmin = min(data_hist.blobsArray[i].blobs, key=lambda blob: blob.x)
        blob_xmax = max(data_hist.blobsArray[i].blobs, key=lambda blob: blob.x)
        blob_ymin = min(data_hist.blobsArray[i].blobs, key=lambda blob: blob.y)
        blob_ymax = max(data_hist.blobsArray[i].blobs, key=lambda blob: blob.y)

        box_xmin = blob_xmin.x - int(blob_xmin.width / 2)
        box_xmax = blob_xmax.x - int(blob_xmax.width / 2) + blob_xmax.width - 1
        box_ymin = blob_ymin.y - int(blob_ymin.height / 2)
        box_ymax = blob_ymax.y + int(blob_ymax.height / 2) + blob_ymax.height - 1

        box_image = image[box_ymin : box_ymax, box_xmin : box_xmax]
        blob_filter = np.zeros((300, 1200, 1), np.uint8)
        blob_filter = blob_filter[box_ymin : box_ymax, box_xmin : box_xmax]

        for blob in data_hist.blobsArray[i].blobs :
            start_point = (blob.x - int(blob.width / 2) - box_xmin, blob.y - int(blob.height / 2)- box_ymin)
            end_point = (start_point[0] + blob.width - 1, start_point[1] + blob.height - 1)
            cv2.rectangle(blob_filter, start_point, end_point, 255, -1)

        pub_im = bridge.cv2_to_imgmsg(box_image, "passthrough")
        image_pub.publish(pub_im)

        hsv_image = cv2.cvtColor(box_image, cv2.COLOR_BGR2HSV)
        hsv_images.append(hsv_image)
        
        hist_y = 370 ## you can change it to whatever value.
        hist_x = 180
        hmap = np.zeros((hist_y, hist_x), np.uint8)
        hist_hue.append(cv2.calcHist([hsv_image],[0],blob_filter,[256],[0,256]))
        hist = cv2.calcHist([hsv_image], [0, 1], blob_filter, [180, 256], [0, 180, 0, 256])
        hist_xs.append(np.int32(np.around(hist_y / box_image.shape[0] * box_image.shape[1])))
        box_image_resize.append(cv2.resize(hsv_image, (hist_x, hist_y)))

         ########
        if np.sum(hist) == 0:
            continue
        hist = hist / np.sum(hist) * 5000

        if hist_list is not None:
            if len(hist_list) < 10:
                hist_list.append(hist)
            else:
                hist_list.pop(0)
                hist_list.append(hist)
        else:
            hist_list = [hist]
        h_image = np.zeros((hist_y,1), np.uint8)

    for j in range(len(hsv_images)) :
        cv2.normalize(hist_hue[j], hist_hue[j], 0, 180, cv2.NORM_MINMAX)

        chk = 0
        result1 = 0
        result2 = 0
        result3 = 0
        result4 = 0
        
        for hue_ in hues :
            result1 = result1 + cv2.compareHist(hist_hue[j], hue_, cv2.HISTCMP_CORREL)
            result2 = result2 + cv2.compareHist(hist_hue[j], hue_, cv2.HISTCMP_CHISQR)
            result3 = result3 + cv2.compareHist(hist_hue[j], hue_, cv2.HISTCMP_INTERSECT)
            result4 = result4 + cv2.compareHist(hist_hue[j], hue_, cv2.HISTCMP_BHATTACHARYYA)

        result1 = result1/hues.shape[0]
        result2 = result2/hues.shape[0]
        result3 = result3/hues.shape[0]    
        result4 = result4/hues.shape[0] 
        
        if result1 > 0.99 : 
            chk = chk + 1
        if result2 < 60 :
            chk = chk + 1
        if result3 > 200 : 
            chk = chk + 1
        if result4 < 0.25 :
            chk = chk + 1

        if (len(hist_hue) == 1) :
            if chk == 4 :
                results.append(result1*0.25 + result2 *-0.5 + result3 * 0.25 + result4 *-0.5)
                print("A taken photo is an actor1")
            else :
                Actor_y = False
                print("A taken photo is not actor1")
        else : 
            results.append(result1*0.25 + result2 *-0.5 + result3 * 0.25 + result4 *-0.5)
            print("Taken photo includes actor1")
        
    if Actor_y :
        actorID = [2 for x in range(len(box_image_resize))]
        pose_score = []
        [tracking_id, estID] = hist_actor(data_hist.tracking_id, results, actorID)
        pose_score = kalman_score(tracking_id, estID)
        [tracking_id, finalID] = hist_actor(data_hist.tracking_id, results, estID, pose_score)

        for j in range(len(finalID)) : 
            # To maintain the size of box_image in the Windowdisplay.
            position = (int(hist_xs[j]/5) , 10)
            cv2.putText(
                 box_image_resize[j], "Actor_"+str(finalID[j]), position, cv2.FONT_HERSHEY_SIMPLEX, 0.5, (209, 80, 0, 255), 2) #font stroke
            path = "/mnt/catkin_ws/src/TestResults2/"
            if finalID[j] == 1 :
                cv2.imwrite(os.path.join(path+"/actor1", str(data_hist.header.seq)+".png"), box_image_resize[j])
            else : 
                cv2.imwrite(os.path.join(path+"/actor2", str(data_hist.header.seq)+".png"), box_image_resize[j])
            #h_image = np.concatenate((box_image_resize[:, :,0], histy), axis = 1)
            # h_image = box_image
            h_image = np.concatenate((box_image_resize[j][:,:,2], h_image), axis = 1)    
            cv2.imwrite(os.path.join(path, str(data_hist.header.seq)+".png"), h_image)

            cv2.startWindowThread()
            cv2.namedWindow("hist 1D")  
            cv2.imshow("hist 1D", h_image)
            
            cv2.waitKey(10) 
            print("This is where the error occurs4")

    cv2.destroyAllWindows()

def hist_actor(tracking_id, results, actorID, pose_score)
    results_ = []
    if pose_score.isempty() :
        results_ = results
        print("First estimation")
        corr = results_.index(max(results_))
        actorID[corr] = 1
    else : 
        print("Final esitmation")
        if len(results) == 1 : 
            if pose_score[0] < 0.8 :
                actorID[0] = 2
            else : 
                actorID[0] = 1
        else : 
            for j in range(len(results)) :
                results_ = pose_score[j] * AA; + results[j] * (1-AA)
            corr = results_.index(max(results_))
            actorID[corr] = 1

    return [tracking_id, actorID]

def state_callback(data_img, data_hist, data_state):

    global bridge
    global hist_list
    

    w = 1200
    h = 300

    # cv2.namedWindow('colorhist', cv2.CV_WINDOW_AUTOSIZE)


    if data_state.data == 0 and hist_list is not None:
        image = bridge.imgmsg_to_cv2(data_img)
        max_score = 0
        max_index = -1
        for i, tracking_id in enumerate(data_hist.tracking_id):
            blob_xmin = min(data_hist.blobsArray[i].blobs, key=lambda blob: blob.x)
            blob_xmax = max(data_hist.blobsArray[i].blobs, key=lambda blob: blob.x)
            blob_ymin = min(data_hist.blobsArray[i].blobs, key=lambda blob: blob.y)
            blob_ymax = max(data_hist.blobsArray[i].blobs, key=lambda blob: blob.y)

            box_xmin = blob_xmin.x - int(blob_xmin.width / 2)
            box_xmax = blob_xmax.x - int(blob_xmax.width / 2) + blob_xmax.width - 1
            box_ymin = blob_ymin.y - int(blob_ymin.height / 2)
            box_ymax = blob_ymax.y + int(blob_ymax.height / 2) + blob_ymax.height - 1

            box_image = image[box_ymin : box_ymax, box_xmin : box_xmax]

            blob_filter = np.zeros((300, 1200, 1), np.uint8)
            blob_filter = blob_filter[box_ymin : box_ymax, box_xmin : box_xmax]
            
            for blob in data_hist.blobsArray[i].blobs :
                start_point = (blob.x - int(blob.width / 2) - box_xmin, blob.y - int(blob.height / 2)- box_ymin)
                end_point = (start_point[0] + blob.width - 1, start_point[1] + blob.height - 1)
                cv2.rectangle(blob_filter, start_point, end_point, 255, -1)

            hsv_image = cv2.cvtColor(box_image, cv2.COLOR_BGR2HSV)

            hist = cv2.calcHist(
                [hsv_image], [0, 1], blob_filter, [180, 256], [0, 180, 0, 256]
            )
            
            hist = hist / np.sum(hist) * 5000
            ###
            # !!!!!!!!!!!!!!!!!!!!!!!! caculate 1D histogram (Hue)

            
            #### 
            score = 0
            for hd in hist_list:
                minima = np.minimum(hd, hist)
                intersection = np.true_divide(np.sum(minima), np.sum(hist))
                if intersection > score:
                    score = intersection
            if score > max_score:
                max_score = score
                max_index = i

        print("The max_score is %.4f"%max_score)
        if max_score > 0.75:
            new_id = Int32()
            new_id.data = int(data_hist.tracking_id[max_index])
            new_id_pub.publish(new_id)

# def onPoints(actors):
#     with open('actors_' + str(points.header.seq), 'wb') as fp:
#         pickle.dump(actors, fp, pickle.HIGHEST_PROTOCOL)

#     with open('points_' + str(points.header.seq), 'rb') as fr:
#         data = pickle.load(fr)
#     print(os.getcwd())


# compare bbox_spec and cbox_spec then return score
def scoring(cluster_spec, bbox_spec):
    # calculation iou score (Intersection over Union)
    w = 1200

    if cluster_spec[0] > cluster_spec[1] and bbox_spec[0] > bbox_spec[1]:
        x_min_start = min(cluster_spec[0] - w, bbox_spec[0] - w)
        x_max_start = max(cluster_spec[0] - w, bbox_spec[0] - w)
        x_min_end = min(cluster_spec[1], bbox_spec[1])
        x_max_end = max(cluster_spec[1], bbox_spec[1])
    elif cluster_spec[0] > cluster_spec[1] and bbox_spec[0] < bbox_spec[1]:
        if bbox_spec[0] - 0 < w - bbox_spec[1]:
            x_min_start = min(cluster_spec[0] - w, bbox_spec[0])
            x_max_start = max(cluster_spec[0] - w, bbox_spec[0])
            x_min_end = min(cluster_spec[1], bbox_spec[1])
            x_max_end = max(cluster_spec[1], bbox_spec[1])
        else:
            x_min_start = min(cluster_spec[0], bbox_spec[0])
            x_max_start = max(cluster_spec[0], bbox_spec[0])
            x_min_end = min(cluster_spec[1] + w, bbox_spec[1])
            x_max_end = max(cluster_spec[1] + w, bbox_spec[1])
    elif cluster_spec[0] < cluster_spec[1] and bbox_spec[0] > bbox_spec[1]:
        if cluster_spec[0] - 0 < w - cluster_spec[1]:
            x_min_start = min(cluster_spec[0], bbox_spec[0] - w)
            x_max_start = max(cluster_spec[0], bbox_spec[0] - w)
            x_min_end = min(cluster_spec[1], bbox_spec[1])
            x_max_end = max(cluster_spec[1], bbox_spec[1])
        else:
            x_min_start = min(cluster_spec[0], bbox_spec[0])
            x_max_start = max(cluster_spec[0], bbox_spec[0])
            x_min_end = min(cluster_spec[1], bbox_spec[1] + w)
            x_max_end = max(cluster_spec[1], bbox_spec[1] + w)
    else:
        x_min_start = min(cluster_spec[0], bbox_spec[0])
        x_max_start = max(cluster_spec[0], bbox_spec[0])
        x_min_end = min(cluster_spec[1], bbox_spec[1])
        x_max_end = max(cluster_spec[1], bbox_spec[1])

    x_score = (
        1.0 
        if (x_max_end - x_min_start) == 0
        else (x_min_end - x_max_start) / (x_max_end - x_min_start)
    )

    return x_score

###############################################################################################################################


if __name__ == "__main__":
    rospy.init_node("human_matching")

    # Result Publishers
    actors_pub = rospy.Publisher("/nesfr3/" + robot_index + "/Actors", Actors, queue_size=1) # tracking id information only.
    cbox_pub = rospy.Publisher("/nesfr3/" + robot_index + "/Actors_poses", PoseArrayWithBoxes, queue_size=1) # bounding box under 11 (in scoring, append if cbox, bbox matched only)
    new_id_pub = rospy.Publisher("/nesfr3/" + robot_index + "/new_id", Int32, queue_size=1) # no pub
    image_pub = rospy.Publisher("/nesfr3/" + robot_index + "/tracking_image", Image, queue_size=1)
    cluster_pub = rospy.Publisher("/nesfr3/" + robot_index + "/pose_with_cluster", PoseArrayWithClusters, queue_size=1)
    #kalman
    kalman_pub = rospy.Publisher("/nesfr3/" + robot_index + "/kalman_score", Float64MultiArray, queue_size=1)
    
    # Data Subscribers
    image_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/fisheye_camera/image_raw", Image)
    bbox_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/bounding_boxes", BoundingBoxes)
    cbox_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/object3d_detector/poses", PoseArrayWithBoxes)
    people_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/people_tracker/people", People)
    hist_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/histogram", BlobsArray) # actor id.
    state_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/state", Int32) # no pub/sub
    id_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/id", Int32)# no pub/sub
    cluster_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/cluster", PointCloud2Array) # no pub
    points_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/lidar/points", PointCloud2)
    #kalman 
    prediction_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/people_tracker/pose_array", PoseArray)

    
    # Synchronize Topics
    ts1 = message_filters.ApproximateTimeSynchronizer([bbox_sub, cbox_sub, cluster_sub], 30, 0.1, allow_headerless=True)
    ts1.registerCallback(onImage)

    ts2 = message_filters.ApproximateTimeSynchronizer([people_sub], 1, 1.0, allow_headerless=True)
    ts2.registerCallback(people_callback, actors_pub)

    # ts3 = message_filters.ApproximateTimeSynchronizer([image_sub, hist_sub, state_sub, id_sub], 1, 0.1, allow_headerless=True)
    ts3 = message_filters.ApproximateTimeSynchronizer([image_sub, hist_sub], 1, 0.1, allow_headerless=True)
    ts3.registerCallback(hist_callback)

    # ts4 = message_filters.ApproximateTimeSynchronizer([image_sub, hist_sub, state_sub], 1, 1.0, allow_headerless=True)
    # ts4.registerCallback(state_callback)

    # ts = message_filters.ApproximateTimeSynchronizer([prediction_sub, cbox_sub], 1, 0.1, allow_headerless=True)
    # ts.registerCallback(callback)

    load_trimg("/mnt/catkin_ws/src/actor/actor1")
    rospy.spin()
