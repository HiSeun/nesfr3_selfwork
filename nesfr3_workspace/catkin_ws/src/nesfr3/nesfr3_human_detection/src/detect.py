#!/usr/bin/env python
from __future__ import print_function

# We must use python2 :C
# http://wiki.ros.org/cv_bridge/Tutorials/ConvertingBetweenROSImagesAndOpenCVImagesPython#CA-817074f03fe9113b11f4ebb82ba7a20a770af78e_23
# rosrun nesfr_human_detection src/test.py
# rosrun nesfr_human_detection src/detect.py --engine_file /home/robert/Desktop/wom_tensorrt_object_detection/data/ssd/engines/Xavier/ssd-small-SingleStream-gpu-b1-int8.plan --verbose --batch_size 1
import roslib
roslib.load_manifest('nesfr_human_detection')
import sys
import rospy
import cv2
from std_msgs.msg import String
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import numba
from numba import cuda

# For human detection:
# from wom_tensorrt_object_detection
# webcam-ssd-mobilenetv1.py
import ctypes
import os
import sys
import time
import numpy as np
import cv2
import enum
import tensorrt as trt
from code.common.runner import EngineRunner, get_input_format
from code.common import logging
import code.common.arguments as common_args

category_map = {
    0: 'nothing',
    1: 'person',
    2: 'bicycle',
    3: 'car',
    4: 'motorcycle',
    5: 'airplane',
    6: 'bus',
    7: 'train',
    8: 'truck',
    9: 'boat',
    10: 'traffic light',
    11: 'fire hydrant',
    13: 'stop sign',
    14: 'parking meter',
    15: 'bench',
    16: 'bird',
    17: 'cat',
    18: 'dog',
    19: 'horse',
    20: 'sheep',
    21: 'cow',
    22: 'elephant',
    23: 'bear',
    24: 'zebra',
    25: 'giraffe',
    27: 'backpack',
    28: 'umbrella',
    31: 'handbag',
    32: 'tie',
    33: 'suitcase',
    34: 'frisbee',
    35: 'skis',
    36: 'snowboard',
    37: 'sports ball',
    38: 'kite',
    39: 'baseball bat',
    40: 'baseball glove',
    41: 'skateboard',
    42: 'surfboard',
    43: 'tennis racket',
    44: 'bottle',
    46: 'wine glass',
    47: 'cup',
    48: 'fork',
    49: 'knife',
    50: 'spoon',
    51: 'bowl',
    52: 'banana',
    53: 'apple',
    54: 'sandwich',
    55: 'orange',
    56: 'broccoli',
    57: 'carrot',
    58: 'hot dog',
    59: 'pizza',
    60: 'donut',
    61: 'cake',
    62: 'chair',
    63: 'couch',
    64: 'potted plant',
    65: 'bed',
    67: 'dining table',
    70: 'toilet',
    72: 'tv',
    73: 'laptop',
    74: 'mouse',
    75: 'remote',
    76: 'keyboard',
    77: 'cell phone',
    78: 'microwave',
    79: 'oven',
    80: 'toaster',
    81: 'sink',
    82: 'refrigerator',
    84: 'book',
    85: 'clock',
    86: 'vase',
    87: 'scissors',
    88: 'teddy bear',
    89: 'hair drier',
    90: 'toothbrush'
}

def init_tensorrt_plugins():
    working_dir = os.path.dirname(__file__)
    #NMS_OPT_PLUGIN_LIBRARY="../../build/plugins/NMSOptPlugin/libnmsoptplugin.so"
    NMS_OPT_PLUGIN_LIBRARY="/mnt/nesfr3_workspace/catkin_ws/src/nesfr3/wom_tensorrt_object_detection/libnmsoptplugin.so"
    if not os.path.isfile(os.path.join(working_dir, NMS_OPT_PLUGIN_LIBRARY)):
        raise IOError("{}\n{}\n".format(
            "Failed to load library ({}).".format(NMS_OPT_PLUGIN_LIBRARY),
            "Please build the NMS Opt plugin."
        ))
    try:
        ctypes.CDLL(NMS_OPT_PLUGIN_LIBRARY)
    except Exception as e:
        print(err)
        raise e

    sys.path.insert(0, os.getcwd())
    #sys.path.append(os.getcwd())
    print("Succeeded to load library ({}).".format(NMS_OPT_PLUGIN_LIBRARY))

# The output detections for each image is [keepTopK, 7]. The 7 elements are:
class PredictionLayout(enum.IntEnum):
    IMAGE_ID = 0
    YMIN = 1
    XMIN = 2
    YMAX = 3
    XMAX = 4
    CONFIDENCE = 5
    LABEL = 6

