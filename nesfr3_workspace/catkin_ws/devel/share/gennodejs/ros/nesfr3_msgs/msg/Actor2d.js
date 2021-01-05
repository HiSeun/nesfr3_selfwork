// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------

class Actor2d {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.points = null;
    }
    else {
      if (initObj.hasOwnProperty('points')) {
        this.points = initObj.points
      }
      else {
        this.points = new Array(18).fill(new geometry_msgs.msg.Point());
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Actor2d
    // Check that the constant length array field [points] has the right length
    if (obj.points.length !== 18) {
      throw new Error('Unable to serialize array field points - length must be 18')
    }
    // Serialize message field [points]
    obj.points.forEach((val) => {
      bufferOffset = geometry_msgs.msg.Point.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Actor2d
    let len;
    let data = new Actor2d(null);
    // Deserialize message field [points]
    len = 18;
    data.points = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.points[i] = geometry_msgs.msg.Point.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    return 24;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/Actor2d';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '3fb3f9dacc279b964c4c8341122c34df';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
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
    const resolved = new Actor2d(null);
    if (msg.points !== undefined) {
      resolved.points = new Array(18)
      for (let i = 0; i < resolved.points.length; ++i) {
        if (msg.points.length > i) {
          resolved.points[i] = geometry_msgs.msg.Point.Resolve(msg.points[i]);
        }
        else {
          resolved.points[i] = new geometry_msgs.msg.Point();
        }
      }
    }
    else {
      resolved.points = new Array(18).fill(new geometry_msgs.msg.Point())
    }

    return resolved;
    }
};

module.exports = Actor2d;
