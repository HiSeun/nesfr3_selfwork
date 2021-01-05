// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Actor = require('./Actor.js');
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class Actors {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.actors = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('actors')) {
        this.actors = initObj.actors
      }
      else {
        this.actors = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Actors
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [actors]
    // Serialize the length for message field [actors]
    bufferOffset = _serializer.uint32(obj.actors.length, buffer, bufferOffset);
    obj.actors.forEach((val) => {
      bufferOffset = Actor.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Actors
    let len;
    let data = new Actors(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [actors]
    // Deserialize array length for message field [actors]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.actors = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.actors[i] = Actor.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    object.actors.forEach((val) => {
      length += Actor.getMessageSize(val);
    });
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/Actors';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '3cb6e6b906cb00a49df587adf340a00b';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    Header header   # For frame_id and timestamp
    Actor[] actors
    
    ================================================================================
    MSG: std_msgs/Header
    # Standard metadata for higher-level stamped data types.
    # This is generally used to communicate timestamped data 
    # in a particular coordinate frame.
    # 
    # sequence ID: consecutively increasing ID 
    uint32 seq
    #Two-integer timestamp that is expressed as:
    # * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
    # * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
    # time-handling sugar is provided by the client library
    time stamp
    #Frame this data is associated with
    string frame_id
    
    ================================================================================
    MSG: nesfr3_msgs/Actor
    Header header                           # frame_id and timestamp
    string name                             # name for face recognition
    uint32 tracking_id                      # identification for tracking
    geometry_msgs/PoseWithCovariance pose   # position from detection and 
                                            # orientation from EKF
    PointWithConfidence[18] points          # skeleton points from pose estimation
                                            # 0: nose
                                            # 1: left eye
                                            # 2: right eye
                                            # 3: left ear
                                            # 4: right ear
                                            # 5: left shoulder
                                            # 6: right shoulder
                                            # 7: left elbow
                                            # 8: right elbow
                                            # 9: left wrist
                                            # 10: right wrist
                                            # 11: left hip
                                            # 12: right hip
                                            # 13: left knee
                                            # 14: right knee
                                            # 15: left ankle
                                            # 16: right ankle
                                            # 17: neck
    geometry_msgs/Point nose_point          # nose_point for facerec
    ================================================================================
    MSG: geometry_msgs/PoseWithCovariance
    # This represents a pose in free space with uncertainty.
    
    Pose pose
    
    # Row-major representation of the 6x6 covariance matrix
    # The orientation parameters use a fixed-axis representation.
    # In order, the parameters are:
    # (x, y, z, rotation about X axis, rotation about Y axis, rotation about Z axis)
    float64[36] covariance
    
    ================================================================================
    MSG: geometry_msgs/Pose
    # A representation of pose in free space, composed of position and orientation. 
    Point position
    Quaternion orientation
    
    ================================================================================
    MSG: geometry_msgs/Point
    # This contains the position of a point in free space
    float64 x
    float64 y
    float64 z
    
    ================================================================================
    MSG: geometry_msgs/Quaternion
    # This represents an orientation in free space in quaternion form.
    
    float64 x
    float64 y
    float64 z
    float64 w
    
    ================================================================================
    MSG: nesfr3_msgs/PointWithConfidence
    geometry_msgs/Point point
    float32 confidence
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new Actors(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.actors !== undefined) {
      resolved.actors = new Array(msg.actors.length);
      for (let i = 0; i < resolved.actors.length; ++i) {
        resolved.actors[i] = Actor.Resolve(msg.actors[i]);
      }
    }
    else {
      resolved.actors = []
    }

    return resolved;
    }
};

module.exports = Actors;