@cuda.jit
def cuda_resize(input, inputWidth, inputHeight, output, outputWidth, outputHeight, sequence):
    x = cuda.blockIdx.x * cuda.blockDim.x + cuda.threadIdx.x
    y = cuda.blockIdx.y * cuda.blockDim.y + cuda.threadIdx.y

    if x >= outputWidth or y >= outputHegiht:
        return

    scale_x = inputWidth / 4 /putputWidth
    scale_y = inputHeight / outputHeight

    if sequence != 7 :
        dx = x * scale_x + inputWidth * sequence / 8
        dy = y * scale_y

        px = input[dy * inputWidth + dx]
        output[y * outputWidth + x] = px
    elif :
        if x < (outputWidth / 2) :
            dx = x * scale_x + inputWidth * sequence / 8
            dy = y * scale_y

            px = input[dy * inputWidth + dx]
            output[h * outputWidth + x] = px
        
        else :
            dx = (x - outputWidth / 2) * scale_x
            dy = y * scale_y

            px = input[dy * inputWidth + dx]
            output[y * outputWidth +x] = px

def preprocess_int8_chw4(img):

    start_time = time.time()
    # img_cuda = cuda.to_device(img)
    # output_cuda = cuda.device_array_like(img_cuda)
    # cuda_resize(img_cuda, 4400, 1100, output_cuda, 300, 300, 1)
    # img_resized = ouput_cuda.copy_to_host()
    img_resized = cv2.resize(img, (300, 300))
    logging.debug("Infer >> cv2.resize(img_rgba, (300, 300)):  {:f}".format(time.time() - start_time))

    img_rgba = cv2.cvtColor(img_resized, cv2.COLOR_BGR2RGBA)
    logging.debug("Infer >> cv2.cvtColor(img, cv2.COLOR_BGR2RGBA):  {:f}".format(time.time() - start_time))

    start_time = time.time()
    img_int32 = np.array(img_rgba).astype(np.int32)
    logging.debug("Infer >> np.array(img_rgba).astype(np.int32):  {:f}".format(time.time() - start_time))
    start_time = time.time()
    #img_float = img_float.transpose((2, 0, 1))
    img_int32 = img_int32 - 127
    img_int8  = img_int32.astype(dtype=np.int8, order='C')
    img_int8[:, :, 3] = 0
    img_int8_chw4 = img_int8
    #img_int8_chw4= np.moveaxis(np.pad(img_int8, ((0, 1), (0, 0),(0, 0)), "constant"), -3, -1)
    #print("img_int8_chw4.flags['C_CONTIGUOUS'] = {}".format(img_int8_chw4.flags['C_CONTIGUOUS']))
    batch_images = np.expand_dims(img_int8_chw4, axis=0)

    return batch_images

def preprocess_float32_linear(img):

    start_time = time.time()
    img_resized = cv2.resize(img, (300, 300), interpolation=cv2.INTER_LINEAR)
    logging.debug("Infer >> cv2.resize(img_rgba, (300, 300)):  {:f}".format(time.time() - start_time))

    img_rgba = cv2.cvtColor(img_resized, cv2.COLOR_BGR2RGB)
    logging.debug("Infer >> cv2.cvtColor(img, cv2.COLOR_BGR2RGB):  {:f}".format(time.time() - start_time))

    start_time = time.time()
    img_float32 = np.array(img_rgba).astype(np.float32)
    logging.debug("Infer >> np.array(img_rgba).astype(np.float32):  {:f}".format(time.time() - start_time))
    start_time = time.time()
    img_float32 = img_float32.transpose((2, 0, 1))
    img_float32 = np.ascontiguousarray(img_float32)
    img_float32 = (2.0 / 255.0) * img_float32 - 1.0
    batch_images = np.expand_dims(img_float32, axis=0)

    return batch_images

def init_tensorrt_engine(engine_file, batch_size, verbose=False):
    logging.info("Running SSDMobileNet functionality test for engine [ {:} ] with batch size {:}".format(engine_file, batch_size))

    runner = EngineRunner(engine_file, verbose=verbose)
    input_dtype, input_format = get_input_format(runner.engine)
    if input_dtype == trt.DataType.FLOAT:
        format_string = "fp32"
        preprocess = preprocess_float32_linear
    elif input_dtype == trt.DataType.INT8:
        if input_format == trt.TensorFormat.LINEAR:
            format_string = "int8_linear"
        elif input_format == trt.TensorFormat.CHW4:
            format_string = "int8_chw4"
            preprocess = preprocess_int8_chw4
    logging.info("Engine TensorFormat: {}".format(format_string))

    return runner, preprocess

