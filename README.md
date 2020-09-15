# nesfr3_node_description
'Description of cartographer_node, cartographer_occupancy_grid_node, and nesfr3_tracking'
This will concretely explain the roles, and the topics that comes in and goes out.

## 1. Cartographer_node
Cartographer_node and Cartographer_occupancy_grid_node are the Google open source libraries. Cartographer is a system that provides real-time SLAM in 2D and 3D across multiple platforms and sensor configurations. Anyone can approach to its sources : [cartographer] : https://github.com/cartographer-project/cartographer.  

### 1.1. package
Cartographer_node is included in the 'cartographer_ros' package.

### 1.2. Role
The cartographer_node is the SLAM node used for online, real-time SLAM.
Using lidar data, it generates submaps and passes to the occupancy_grid_node

### 1.3. Topics
'''
> Subscribes
>    > nesfr3/1/lidar/points
     
>    > nesfr3/1/wheel_odom
>    > nesfr3/1/lidar_imu
> Publishes
>    >
'''
## 2. Cartographer_occupancy_grid_node

### 2.1. package
Cartographer_occupancy_grid_node is included in the 'cartographer_ros' package.

### 2.2. Role

## 3. nesfr3_tracking
