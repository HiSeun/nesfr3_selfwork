#!/usr/bin/env python

from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import numpy as np
import rospy
import time
import torch
import torchvision

if not torch.cuda.is_available():
    ROS_WARN("TRT_POSE: CUDA NOT AVAILABLE")
    exit(-1)

import cv2
import message_filters
from cv_bridge import CvBridge, CvBridgeError
from sensor_msgs.msg import Image
from nesfr3_msgs.msg import Actors, Actor, PointWithConfidence
from nesfr3_msgs.msg import Actor2d, Actors2d
from nesfr3_msgs.msg import BoundingBoxes

import os
import sys
import json
import trt_pose.coco
dirname = os.path.dirname(__file__)

if len(sys.argv) == 4:
    robot_index = sys.argv[1]
else:
    print("There needs to be precisely one argument, the robot's index.")
    quit()

global topology
global parse_objects
global num_parts
global num_links
with open(os.path.join(dirname, '../cfg/human_pose.json'), 'r') as f:
    human_pose = json.load(f)

num_parts = len(human_pose['keypoints'])
num_links = len(human_pose['skeleton'])
topology = trt_pose.coco.coco_category_to_topology(human_pose)

# Initialize optimized model
import torch2trt
import trt_pose.models
MODEL_WEIGHTS = os.path.join(dirname, '../cfg/resnet18_baseline_att_224x224_A_epoch_249.pth')
OPTIMIZED_WEIGHTS = os.path.join(dirname, '../cfg/resnet18_baseline_att_224x224_A_epoch_249_trt.pth')

model_trt = torch2trt.TRTModule()
if os.path.isfile(OPTIMIZED_WEIGHTS):
    print("LOADING OPTIMIZED WEIGHTS DIRECTLY...")
    model_trt.load_state_dict(torch.load(OPTIMIZED_WEIGHTS))
else:
    print("GENERATING OPTIMIZED WEIGHTS FOR FURTHER USE...")
    model = trt_pose.models.resnet18_baseline_att(num_parts, 2 * num_links).cuda().eval()
    model.load_state_dict(torch.load(MODEL_WEIGHTS))
    data = torch.zeros((1, 3, 224, 224)).cuda()
    model_trt = torch2trt.torch2trt(model, [data], fp16_mode=True, max_workspace_size=1<<25)
    torch.save(model_trt.state_dict(), OPTIMIZED_WEIGHTS)

mean = torch.Tensor([0.485, 0.456, 0.406]).cuda()
std = torch.Tensor([0.229, 0.224, 0.225]).cuda()
device = torch.device('cuda')
def preprocess(image):
    global device
    device = torch.device('cuda')
    image = torchvision.transforms.functional.to_tensor(image).to(device)
    image.sub_(mean[:, None, None]).div_(std[:, None, None])
    return image[None, ...]

import PIL
from trt_pose.parse_objects import ParseObjects
def get_points(actor2d, object_counts, objects, normalized_peaks, box):
    global topology
    if box.xmin > box.xmax :
        xmin = box.xmin - 4400
    else :
        xmin = box.xmin
    height = box.ymax - box.ymin
    width = box.xmax - xmin

    count = int(object_counts[0])
    K = topology.shape[0]
    for i in range(count):
        color = (0, 255, 0)
        obj = objects[0][i]
        C = obj.shape[0]
        for j in range(C):
            k = int(obj[j])
            #if k >= 0:
            peak = normalized_peaks[0][j][k]
            if int(float(peak[1]) * width + xmin) >= 0 :
                actor2d.points[j].x = int(float(peak[1]) * width + xmin)
            else :
                actor2d.points[j].x = int(float(peak[1]) * width + xmin) + 4400
            actor2d.points[j].y = int(float(peak[0]) * height + box.ymin)
            #else:
            #    actor2d.points[j].x = np.NaN
            #    actor2d.points[j].y = np.NaN

