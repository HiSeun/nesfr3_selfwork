cmake_minimum_required(VERSION 2.8.3)
project(nesfr3_msgs)
find_package(catkin REQUIRED COMPONENTS
    std_msgs
    geometry_msgs
    sensor_msgs
    message_generation
)

add_message_files(
    FILES
    PointWithConfidence.msg
    Actor2d.msg
    Actor.msg
    Actors2d.msg
    Actors.msg
    Blob.msg
    Blobs.msg
    BlobsArray.msg
    BoundingBox.msg
    BoundingBoxes.msg
    ClusterProps.msg
    ClusterPropsArray.msg
    PoseArrayWithBoxes.msg
    PoseArrayWithClusters.msg
    TrackingData.msg
)

generate_messages(
    DEPENDENCIES
    std_msgs
    geometry_msgs
    sensor_msgs
)

catkin_package(
  CATKIN_DEPENDS std_msgs geometry_msgs sensor_msgs message_runtime
)
