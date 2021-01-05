# yolo.py
#
# Copyright 1993-2019 NVIDIA Corporation.  All rights reserved.
#
# NOTICE TO LICENSEE:
#
# This source code and/or documentation ("Licensed Deliverables") are
# subject to NVIDIA intellectual property rights under U.S. and
# international Copyright laws.
#
# These Licensed Deliverables contained herein is PROPRIETARY and
# CONFIDENTIAL to NVIDIA and is being provided under the terms and
# conditions of a form of NVIDIA software license agreement by and
# between NVIDIA and Licensee ("License Agreement") or electronically
# accepted by Licensee.  Notwithstanding any terms or conditions to
# the contrary in the License Agreement, reproduction or disclosure
# of the Licensed Deliverables to any third party without the express
# written consent of NVIDIA is prohibited.
#
# NOTWITHSTANDING ANY TERMS OR CONDITIONS TO THE CONTRARY IN THE
# LICENSE AGREEMENT, NVIDIA MAKES NO REPRESENTATION ABOUT THE
# SUITABILITY OF THESE LICENSED DELIVERABLES FOR ANY PURPOSE.  IT IS
# PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND.
# NVIDIA DISCLAIMS ALL WARRANTIES WITH REGARD TO THESE LICENSED
# DELIVERABLES, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY,
# NONINFRINGEMENT, AND FITNESS FOR A PARTICULAR PURPOSE.
# NOTWITHSTANDING ANY TERMS OR CONDITIONS TO THE CONTRARY IN THE
# LICENSE AGREEMENT, IN NO EVENT SHALL NVIDIA BE LIABLE FOR ANY
# SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, OR ANY
# DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
# ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
# OF THESE LICENSED DELIVERABLES.
#
# U.S. Government End Users.  These Licensed Deliverables are a
# "commercial item" as that term is defined at 48 C.F.R. 2.101 (OCT
# 1995), consisting of "commercial computer software" and "commercial
# computer software documentation" as such terms are used in 48
# C.F.R. 12.212 (SEPT 1995) and is provided to the U.S. Government
# only as a commercial end item.  Consistent with 48 C.F.R.12.212 and
# 48 C.F.R. 227.7202-1 through 227.7202-4 (JUNE 1995), all
# U.S. Government End Users acquire the Licensed Deliverables with
# only those rights set forth herein.
#
# Any use of the Licensed Deliverables in individual and commercial
# software must include, in the user documentation and internal
# comments to the code, the above Disclaimer and U.S. Government End
# Users Notice.
#

from __future__ import print_function

import numpy as np
import cv2
import tensorrt as trt
import pycuda.driver as cuda
import time
from pycuda.compiler import SourceModule

import ctypes
import pycuda.autoinit
import logging
from pycuda import gpuarray
import os
import enum


