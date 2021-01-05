#!/usr/bin/env python2
"""trt_async_ros.py

Creates node subscribing raw img data/publish inference results. It creates
1 dedicated child thread for fetching camera input and do inferencing
with the TensorRT optimized SSD model/engine, while using the main
thread for drawing detection results and displaying video.  Ideally,
the 2 threads work in a pipeline fashion so overall throughput (FPS)
would be improved comparing to the non-async version.
"""
# from hanging_threads import start_monitoring
# monitoring_thread = start_monitoring()

import sys
import time
import argparse
import threading
import cv2
import pycuda.driver as cuda
import numpy as np
from utils.camera import add_camera_args, Camera

# SSD
from utils.ssd import TrtSSD
from utils.ssd_classes import get_cls_dict_ssd

# YOLO
from utils.yolo import TrtYOLO
from utils.yolo_classes import get_cls_dict_yolo

# from utils.camera import add_camera_args, Camera
from utils.display import open_window, set_display, show_fps
from utils.visualization import BBoxVisualization

from nesfr3_msgs.msg import BoundingBox
from nesfr3_msgs.msg import BoundingBoxes

import roslib

roslib.load_manifest("nesfr3_human_detection")
import rospy
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import Queue

INPUT_HW_SSD = (300, 300)
INPUT_HW_YOLO = (288, 288)

nms_conf = 0.2

SUPPORTED_MODELS = [
    "ssd_mobilenet_v1_coco",
    "ssd_inception_v2_coco",
    "yolov3-288",
    "yolov4-288",
]

SUPPORTED_ENGINES = ["GeforceGTX1080Ti", "GeforceRTX2080Ti", "Xavier"]

# These global variables are 'shared' between the main and child
# threads.  The child thread writes new frame and detection result
# into these variables, while the main thread reads from them.
s_img, s_boxes, s_confs, s_clss = None, None, None, None
# queue used for sending frames from main to child thread
img_raw_queue = Queue.Queue(maxsize=100)


def parse_args():
    """Parse input arguments."""
    desc = (
        "Capture and display live camera video, while doing "
        "real-time object detection with TensorRT optimized "
        "SSD model"
    )

    parser = argparse.ArgumentParser(description=desc)
    parser = add_camera_args(parser)

    parser.add_argument(
        "--model", 
        type=str, 
        default="ssd_mobilenet_v1_coco", 
        choices=SUPPORTED_MODELS
    )
    parser.add_argument(
        "--device", 
        type=str, 
        default="Xavier", 
        choices=SUPPORTED_ENGINES
    )
    parser.add_argument(
        "--batch_size", 
        type=int, 
        default=1
    )
    parser.add_argument(
        "--verbose", 
        type=str, 
        default="False", 
        choices=["True", "False"]
    )
    parser.add_argument(
      "--robot_id",
      type=str, 
      default="1"
    )

    args, _ = parser.parse_known_args()

    # unknown filled with ROS params
    return args


class TrtThread(threading.Thread):
    """TrtThread

    This implements the child thread which continues to read images
    from cam (input) and to do TRT engine inferencing.  The child
    thread stores the input image and detection results into global
    variables and uses a condition varaiable to inform main thread.
    In other words, the TrtThread acts as the producer while the
    main thread is the consumer.
    """

    def __init__(self, condition, model, device, batch_size, verbose, conf_th):
        """__init__

        # Arguments
            condition: the condition variable used to notify main
                       thread about new frame and detection result
            model: a string, specifying the TRT SSD model
            device: name of the GPU device
            batch_size: batch_size of the model; must be 8
            verbose: if true, it prints messages for debugging
            conf_th: confidence threshold for detection
        """
        threading.Thread.__init__(self)
        self.daemon = True
        self.condition = condition
        self.model = model
        self.device = device
        self.batch_size = batch_size
        self.verbose = verbose
        self.conf_th = conf_th
        self.cuda_ctx = None  # to be created when run
        self.trt_model = None  # to be created when run
        self.running = False

    def run(self):
        """Run until 'running' flag is set to False by main thread.

        NOTE: CUDA context is created here, i.e. inside the thread
        which calls CUDA kernels.  In other words, creating CUDA
        context in __init__() doesn't work.
        """
        global s_img, s_boxes, s_confs, s_clss

        print("TrtThread: loading the TRT SSD engine...")
        self.cuda_ctx = cuda.Device(0).make_context()

        if 'ssd' in self.model:
            self.trt_model = TrtSSD(
                self.model, 
                self.device, 
                self.batch_size, 
                self.verbose, 
                INPUT_HW_SSD
            )

        elif 'yolo' in self.model:
            self.trt_model = TrtYOLO(
                self.model, 
                self.device, 
                self.batch_size, 
                self.verbose, 
                INPUT_HW_YOLO
            )

        print("TrtThread: start")

        self.running = True
        while self.running:
            try:
                img_raw = img_raw_queue.get(block=False)
                img = img_raw
                boxes, confs, clss = self.trt_model.detect(img, self.conf_th)
                with self.condition:
                    s_img, s_boxes, s_confs, s_clss = img, boxes, confs, clss
                    self.condition.notify()
            except Exception as _:
                with self.condition:
                    self.condition.notify()

    def stop(self):
        del self.trt_model
        del self.cuda_ctx
        self.running = False
        print("TrtThread: stop")


