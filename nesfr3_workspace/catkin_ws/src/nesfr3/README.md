# NESFR3

Please [download](https://github.com/wom-ai/wom_tensorrt_object_detection/tree/master/data/ssd/engines) for nesfr3_human_detection.

# TODO

## 0. Add various model to detect bounding box of human
- [X] ssd mobilenet v2
 - fps: ~100 images (4400x1100) per second    
 - performance: sometimes bounding boxes cannot detect human's head or arm
- [X] ssd inception v2
 - fps:   
 - performance: 
- [X] yolov3
 - fps: 9 images per second
 - performance: more accurate than ssd
 - **Preprocessing and inferencing take about 70ms per image, and 40ms for post process. However, postprocess is implemented with cpu for now, so it can be accelerated with gpu based post processing.**
- [X] yolov4
 - fps: 9 images per second   
 - performance: more accurate than ssd

## 1. Human recognition based on color histogram of bounding box
- [X] Implement calculate histogram of bounding boxes.
- [ ] Attach this feature to current source.