class PostprocessYOLO(object):
    """Class for post-processing the three output tensors from YOLO."""

    def __init__(
        self,
        yolo_masks,
        yolo_anchors,
        nms_threshold,
        yolo_input_resolution,
        batch_size,
        category_num=80,
    ):
        """Initialize with all values that will be kept when processing several frames.
        Assuming 3 outputs of the network in the case of (large) YOLO.

        Keyword arguments:
        yolo_masks -- a list of 3 three-dimensional tuples for the YOLO masks
        yolo_anchors -- a list of 9 two-dimensional tuples for the YOLO anchors
        object_threshold -- threshold for object coverage, float value between 0 and 1
        nms_threshold -- threshold for non-max suppression algorithm,
        float value between 0 and 1
        input_resolution_yolo -- two-dimensional tuple with the target network's (spatial)
        input resolution in HW order
        category_num -- number of output categories/classes
        """
        self.masks = yolo_masks
        self.anchors = yolo_anchors
        self.nms_threshold = nms_threshold
        self.input_wh = (yolo_input_resolution[1], yolo_input_resolution[0])
        self.category_num = category_num
        self.batch_size = batch_size

    def process(self, outputs, resolution_raw, conf_th):
        """Take the YOLOv3 outputs generated from a TensorRT forward pass, post-process them
        and return a list of bounding boxes for detected object together with their category
        and their confidences in separate lists.

        Keyword arguments:
        outputs -- outputs from a TensorRT engine in NCHW format
        resolution_raw -- the original spatial resolution from the input PIL image in WH order
        conf_th -- confidence threshold, e.g. 0.3
        """

        boxes, confs, clss = [], [], []

        img_w, img_h = resolution_raw
        spliced_img_w = img_w / 4
        half = spliced_img_w / 2

        outputs = zip(*outputs)

        for i in range(self.batch_size):
            outputs_reshaped = list()
            for output in outputs[i]:
                outputs_reshaped.append(self._reshape_output(output))

            boxes_xywh, categories, confidences = self._process_yolo_output(
                outputs_reshaped, [spliced_img_w, img_h], conf_th
            )

            if len(boxes_xywh) > 0:
                if i != 7:
                    # convert (x, y, width, height) to (x1, y1, x2, y2)
                    xx = boxes_xywh[:, 0].reshape(-1, 1)
                    yy = boxes_xywh[:, 1].reshape(-1, 1)
                    ww = boxes_xywh[:, 2].reshape(-1, 1)
                    hh = boxes_xywh[:, 3].reshape(-1, 1)

                    temp_boxes = (
                        np.concatenate(
                            [xx + half * i, yy, xx + ww + half * i, yy + hh], axis=1
                        )
                        + 0.5
                    )

                    boxes = boxes + list(temp_boxes.astype(np.int))
                    confs = confs + list(confidences)
                    clss = clss + list(categories)
                else:
                    # convert (x, y, width, height) to (x1, y1, x2, y2)
                    xx = boxes_xywh[:, 0].reshape(-1, 1)
                    yy = boxes_xywh[:, 1].reshape(-1, 1)
                    ww = boxes_xywh[:, 2].reshape(-1, 1)
                    hh = boxes_xywh[:, 3].reshape(-1, 1)

                    temp_boxes = (
                        np.concatenate(
                            [xx + half * i, yy, xx + ww + half * i, yy + hh], axis=1
                        )
                        + 0.5
                    )

                    temp_boxes = temp_boxes % img_w

                    boxes = boxes + list(temp_boxes.astype(np.int))
                    confs = confs + list(confidences)
                    clss = clss + list(categories)

        return boxes, clss, confs

    def _reshape_output(self, output):
        """Reshape a TensorRT output from NCHW to NHWC format (with expected C=255),
        and then return it in (height,width,3,85) dimensionality after further reshaping.

        Keyword argument:
        output -- an output from a TensorRT engine after inference
        """
        output = np.transpose(output, [1, 2, 0])
        height, width, _ = output.shape
        dim1, dim2 = height, width
        dim3 = 3
        # There are CATEGORY_NUM=80 object categories:
        dim4 = 4 + 1 + self.category_num
        result = np.reshape(output, (dim1, dim2, dim3, dim4))
        return result

    def _process_yolo_output(self, outputs_reshaped, resolution_raw, conf_th):
        """Take in a list of three reshaped YOLO outputs in (height,width,3,85) shape and return
        return a list of bounding boxes for detected object together with their category and their
        confidences in separate lists.

        Keyword arguments:
        outputs_reshaped -- list of three reshaped YOLO outputs as NumPy arrays
        with shape (height,width,3,85)
        resolution_raw -- the original spatial resolution from the input PIL image in WH order
        conf_th -- confidence threshold
        """

        # E.g. in YOLOv3-608, there are three output tensors, which we associate with their
        # respective masks. Then we iterate through all output-mask pairs and generate candidates
        # for bounding boxes, their corresponding category predictions and their confidences:
        boxes, categories, confidences = list(), list(), list()

        for output, mask in zip(outputs_reshaped, self.masks):
            box, category, confidence = self._process_feats(output, mask)
            box, category, confidence = self._filter_boxes(
                box, category, confidence, conf_th
            )
            boxes.append(box)
            categories.append(category)
            confidences.append(confidence)

        boxes = np.concatenate(boxes)
        categories = np.concatenate(categories)
        confidences = np.concatenate(confidences)

        # Scale boxes back to original image shape:
        width, height = resolution_raw
        image_dims = [width, height, width, height]
        boxes = boxes * image_dims
        # Using the candidates from the previous (loop) step, we apply the non-max suppression
        # algorithm that clusters adjacent bounding boxes to a single bounding box:
        nms_boxes, nms_categories, nscores = list(), list(), list()
        for category in set(categories):
            idxs = np.where(categories == category)
            box = boxes[idxs]
            category = categories[idxs]
            confidence = confidences[idxs]

            keep = self._nms_boxes(box, confidence)

            nms_boxes.append(box[keep])
            nms_categories.append(category[keep])
            nscores.append(confidence[keep])

        if not nms_categories and not nscores:
            return (
                np.empty((0, 4), dtype=np.float32),
                np.empty((0, 1), dtype=np.float32),
                np.empty((0, 1), dtype=np.float32),
            )

        boxes = np.concatenate(nms_boxes)
        categories = np.concatenate(nms_categories)
        confidences = np.concatenate(nscores)

        return boxes, categories, confidences

    def _process_feats(self, output_reshaped, mask):
        """Take in a reshaped YOLO output in height,width,3,85 format together with its
        corresponding YOLO mask and return the detected bounding boxes, the confidence,
        and the class probability in each cell/pixel.

        Keyword arguments:
        output_reshaped -- reshaped YOLO output as NumPy arrays with shape (height,width,3,85)
        mask -- 2-dimensional tuple with mask specification for this output
        """

        def sigmoid_v(array):
            return np.reciprocal(np.exp(-array) + 1.0)

        def exponential_v(array):
            return np.exp(array)

        grid_h, grid_w, _, _ = output_reshaped.shape

        anchors = [self.anchors[i] for i in mask]

        # Reshape to N, height, width, num_anchors, box_params:
        anchors_tensor = np.reshape(anchors, [1, 1, len(anchors), 2])
        box_xy = sigmoid_v(output_reshaped[..., 0:2])
        box_wh = exponential_v(output_reshaped[..., 2:4]) * anchors_tensor
        box_confidence = sigmoid_v(output_reshaped[..., 4:5])
        box_class_probs = sigmoid_v(output_reshaped[..., 5:])

        col = np.tile(np.arange(0, grid_w), grid_w).reshape(-1, grid_w)
        row = np.tile(np.arange(0, grid_h).reshape(-1, 1), grid_h)

        col = col.reshape(grid_h, grid_w, 1, 1).repeat(3, axis=-2)
        row = row.reshape(grid_h, grid_w, 1, 1).repeat(3, axis=-2)
        grid = np.concatenate((col, row), axis=-1)

        box_xy += grid
        box_xy /= (grid_w, grid_h)
        # box_wh /= self.input_resolution_yolo
        box_wh /= self.input_wh
        box_xy -= box_wh / 2.0
        boxes = np.concatenate((box_xy, box_wh), axis=-1)

        # boxes: centroids, box_confidence: confidence level, box_class_probs:
        # class confidence
        return boxes, box_confidence, box_class_probs

    def _filter_boxes(self, boxes, box_confidences, box_class_probs, conf_th):
        """Take in the unfiltered bounding box descriptors and discard each cell
        whose score is lower than the object threshold set during class initialization.

        Keyword arguments:
        boxes -- bounding box coordinates with shape (height,width,3,4); 4 for
        x,y,height,width coordinates of the boxes
        box_confidences -- bounding box confidences with shape (height,width,3,1); 1 for as
        confidence scalar per element
        box_class_probs -- class probabilities with shape (height,width,3,CATEGORY_NUM)
        conf_th -- confidence threshold
        """
        box_scores = box_confidences * box_class_probs
        box_classes = np.argmax(box_scores, axis=-1)
        box_class_scores = np.max(box_scores, axis=-1)
        pos = np.where(box_class_scores >= conf_th)

        boxes = boxes[pos]
        classes = box_classes[pos]
        scores = box_class_scores[pos]

        return boxes, classes, scores

    def _nms_boxes(self, boxes, box_confidences):
        """Apply the Non-Maximum Suppression (NMS) algorithm on the bounding boxes with their
        confidence scores and return an array with the indexes of the bounding boxes we want to
        keep (and display later).

        Keyword arguments:
        boxes -- a NumPy array containing N bounding-box coordinates that survived filtering,
        with shape (N,4); 4 for x,y,height,width coordinates of the boxes
        box_confidences -- a Numpy array containing the corresponding confidences with shape N
        """
        x_coord = boxes[:, 0]
        y_coord = boxes[:, 1]
        width = boxes[:, 2]
        height = boxes[:, 3]

        areas = width * height
        ordered = box_confidences.argsort()[::-1]

        keep = list()
        while ordered.size > 0:
            # Index of the current element:
            i = ordered[0]
            keep.append(i)
            xx1 = np.maximum(x_coord[i], x_coord[ordered[1:]])
            yy1 = np.maximum(y_coord[i], y_coord[ordered[1:]])
            xx2 = np.minimum(
                x_coord[i] + width[i], x_coord[ordered[1:]] + width[ordered[1:]]
            )
            yy2 = np.minimum(
                y_coord[i] + height[i], y_coord[ordered[1:]] + height[ordered[1:]]
            )

            width1 = np.maximum(0.0, xx2 - xx1 + 1)
            height1 = np.maximum(0.0, yy2 - yy1 + 1)
            intersection = width1 * height1
            union = areas[i] + areas[ordered[1:]] - intersection

            # Compute the Intersection over Union (IoU) score:
            iou = intersection / union

            # The goal of the NMS algorithm is to reduce the number of adjacent bounding-box
            # candidates to a minimum. In this step, we keep only those elements whose overlap
            # with the current bounding box is lower than the threshold:
            indexes = np.where(iou <= self.nms_threshold)[0]
            ordered = ordered[indexes + 1]

        keep = np.array(keep)
        return keep


