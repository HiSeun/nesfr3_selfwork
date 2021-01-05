// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Actor2d = require('./Actor2d.js');
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class Actors2d {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.actors2d = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('actors2d')) {
        this.actors2d = initObj.actors2d
      }
      else {
        this.actors2d = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Actors2d
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [actors2d]
    // Serialize the length for message field [actors2d]
    bufferOffset = _serializer.uint32(obj.actors2d.length, buffer, bufferOffset);
    obj.actors2d.forEach((val) => {
      bufferOffset = Actor2d.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Actors2d
    let len;
    let data = new Actors2d(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [actors2d]
    // Deserialize array length for message field [actors2d]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.actors2d = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.actors2d[i] = Actor2d.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    length += 24 * object.actors2d.length;
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/Actors2d';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'c1bee49e25f0b078e91e5e00c305ebd5';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    Header header   # For frame_id and timestamp
    Actor2d[] actors2d
    
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
    MSG: nesfr3_msgs/Actor2d
    geometry_msgs/Point[18] points          # skeleton points from pose estimation
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
    
    ================================================================================
    MSG: geometry_msgs/Point
    # This contains the position of a point in free space
    float64 x
    float64 y
    float64 z
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new Actors2d(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.actors2d !== undefined) {
      resolved.actors2d = new Array(msg.actors2d.length);
      for (let i = 0; i < resolved.actors2d.length; ++i) {
        resolved.actors2d[i] = Actor2d.Resolve(msg.actors2d[i]);
      }
    }
    else {
      resolved.actors2d = []
    }

    return resolved;
    }
};

module.exports = Actors2d;
