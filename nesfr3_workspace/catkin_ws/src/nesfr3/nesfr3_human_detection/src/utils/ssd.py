"""ssd.py

This module implements the TrtSSD class.
"""


import ctypes
import numpy as np
import cv2
import tensorrt as trt
import pycuda.driver as cuda
import pycuda.autoinit
from pycuda.compiler import SourceModule
import logging
from pycuda import gpuarray
import os
import time
import enum
from ssd_classes import COCO_CLASSES_LIST as category_map


class PredictionLayout(enum.IntEnum):
    IMAGE_ID = 0
    YMIN = 1
    XMIN = 2
    YMAX = 3
    XMAX = 4
    CONFIDENCE = 5
    LABEL = 6


class TrtSSD(object):
    """TrtSSD class encapsulates things needed to run TRT SSD."""

    def _load_plugins(self):
        working_dir = os.path.dirname(__file__) + "/../../../"
        NMS_OPT_PLUGIN_LIBRARY = (
            "/mnt/catkin_ws/src/nesfr3/nesfr3_human_detection/libnmsoptplugin.so"
        )
        # NMS_OPT_PLUGIN_LIBRARY = working_dir + NMS_OPT_PLUGIN_LIBRARY
        if not os.path.isfile(os.path.join(working_dir, NMS_OPT_PLUGIN_LIBRARY)):
            raise IOError(
                "{}\n{}\n".format(
                    "Failed to load library ({}).".format(NMS_OPT_PLUGIN_LIBRARY),
                    "Please build the NMS Opt plugin.",
                )
            )
        try:
            ctypes.CDLL(NMS_OPT_PLUGIN_LIBRARY)
        except Exception as e:
            raise e
        trt.init_libnvinfer_plugins(self.trt_logger, "")
        print("Succeeded to load library ({})".format(NMS_OPT_PLUGIN_LIBRARY))

    def _load_engine(self):
        working_dir = os.path.dirname(__file__) + "/../../../"
        TRTbin = "/mnt/catkin_ws/src/nesfr3/nesfr3_human_detection/src/engines/"
        # TRTbin = working_dir + TRTbin.format(self.device)
        if self.device != "Xavier":
            TRTbin += (
                "ssd-small-"
                + self.model
                + "_2018_01_28-SingleStreamB{:d}-gpu-b{:d}-int8.plan"
            )
            TRTbin = TRTbin.format(self.batch_size, self.batch_size)
        else:
            TRTbin += "ssd-small-SingleStream-gpu-b1-int8.plan"

        with open(TRTbin, "rb") as f, trt.Runtime(self.trt_logger) as runtime:
            deserialized_cuda_engine = runtime.deserialize_cuda_engine(f.read())
            if deserialized_cuda_engine == None:
                raise IOError(
                    "{}\n{}\n".format(
                        "Failed to load ssd engine for ({}).".format(self.device),
                        "Check correct engine is chosen.",
                    )
                )
            return deserialized_cuda_engine

    def _create_context(self):
        for binding in self.engine:
            dtype = self.engine.get_binding_dtype(binding)
            form = self.engine.get_binding_format(
                self.engine.get_binding_index(binding)
            )
            shape = self.engine.get_binding_shape(binding)
            if form == trt.TensorFormat.CHW4:
                shape[-3] = ((shape[-3] - 1) // 4 + 1) * 4
            size = trt.volume(shape) * self.engine.max_batch_size

            # Allocate device buffer
            cuda_mem = pycuda.driver.mem_alloc(size * dtype.itemsize)

            # Append device buffer to device bindings
            self.bindings.append(int(cuda_mem))

            # Append to appropriate list
            if self.engine.binding_is_input(binding):
                self.cuda_inputs.append(cuda_mem)
            else:
                host_mem = pycuda.driver.pagelocked_empty(size, trt.nptype(dtype))
                self.host_outputs.append(host_mem)
                self.cuda_outputs.append(cuda_mem)

        return self.engine.create_execution_context()

    def __init__(
        self, model, device, batch_size, verbose, input_shape, output_layout=7
    ):
        """Initialize TensorRT plugins, engine and conetxt."""
        self.model = model
        self.device = device
        self.batch_size = batch_size
        self.verbose = verbose
        self.input_shape = input_shape
        self.output_layout = output_layout
        self.trt_logger = trt.Logger(trt.Logger.VERBOSE)
        self._load_plugins()
        self.engine = self._load_engine()

        self.host_inputs = []
        self.cuda_inputs = []
        self.host_outputs = []
        self.cuda_outputs = []
        self.bindings = []
        self.stream = pycuda.driver.Stream()

        self.allocated = False

        self.context = self._create_context()

    def __del__(self):
        """Free CUDA memories."""
        del self.stream
        del self.cuda_outputs
        del self.cuda_inputs

    def detect(self, img, conf_th=0.3):
        """Detect objects in the input image."""
        ### Preprocess
        self._preprocess_trt(img)

        ### Inference
        start_time = time.time()

        # Run inference
        self.context.execute_async(
            batch_size=self.batch_size,
            bindings=self.bindings,
            stream_handle=self.stream.handle,
        )

        # Transfer predictions back from the GPU
        pycuda.driver.memcpy_dtoh_async(
            self.host_outputs[0], self.cuda_outputs[0], self.stream
        )

        # Synchronize the stream
        self.stream.synchronize()

        if self.verbose:
            print(
                "Infer >> Inference time      :  {:f}".format(time.time() - start_time)
            )

        ### Postprocess
        return self._postprocess_trt(img, conf_th)

    def _preprocess_trt(self, img):
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


        __global__ void RGB2RGBA(uchar3* srcImage, char4* dstImage, bool isBGR, int width, int height)
        {
            int x = (blockIdx.x * blockDim.x) + threadIdx.x;
            int y = (blockIdx.y * blockDim.y) + threadIdx.y;
            int z = (blockIdx.z * blockDim.z) + threadIdx.z;

            const int gridSizeX = gridDim.x * blockDim.x;
            const int gridSizeY = gridDim.y * blockDim.y;

            if( x >= width || y >= height )
                return; 

            for(;x<width;x+=gridSizeX){
                for(;y<height;y+=gridSizeY){ 
                    const int pixel = z * width * height + y * width + x;        
                    const uchar3 px = srcImage[pixel];
                    if( isBGR )
                        dstImage[pixel] = make_char4(px.z+127, px.y+127, px.x+127, 127);
                    else
                        dstImage[pixel] = make_char4(px.x+127, px.y+127, px.z+127, 127);
                }
            }
        }
        """
        )

        # Load source module
        cuda_resize = mod.get_function("gpuPreYoloRGB")
        cuda_rgba = mod.get_function("RGB2RGBA")
        if self.verbose:
            print(
                "Infer >> load source module  :  {:f}".format(time.time() - start_time)
            )

        gridSpec = (64, 64, 1)
        blockSpec = (8, 8, 8)

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

        # Image Convert bgr to rgba
        isBGR = np.array([True])
        start_time = time.time()
        cuda_rgba(
            self.img_resized_gpu,
            self.cuda_inputs[0],
            isBGR,
            width,
            height,
            grid=gridSpec,
            block=blockSpec,
        )
        if self.verbose:
            print(
                "Infer >> cuda_rgba()         :  {:f}".format(time.time() - start_time)
            )

    def _postprocess_trt(self, img, conf_th):
        """Postprocess TRT SSD output."""
        start_time = time.time()

        img_height, img_width, _ = img.shape
        boxes, confs, clss = [], [], []
        batch_detections = np.array(self.host_outputs).reshape(
            self.batch_size, 100 * 7 + 1
        )[: self.batch_size]

        for i, detections in enumerate(batch_detections):
            if self.verbose:
                print(
                    "Infer >> Postprocessing {}th image out of {}".format(
                        i + 1, self.batch_size
                    )
                )
            # number of recognized objects
            keep_count = detections[100 * 7].view("int32")
            for detection in detections[: keep_count * 7].reshape(keep_count, 7):
                if i != 7:
                    conf = float(detection[PredictionLayout.CONFIDENCE])
                    xmin = (
                        int(detection[PredictionLayout.XMIN] * img_width / 4)
                        + i * img_width / 8
                    )
                    ymin = int(detection[PredictionLayout.YMIN] * img_height)
                    xmax = (
                        int(detection[PredictionLayout.XMAX] * img_width / 4)
                        + i * img_width / 8
                    )
                    ymax = int(detection[PredictionLayout.YMAX] * img_height)
                else:
                    if detection[PredictionLayout.XMIN] < 0.5:
                        xmin = (
                            int(detection[PredictionLayout.XMIN] * img_width / 4)
                            + i * img_width / 8
                        )
                    else:
                        xmin = int(
                            (detection[PredictionLayout.XMIN] - 0.5) * img_width / 4
                        )

                    if detection[PredictionLayout.XMAX] < 0.5:
                        xmax = (
                            int(detection[PredictionLayout.XMAX] * img_width / 4)
                            + i * img_width / 8
                        )
                    else:
                        xmax = int(
                            (detection[PredictionLayout.XMAX] - 0.5) * img_width / 4
                        )
                    conf = float(detection[PredictionLayout.CONFIDENCE])
                    ymin = int(detection[PredictionLayout.YMIN] * img_height)
                    ymax = int(detection[PredictionLayout.YMAX] * img_height)

                if conf < conf_th:
                    continue
                image_id = int(detection[PredictionLayout.LABEL])
                image_label = category_map[image_id]
                if self.verbose:
                    print("I see a {:s}!".format(image_label))
                boxes.append((xmin, ymin, xmax, ymax))
                confs.append(conf)
                clss.append(image_id)
        if self.verbose:
            print("Infer >> Postprocessing time: {:f}".format(time.time() - start_time))
        return boxes, confs, clss