class HostDeviceMem(object):
    """Simple helper data class that's a little nicer to use than a 2-tuple."""

    def __init__(self, host_mem, device_mem):
        self.host = host_mem
        self.device = device_mem

    def __str__(self):
        return "Host:\n" + str(self.host) + "\nDevice:\n" + str(self.device)

    def __repr__(self):
        return self.__str__()


def allocate_buffers(engine):
    """Allocates all host/device in/out buffers required for an engine."""
    inputs = []
    outputs = []
    bindings = []
    stream = cuda.Stream()
    for binding in engine:
        size = trt.volume(engine.get_binding_shape(binding)) * engine.max_batch_size
        dtype = trt.nptype(engine.get_binding_dtype(binding))
        # Allocate host and device buffers
        host_mem = cuda.pagelocked_empty(size, dtype)
        device_mem = cuda.mem_alloc(host_mem.nbytes)
        # Append the device buffer to device bindings.
        bindings.append(int(device_mem))
        # Append to the appropriate list.
        if engine.binding_is_input(binding):
            inputs.append(HostDeviceMem(host_mem, device_mem))
        else:
            outputs.append(HostDeviceMem(host_mem, device_mem))
    return inputs, outputs, bindings, stream


def do_inference(context, bindings, inputs, outputs, stream, batch_size=1):
    """do_inference (for TensorRT 6.x or lower)

    This function is generalized for multiple inputs/outputs.
    Inputs and outputs are expected to be lists of HostDeviceMem objects.
    """
    # Transfer input data to the GPU.
    [cuda.memcpy_htod_async(inp.device, inp.host, stream) for inp in inputs]
    # Run inference.
    context.execute_async(
        batch_size=batch_size,
        bindings=bindings,
        stream_handle=stream.handle
    )
    # Transfer predictions back from the GPU.
    [cuda.memcpy_dtoh_async(out.host, out.device, stream) for out in outputs]
    # Synchronize the stream
    stream.synchronize()
    # Return only the host outputs.
    return [out.host for out in outputs]