class image_converter:
    def __init__(self):
        self.args = parse_args()

        self.robot_index = self.args.robot_id
        self.model = self.args.model
        self.device = self.args.device
        self.batch_size = self.args.batch_size
        self.verbose = self.args.verbose == "True"

        # CVbridge for image publisher
        self.bridge = CvBridge()

        self.image_pub = rospy.Publisher(
            "/nesfr3/" + self.robot_index + "/fisheye_camera/detection_image", 
            Image
        )
        self.bbox_pub = rospy.Publisher(
            "/nesfr3/" + self.robot_index + "/bounding_boxes",
            BoundingBoxes,
            queue_size=1,
        )
        self.image_sub = rospy.Subscriber(
            "/nesfr3/" + self.robot_index + "/fisheye_camera/image_raw",
            Image,
            self.callback,
        )

        # Load Classes Dictionary
        if 'ssd' in self.model:
            self.cls_dict = get_cls_dict_ssd(self.args.model.split("_")[-1])
        elif 'yolo' in self.model:
            self.cls_dict = get_cls_dict_yolo("coco")

        # Init pycuda driver
        cuda.init()

        self.vis = BBoxVisualization(self.cls_dict)
        self.condition = threading.Condition()
        self.trt_thread = TrtThread(
            self.condition,
            self.model,
            self.device,
            self.batch_size,
            self.verbose,
            conf_th=0.3,
        )
        self.trt_thread.start()
        self.tic = time.time()
        self.fps = 0.0

    def callback(self, data):
        header = data.header

        try:
            cv_image = self.bridge.imgmsg_to_cv2(data, "rgb8")
        except CvBridgeError as e:
            print(e)

        for _ in range(1):
            img_raw_queue.put(cv_image)

            global s_img, s_boxes, s_confs, s_clss
            with self.condition:
                # Wait for the next frame and detection result.  When
                # getting the signal from the child thread, save the
                # references to the frame and detection result for
                # display.
                self.condition.wait()
                img, boxes, confs, clss = s_img, s_boxes, s_confs, s_clss

            boxes_msg = BoundingBoxes()
            boxes_msg.header.stamp = data.header.stamp
            boxes_msg.image_header = data.header
            bboxes = []

            # Construct bboxes
            for conf, box, cl in zip(confs, boxes, clss):
                if 'ssd' in self.model:
                    human_index = 1
                elif 'yolo' in self.model:
                    human_index = 0
                else:
                    return

                if cl == human_index:
                    box_msg = BoundingBox()
                    box_msg.xmin = box[0]
                    box_msg.xmax = box[2]
                    box_msg.ymin = box[1]
                    box_msg.ymax = box[3]
                    box_msg.score = conf
                    bboxes.append(box_msg)

            # Remove duplicate bounding boxes in bboxes
            duplicate_box_removal(bboxes)

            # Publish bounding boxes message
            boxes_msg.bounding_boxes = bboxes
            self.bbox_pub.publish(boxes_msg)

            # calculate an exponentially decaying average of fps number
            toc = time.time()
            curr_fps = 1.0 / (toc - self.tic)
            self.fps = (
                curr_fps if self.fps == 0.0 else (self.fps * 0.95 + curr_fps * 0.05)
            )
            self.tic = toc

            # Publish bounding boxes image when verbose is set to true
            if self.verbose:
                result_img = self.vis.draw_bboxes(img, bboxes, cl)
                result_img = show_fps(result_img, self.fps)
                image = self.bridge.cv2_to_imgmsg(result_img, "rgb8")
                image.header = header
                try:
                    self.image_pub.publish(image)
                except CvBridgeError as e:
                    print(e)


