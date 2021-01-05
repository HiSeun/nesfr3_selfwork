
## Downloads
[SSD Engines](https://github.com/wom-ai/wom_tensorrt_object_detection/tree/master/data/ssd/engines) (They are generated on 1080Ti and 2080Ti)   
[yolov3-288-b8.trt](https://drive.google.com/file/d/1Nq54DljdVxAM_V38jnNJg0Qs5kR9_3hr/view?usp=sharing) (it is generated on 1080ti)  
[yolov3_288.onnx](https://drive.google.com/file/d/1Z1VEbYQxWOOPTc19F2HW_rk7WyRcHhwa/view?usp=sharing) (you can use onnx_to_tensorrt_v2.py python3 script to generate optimized engine for your machine).   
[yolov4 related file](https://drive.google.com/open?id=1sjM1rVkzqZA6_zZ-kF3tJ2Q1wHOZVS-l)

The upper trt engine can be only used on 1080ti machines. To build appropriate engine for your graphic card, follow the guideline below. Tested on RTX 2080ti.

```sh
# In your docker env because we need preinstalled tensorrt on python2
git clone git@github.com:jkjung-avt/tensorrt_demos.git
# No further installation required
python pip -m install onnx==1.4.1
# Download upper onnx to $(CWD)
mv yolov3_288.onnx tensorrt_demos/yolov3_onnx/
cd tensorrt_demos/yolov3_onnx
python onnx_to_tensorrt.py --model yolov3-288
# Then you get your machine dependent trt yolov3_288.trt at your $(CWD)
```

## Benchmark
As of [2020.03.10](https://github.com/wom-ai/nesfr3/tree/c472744dbe208a4a7184ece26874e5ec93649f51) on 1080TI, the callback takes avg of 45ms (~20fps) with context execution taking 40ms of it.
When I fed 288x288 manually cropped image on this engine, the context execution took 12 ms. I am not sure why it has so much difference for stacked image and normal image but I think there is a lot of room for optimization.

**GeForce RTX 1080 Ti:**   
   
0. mAP

| Network Size 	| YOLOv3, mAP(0.5) | YOLOv4, mAP(0.5) | YOLOv3, mAP(0.5:95) | YOLOv4, mAP(0.5:95) |
|:-----:|--------:|--------:|--------:|--------:|
|320	| - | 0.60  | - | 0.38  |
|416	| - | 0.628 | - | 0.412 |
|512	| - | 0.649 | - | 0.430 |
|608 	| - | 0.657 | - | 0.435 |
1. without TensorRT(input video: 120fps)   

| Network Size 	| YOLOv3, FPS (avg)| YOLOv4, FPS  |
|:-----:|--------:|--------:|
|320	| - | 63.4 |
|416	| - | 53.7 |
|512	| - | 43.0 |
|608 	| - | - |

2. with TensorRT(input video: 120fps)   

| Network Size 	| YOLOv3, FPS (avg)| YOLOv4, FPS  | YOLOv3, mAP(avg) | YOLOv4, mAP(avg) |
|:-----:|--------:|--------:|--------:|--------:|
|320	| - | - | - | - |
|416	| - | - | - | - |
|512	| - | - | - | - |
|608 	| - | - | - | - |

3. with TensorRT & batch size 8(input video: 120fps)   

| Network Size 	| YOLOv3, FPS (avg)| YOLOv4, FPS  | YOLOv3, mAP(avg) | YOLOv4, mAP(avg) |
|:-----:|--------:|--------:|--------:|--------:|
|320	| - | - | - | - |
|416	| - | - | - | - |
|512	| - | - | - | - |
|608 	| - | - | - | - |

## How to run
If you are using 1080Ti, download the `yolov3-288-b8.trt` and place it in `src/engines` directory. Then just `roslaunch` the node with `model:=yolov3-288` after launching nesfr3.

## Reference 
https://github.com/jkjung-avt/tensorrt_demos