def draw_objects(image, object_counts, objects, normalized_peaks, box):
    global topology
    if box.xmin > box.xmax :
        xmin = box.xmin - 4400
    else :
        xmin = box.xmin
    height = box.ymax - box.ymin
    width = box.xmax - xmin

    # number of points we found for person 0
    count = int(object_counts[0])
    # number of skeletons?
    K = topology.shape[0]
    for i in range(count):
        color = (0, 255, 0)
        obj = objects[0][i]
        C = obj.shape[0]
        for j in range(C):
            k = int(obj[j])
            if k >= 0:
                peak = normalized_peaks[0][j][k]
                if int(float(peak[1]) * width + xmin) >= 0 :
                    x = int(float(peak[1]) * width + xmin)
                else :
                    x = int(float(peak[1]) * width + xmin) + 4400
                y = int(float(peak[0]) * height + box.ymin)
                cv2.circle(image, (x, y), 3, color, 2)

        for k in range(K):
            c_a = topology[k][2]
            c_b = topology[k][3]
            if obj[c_a] >= 0 and obj[c_b] >= 0:
                peak0 = normalized_peaks[0][c_a][obj[c_a]]
                peak1 = normalized_peaks[0][c_b][obj[c_b]]
                if int(float(peak0[1]) * width + xmin) >= 0 :
                    x0 = int(float(peak0[1]) * width + xmin)
                else :
                    x0 = int(float(peak0[1]) * width + xmin) + 4400
                y0 = int(float(peak0[0]) * height + box.ymin)
                if int(float(peak1[1]) * width + xmin) >= 0 :
                    x1 = int(float(peak1[1]) * width + xmin)
                else :
                    x1 = int(float(peak1[1]) * width + xmin) + 4400
                y1 = int(float(peak1[0]) * height + box.ymin)
                if box.xmin <= box.xmax :
                    cv2.line(image, (x0, y0), (x1, y1), color, 2)

def onImage(data_img, data_bbox, img_pub, actors2d_pub):
  global prectime
  global proctime
  global posttime
  global num_callback

  global model_trt

  precstart = time.time()
  bridge = CvBridge()
  cv_image = bridge.imgmsg_to_cv2(data_img,"passthrough")
  w = cv_image.shape[1]
  h = cv_image.shape[0]

  # make batch images from bounding boxes
  bbox = data_bbox.bounding_boxes

  # Max batch size of this model is 1, so we have to feed the image 1 by 1
  images = []
  for box in bbox:
    if box.xmin > box.xmax :
        image = np.concatenate((cv_image[box.ymin:box.ymax, box.xmin:4400, :], cv_image[box.ymin:box.ymax, 0:box.xmax, :]), axis=1)
    else:
        image = cv_image[box.ymin:box.ymax, box.xmin:box.xmax, :]
    image = cv2.resize(image,(224,224),interpolation=cv2.INTER_AREA)
    image = preprocess(image)
    images.append(image)

  prectime += 0 if len(bbox)==0 else (time.time() - precstart) / len(bbox)
  outputs = []
  procstart = time.time()
  for image in images:
    outputs.append(model_trt(image))
  prectime += 0 if len(bbox)==0 else (time.time() - precstart) / len(bbox)


  actors2d = Actors2d()
  actors2d.header.stamp = data_bbox.header.stamp
  # actors2d.header.frame_id = "velodyne"
  actors2d.header.frame_id = "os1_sensor"
  poststart = time.time()
  for (cmap, paf), box in zip(outputs, bbox):
    actor2d = Actor2d()
    cmap, paf = cmap.detach().cpu(), paf.detach().cpu()
    counts, objects, peaks = parse_objects(cmap, paf)
    get_points(actor2d, counts, objects, peaks, box)
    draw_objects(cv_image, counts, objects, peaks, box)
    actors2d.actors2d.append(actor2d)


  img_msg = bridge.cv2_to_imgmsg(cv_image,"passthrough")
  posttime += 0 if len(bbox)==0 else (time.time() - poststart) / len(bbox)
  actors2d_pub.publish(actors2d)
  img_pub.publish(img_msg)



  num_callback += 1
  print("Avg Inf time: {}".format(proctime / num_callback))
  print("Avg Pre time: {}".format(prectime / num_callback))
  print("Avg Post time: {}".format(posttime / num_callback))
  print("blen: {}".format(len(bbox)))

if __name__ == '__main__':
  rospy.init_node("human_detection")

  global prectime
  global proctime
  global num_callback

  parse_objects = ParseObjects(topology)
  num_callback = 0
  prectime = time.time() - time.time()
  proctime = time.time() - time.time()
  posttime = time.time() - time.time()
  img_pub = rospy.Publisher("/nesfr3/" + robot_index + "/fisheye_camera/pose_image",Image,queue_size=1)
  actors2d_pub = rospy.Publisher("/nesfr3/1/Actors2d", Actors2d, queue_size=1)

  img_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/fisheye_camera/image_raw",Image)
  bbox_sub = message_filters.Subscriber("/nesfr3/" + robot_index + "/bounding_boxes",BoundingBoxes)
  ts = message_filters.ApproximateTimeSynchronizer([img_sub, bbox_sub], 10, 0.1,allow_headerless=True)
  ts.registerCallback(onImage,img_pub,actors2d_pub)

  rospy.spin()
