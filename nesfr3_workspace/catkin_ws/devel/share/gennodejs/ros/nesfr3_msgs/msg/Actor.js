// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let PointWithConfidence = require('./PointWithConfidence.js');
let geometry_msgs = _finder('geometry_msgs');
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class Actor {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.name = null;
      this.tracking_id = null;
      this.pose = null;
      this.points = null;
      this.nose_point = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('name')) {
        this.name = initObj.name
      }
      else {
        this.name = '';
      }
      if (initObj.hasOwnProperty('tracking_id')) {
        this.tracking_id = initObj.tracking_id
      }
      else {
        this.tracking_id = 0;
      }
      if (initObj.hasOwnProperty('pose')) {
        this.pose = initObj.pose
      }
      else {
        this.pose = new geometry_msgs.msg.PoseWithCovariance();
      }
      if (initObj.hasOwnProperty('points')) {
        this.points = initObj.points
      }
      else {
        this.points = new Array(18).fill(new PointWithConfidence());
      }
      if (initObj.hasOwnProperty('nose_point')) {
        this.nose_point = initObj.nose_point
      }
      else {
        this.nose_point = new geometry_msgs.msg.Point();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Actor
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [name]
    bufferOffset = _serializer.string(obj.name, buffer, bufferOffset);
    // Serialize message field [tracking_id]
    bufferOffset = _serializer.uint32(obj.tracking_id, buffer, bufferOffset);
    // Serialize message field [pose]
    bufferOffset = geometry_msgs.msg.PoseWithCovariance.serialize(obj.pose, buffer, bufferOffset);
    // Check that the constant length array field [points] has the right length
    if (obj.points.length !== 18) {
      throw new Error('Unable to serialize array field points - length must be 18')
    }
    // Serialize message field [points]
    obj.points.forEach((val) => {
      bufferOffset = PointWithConfidence.serialize(val, buffer, bufferOffset);
    });
    // Serialize message field [nose_point]
    bufferOffset = geometry_msgs.msg.Point.serialize(obj.nose_point, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Actor
    let len;
    let data = new Actor(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [name]
    data.name = _deserializer.string(buffer, bufferOffset);
    // Deserialize message field [tracking_id]
    data.tracking_id = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [pose]
    data.pose = geometry_msgs.msg.PoseWithCovariance.deserialize(buffer, bufferOffset);
    // Deserialize message field [points]
    len = 18;
    data.points = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.points[i] = PointWithConfidence.deserialize(buffer, bufferOffset)
    }
    // Deserialize message field [nose_point]
    data.nose_point = geometry_msgs.msg.Point.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    length += object.name.length;
    return length + 880;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/Actor';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'e66ab061dc9fde49d29081c40910f1a1';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
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
    const resolved = new Actor(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.name !== undefined) {
      resolved.name = msg.name;
    }
    else {
      resolved.name = ''
    }

    if (msg.tracking_id !== undefined) {
      resolved.tracking_id = msg.tracking_id;
    }
    else {
      resolved.tracking_id = 0
    }

    if (msg.pose !== undefined) {
      resolved.pose = geometry_msgs.msg.PoseWithCovariance.Resolve(msg.pose)
    }
    else {
      resolved.pose = new geometry_msgs.msg.PoseWithCovariance()
    }

    if (msg.points !== undefined) {
      resolved.points = new Array(18)
      for (let i = 0; i < resolved.points.length; ++i) {
        if (msg.points.length > i) {
          resolved.points[i] = PointWithConfidence.Resolve(msg.points[i]);
        }
        else {
          resolved.points[i] = new PointWithConfidence();
        }
      }
    }
    else {
      resolved.points = new Array(18).fill(new PointWithConfidence())
    }

    if (msg.nose_point !== undefined) {
      resolved.nose_point = geometry_msgs.msg.Point.Resolve(msg.nose_point)
    }
    else {
      resolved.nose_point = new geometry_msgs.msg.Point()
    }

    return resolved;
    }
};

module.exports = Actor;