def run_tensorrt_engine(img, runner, preprocess, batch_size, verbose=False):
    print('[*] run_tensorrt_engine callee called')
    img_height, img_width = img.shape[:2]
    logging.debug("Dim = {}x{}".format(img_height, img_width))

    start_time = time.time()
    batch_images = preprocess(img)
    logging.debug("Infer >> Preprocessing time:  {:f}".format(time.time() - start_time))

    start_time = time.time()
    # runner is problem
    print('runner called')
    [outputs] = runner([batch_images], batch_size)
    logging.debug("Infer >> Inference time:  {:f}".format(time.time() - start_time))

    batch_detections = outputs.reshape(batch_size, 100*7+1)[:batch_size]

    for detections in batch_detections:
        keep_count = detections[100*7].view('int32')
        for detection in detections[:keep_count*7].reshape(keep_count,7):
            score = float(detection[PredictionLayout.CONFIDENCE])
            xmin = detection[PredictionLayout.XMIN] * img_width
            ymin = detection[PredictionLayout.YMIN] * img_height
            xmax = (detection[PredictionLayout.XMAX]) * img_width
            ymax = (detection[PredictionLayout.YMAX]) * img_height
            score = float(detection[PredictionLayout.CONFIDENCE])

            if score > 0.2:
                cv2.rectangle(img, (int(xmin), int(ymin)), (int(xmax), int(ymax)), (100, 255, 0), 2)
                class_id = int(detection[PredictionLayout.LABEL])
                class_label = category_map[class_id]
                display_str = "{}:{}%".format(class_label, int(100*score))
                cv2.putText(img, display_str, (int(xmin), int(ymin + 10)), cv2.FONT_HERSHEY_SIMPLEX, 0.4, (100, 255, 0), 5, cv2.LINE_8)
                cv2.putText(img, display_str, (int(xmin), int(ymin + 10)), cv2.FONT_HERSHEY_SIMPLEX, 0.4, (0, 0, 0), 1, cv2.LINE_8)

    return img

def acquire_images(cap, tensorrt_args):

    runner, preprocess, batch_size, verbose = tensorrt_args
    print('*** IMAGE ACQUISITION ***\n')

    # Retrieve, convert, and save images
    result = True
    key = None
    start = time.time()
    frame_count = 0
    while key != ord('q') and key != 27:
        try:

            #  Retrieve next received image
            ret, frame = cap.read()

            if not ret:
                logging.error("cap.read() failed.")
                result = False
                break

            run_tensorrt_engine(frame, runner, preprocess, batch_size=batch_size, verbose=verbose)
            cv2.imshow('Display', frame)
            key = cv2.waitKey(1)

            frame_count += 1
            end = time.time()
            elapsed = end - start
            if elapsed > 5.0:
                fps = frame_count/elapsed
                print("fps: {} = ({}/{})".format(fps, frame_count, elapsed))

                # reset
                start = time.time()
                frame_count = 0

        except cv2.error as ex:
            print('Error: %s' % ex)
            return False

    return result

import pycuda.driver as cuda

class image_converter:

  def __init__(self, tensorrt_args):
    self.tensorrt_args = tensorrt_args
    self.image_pub = rospy.Publisher("/trt_detection_result", Image, queue_size=1)
    self.bridge = CvBridge()
    self.image_sub = rospy.Subscriber("/nesfr3/1/fisheye_camera/image_raw",Image,self.callback)

  def callback(self,data):
    try:
      cv_image = self.bridge.imgmsg_to_cv2(data, "bgr8")
    except CvBridgeError as e:
      print(e)

    #(rows,cols,channels) = cv_image.shape
    #if cols > 60 and rows > 60 :
    #  cv2.circle(cv_image, (50, 50), 10, 255, -1)

    runner, preprocess, batch_size, verbose = self.tensorrt_args
    # **NOT WORKING**
    # python version issue? WIP

    # device = cuda.Device(0)
    # context = device.make_context()
    print('[*] run_tensorrt_engine caller')
    run_tensorrt_engine(cv_image, runner, preprocess, batch_size=batch_size, verbose=verbose)
    print('[*] run_tensorrt_engine caller end')
    # context.pop()
    # del context

    # cv2.imshow("Image window", cv_image)
    # cv2.waitKey(1)

    try:
      self.image_pub.publish(self.bridge.cv2_to_imgmsg(cv_image, "bgr8"))
    except CvBridgeError as e:
      print(e)

def main(args):
    cuda.init()

    device = cuda.Device(0)
    context = device.make_context()

    logging.getLogger().setLevel(level=logging.DEBUG)
    args = common_args.parse_args(common_args.ACCURACY_ARGS)
    init_tensorrt_plugins()
    batch_size=args["batch_size"]
    verbose=args["verbose"]
    runner, preprocess = init_tensorrt_engine(args["engine_file"], batch_size=batch_size, verbose=verbose)
    tensorrt_args = runner, preprocess, batch_size, verbose

    result = True

    ic = image_converter(tensorrt_args)
    rospy.init_node('trt_detection', anonymous=True)
    try:
        rospy.spin()
    except KeyboardInterrupt:
        print("Shutting down")
    cv2.destroyAllWindows()

    context.pop()
    del context

if __name__ == '__main__':
    main(sys.argv)