# returns the IoU of two bbox
def bbox_iou(box1, box2):
    w = 1200
    # Get the coordinates of bounding boxes
    if box1.xmin > box1.xmax:
        b1_x1, b1_y1, b1_x2, b1_y2 = box1.xmin - w, box1.ymin, box1.xmax, box1.ymax
    else:
        b1_x1, b1_y1, b1_x2, b1_y2 = box1.xmin, box1.ymin, box1.xmax, box1.ymax

    if box2.xmin > box2.xmax:
        b2_x1, b2_y1, b2_x2, b2_y2 = box2.xmin - w, box2.ymin, box2.xmax, box2.ymax
    else:
        b2_x1, b2_y1, b2_x2, b2_y2 = box2.xmin, box2.ymin, box2.xmax, box2.ymax

    # get the corrdinates of the intersection rectangle
    if box1.xmin > box1.xmax and box2.xmin < box2.xmax:
        iou1 = calculate_iou(b1_x1, b1_y1, b1_x2, b1_y2, b2_x1, b2_y1, b2_x2, b2_y2)
        iou2 = calculate_iou(b1_x1 + w, b1_y1, b1_x2 + w, b1_y2, b2_x1, b2_y1, b2_x2, b2_y2)
        iou = max(iou1, iou2)
    elif box1.xmin < box1.xmax and box2.xmin > box2.xmax:
        iou1 = calculate_iou(b1_x1, b1_y1, b1_x2, b1_y2, b2_x1, b2_y1, b2_x2, b2_y2)
        iou2 = calculate_iou(b1_x1, b1_y1, b1_x2, b1_y2, b2_x1 + w, b2_y1, b2_x2 + w, b2_y2)
        iou = max(iou1, iou2)
    else:
        iou = calculate_iou(b1_x1, b1_y1, b1_x2, b1_y2, b2_x1, b2_y1, b2_x2, b2_y2)

    return iou


def calculate_iou(b1_x1, b1_y1, b1_x2, b1_y2, b2_x1, b2_y1, b2_x2, b2_y2):
    inter_rect_x1 = max(b1_x1, b2_x1)
    inter_rect_y1 = max(b1_y1, b2_y1)
    inter_rect_x2 = min(b1_x2, b2_x2)
    inter_rect_y2 = min(b1_y2, b2_y2)

    # Intersection area
    inter_area = (inter_rect_x2 - inter_rect_x1 + 1.0) * (
        inter_rect_y2 - inter_rect_y1 + 1.0
    )

    # Union Area
    b1_area = (b1_x2 - b1_x1 + 1) * (b1_y2 - b1_y1 + 1.0)
    b2_area = (b2_x2 - b2_x1 + 1) * (b2_y2 - b2_y1 + 1.0)
    iou = inter_area / (b1_area + b2_area - inter_area)

    return iou


# remove bbox for same object
def duplicate_box_removal(bbox):
    j = 0
    del_list = np.zeros(len(bbox))
    while j < len(bbox) - 1:
        i = len(bbox) - 1
        while j < i:
            ious = bbox_iou(bbox[j], bbox[i])
            if ious > nms_conf:
                if bbox[j].score > bbox[i].score:
                    del_list[i] = 1
                else:
                    del_list[j] = 1
            i -= 1
        j += 1

    for k in reversed(range(len(bbox))):
        if del_list[k] == 1:
            del bbox[k]


def main():
    ic = image_converter()
    rospy.init_node("image_converter", anonymous=False)
    try:
        rospy.spin()
    except KeyboardInterrupt:
        print("Shutting down")
    ic.trt_thread.stop()


if __name__ == "__main__":
    main()