def do_inference_v2(context, bindings, inputs, outputs, stream):
    """do_inference_v2 (for TensorRT 7.0+)

    This function is generalized for multiple inputs/outputs for full
    dimension networks.
    Inputs and outputs are expected to be lists of HostDeviceMem objects.
    """
    # Transfer input data to the GPU.
    [cuda.memcpy_htod_async(inp.device, inp.host, stream) for inp in inputs]
    # Run inference.
    context.execute_async_v2(bindings=bindings, stream_handle=stream.handle)
    # Transfer predictions back from the GPU.
    [cuda.memcpy_dtoh_async(out.host, out.device, stream) for out in outputs]
    # Synchronize the stream
    stream.synchronize()
    # Return only the host outputs.
    return [out.host for out in outputs]


class TrtYOLO(object):
    """TrtYOLO class encapsulates things needed to run TRT YOLO."""

    def _load_engine(self):
        TRTbin = "/mnt/catkin_ws/src/nesfr3/nesfr3_human_detection/src/engines/"
        if "yolov3" in self.model:
            TRTbin += "yolov3-288.trt"
        elif "yolov4" in self.model:
            TRTbin += "yolov4-288.trt"
        with open(TRTbin, "rb") as f, trt.Runtime(self.trt_logger) as runtime:
            return runtime.deserialize_cuda_engine(f.read())

    def _create_context(self):
        return self.engine.create_execution_context()

    def _init_yolov3_postprocessor(self):
        h, w = self.input_shape

        if "tiny" in self.model:
            self.output_shapes = [
                (self.batch_size, 255, h // 32, w // 32),
                (self.batch_size, 255, h // 16, w // 16),
            ]
        else:
            self.output_shapes = [
                (self.batch_size, 255, h // 32, w // 32),
                (self.batch_size, 255, h // 16, w // 16),
                (self.batch_size, 255, h // 8, w // 8),
            ]
        if "tiny" in self.model:
            postprocessor_args = {
                # A list of 2 three-dimensional tuples for the Tiny YOLO masks
                "yolo_masks": [(3, 4, 5), (0, 1, 2)],
                # A list of 6 two-dimensional tuples for the Tiny YOLO anchors
                "yolo_anchors": [
                    (10, 14),
                    (23, 27),
                    (37, 58),
                    (81, 82),
                    (135, 169),
                    (344, 319),
                ],
                # Threshold for non-max suppression algorithm, float
                # value between 0 and 1
                "nms_threshold": 0.5,
                "yolo_input_resolution": self.input_shape,
            }
        else:
            postprocessor_args = {
                # A list of 3 three-dimensional tuples for the YOLO masks
                "yolo_masks": [(6, 7, 8), (3, 4, 5), (0, 1, 2)],
                # A list of 9 two-dimensional tuples for the YOLO anchors
                "yolo_anchors": [
                    (10, 13),
                    (16, 30),
                    (33, 23),
                    (30, 61),
                    (62, 45),
                    (59, 119),
                    (116, 90),
                    (156, 198),
                    (373, 326),
                ],
                # Threshold for non-max suppression algorithm, float
                # value between 0 and 1
                # between 0 and 1
                "nms_threshold": 0.5,
                "yolo_input_resolution": self.input_shape,
                "batch_size": self.batch_size,
            }

        self.allocated = False

        self.postprocessor = PostprocessYOLO(**postprocessor_args)

    def _init_yolov4_postprocessor(self):
        h, w = self.input_shape

        if "tiny" in self.model:
            self.output_shapes = [
                (self.batch_size, 255, h // 16, w // 16),
                (self.batch_size, 255, h // 32, w // 32),
            ]
        else:
            self.output_shapes = [
                (self.batch_size, 255, h // 8, w // 8),
                (self.batch_size, 255, h // 16, w // 16),
                (self.batch_size, 255, h // 32, w // 32),
            ]
        if "tiny" in self.model:
            postprocessor_args = {
                # A list of 2 three-dimensional tuples for the Tiny YOLO masks
                "yolo_masks": [(0, 1, 2), (3, 4, 5)],
                # A list of 6 two-dimensional tuples for the Tiny YOLO anchors
                "yolo_anchors": [
                    (10, 14),
                    (23, 27),
                    (37, 58),
                    (81, 82),
                    (135, 169),
                    (344, 319),
                ],
                # Threshold for non-max suppression algorithm, float
                # value between 0 and 1
                "nms_threshold": 0.5,
                "yolo_input_resolution": self.input_shape,
            }
        else:
            postprocessor_args = {
                # A list of 3 three-dimensional tuples for the YOLO masks
                "yolo_masks": [(0, 1, 2), (3, 4, 5), (6, 7, 8)],
                # A list of 9 two-dimensional tuples for the YOLO anchors
                "yolo_anchors": [
                    (12, 16),
                    (19, 36),
                    (40, 28),
                    (36, 75),
                    (76, 55),
                    (72, 146),
                    (142, 110),
                    (192, 243),
                    (459, 401),
                ],
                # Threshold for non-max suppression algorithm, float
                # value between 0 and 1
                "nms_threshold": 0.5,
                "yolo_input_resolution": self.input_shape,
                "batch_size": self.batch_size,
            }

        self.allocated = False

        self.postprocessor = PostprocessYOLO(**postprocessor_args)

    def __init__(self, model, device, batch_size, verbose, input_shape=(288, 288)):
        """Initialize TensorRT plugins, engine and conetxt."""

        self.model = model
        self.device = device
        self.input_shape = input_shape
        self.verbose = verbose
        self.batch_size = batch_size

        if "yolov3" in self.model:
            self._init_yolov3_postprocessor()
        elif "yolov4" in self.model:
            self._init_yolov4_postprocessor()

        self.trt_logger = trt.Logger(trt.Logger.INFO)
        self.engine = self._load_engine()
        self.context = self._create_context()
        self.inputs, self.outputs, self.bindings, self.stream = allocate_buffers(
            self.engine
        )
        self.inference_fn = (
            do_inference if trt.__version__[0] < "7" else do_inference_v2
        )

    def __del__(self):
        """Free CUDA memories."""
        del self.stream
        del self.outputs
        del self.inputs

    def detect(self, img, conf_th=0.3):
        """Detect objects in the input image."""
        shape_orig_WH = (img.shape[1], img.shape[0])  # 1200, 300
        img_resized = self._preprocess_yolo(img, self.batch_size)

        # Set host input to the image. The do_inference() function
        # will copy the input to the GPU before executing.
        self.inputs[0].host = np.ascontiguousarray(img_resized)

        trt_outputs = self.inference_fn(
            context=self.context,
            bindings=self.bindings,
            inputs=self.inputs,
            outputs=self.outputs,
            stream=self.stream,
            batch_size=self.batch_size,
        )

        # Before doing post-processing, we need to reshape the outputs
        # as do_inference() will give us flat arrays.
        trt_outputs = [
            output.reshape(shape)
            for output, shape in zip(trt_outputs, self.output_shapes)
        ]

        # Run the post-processing algorithms on the TensorRT outputs
        # and get the bounding box details of detected objects
        boxes, classes, scores = self.postprocessor.process(
            trt_outputs, shape_orig_WH, conf_th
        )

        return boxes, scores, classes

    def _preprocess_yolo(self, img, batch_size):
        """Preprocess an image before TRT SSD inferencing."""

        preprocess_start_time = time.time()

        # preprocess_int8_chw4
        start_time = preprocess_start_time

        shape = self.input_shape

        height = np.int32(shape[0])
        width = np.int32(shape[1])

        if not self.allocated:
            # Allocate CPU memory
            self.img_resized_cpu = np.empty(
                (self.batch_size, shape[0], shape[1], 3)
            ).astype(np.uint8)
            if self.verbose:
                print(
                    "Infer >> CPU Allocation      :  {:f}".format(
                        time.time() - start_time
                    )
                )

            # Allocate GPU memory
            start_time = time.time()
            self.img_gpu = cuda.mem_alloc(img.size * img.dtype.itemsize)
            self.img_resized_gpu = cuda.mem_alloc(
                self.img_resized_cpu.size * self.img_resized_cpu.dtype.itemsize
            )
            if self.verbose:
                print(
                    "Infer >> GPU Allocation      :  {:f}".format(
                        time.time() - start_time
                    )
                )
            self.allocated = True

        # Memory cpy host to device
        start_time = time.time()
        cuda.memcpy_htod(self.img_gpu, img)
        if self.verbose:
            print(
                "Infer >> Load Image to gpu   :  {:f}".format(time.time() - start_time)
            )

        start_time = time.time()
        mod = SourceModule(
            """
        __global__ void gpuPreYoloRGB(uchar3* input, uchar3* output, int oWidth, int oHeight)
        {
            int iWidth  = 1200;
            int iHeight = 300;
            float2 scale = make_float2(float(iHeight)/float(oHeight), float(iHeight)/float(oWidth));

            int half = oWidth / 2;

            int x = blockIdx.x * blockDim.x + threadIdx.x;
            int y = blockIdx.y * blockDim.y + threadIdx.y;
            int z = blockIdx.z * blockDim.z + threadIdx.z;

            int sequence = z;

            const int gridSizeX = gridDim.x * blockDim.x;
            const int gridSizeY = gridDim.y * blockDim.y;

            if( x >= oWidth || y >= oHeight )
            return;

            for(;x<oWidth;x+=gridSizeX){
                for(;y<oHeight;y+=gridSizeY){
                    if( sequence != 7 ){
                        const int dx = ((float)x * scale.x + iWidth * sequence / 8);
                        const int dy = ((float)y * scale.y);

                        const uchar3 px  = input[ dy * iWidth + dx ];
                        output[sequence * oWidth * oHeight + y * oWidth + x] = px;
                    }else if( sequence == 7 ){
                        if ( x < half ){
                            const int dx = ((float)x * scale.x + iWidth * sequence / 8);
                            const int dy = ((float)y * scale.y );

                            const uchar3 px  = input[ dy * iWidth + dx ];
                            output[sequence * oWidth * oHeight + y * oWidth + x] = px;
                        }
                        else{
                            const int dx = ((float)(x - half) * scale.x);
                            const int dy = ((float)y * scale.y );

                            const uchar3 px  = input[ dy * iWidth + dx ];
                            output[sequence * oWidth * oHeight + y * oWidth + x] = px;
                        }
                    }
                }
            }
        }
        """
        )

        # Load source module
        cuda_resize = mod.get_function("gpuPreYoloRGB")
        if self.verbose:
            print(
                "Infer >> load source module  :  {:f}".format(time.time() - start_time)
            )

        gridSpec = (64, 64, 1)
        blockSpec = (8, 8, self.batch_size)

        # Image Resize
        start_time = time.time()
        cuda_resize(
            self.img_gpu,
            self.img_resized_gpu,
            width,
            height,
            grid=gridSpec,
            block=blockSpec,
        )
        if self.verbose:
            print(
                "Infer >> cuda_resize()       :  {:f}".format(time.time() - start_time)
            )

        start_time = time.time()
        cuda.memcpy_dtoh(self.img_resized_cpu, self.img_resized_gpu)
        if self.verbose:
            print(
                "Infer >> memory_dtoh()       :  {:f}".format(time.time() - start_time)
            )

        start_time = time.time()
        batch_images = np.transpose(self.img_resized_cpu, [0, 3, 1, 2]).astype(
            np.float32
        )
        batch_images /= 255.0

        if self.verbose:
            print(
                "Infer >> type porting        :  {:f}".format(time.time() - start_time)
            )

        if self.verbose:
            print(
                "Infer >> Preprocessing time  :  {:f}".format(
                    time.time() - preprocess_start_time
                )
            )

        return batch_images
