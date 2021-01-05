// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let ClusterProps = require('./ClusterProps.js');
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class ClusterPropsArray {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.ClusterPropsArray = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('ClusterPropsArray')) {
        this.ClusterPropsArray = initObj.ClusterPropsArray
      }
      else {
        this.ClusterPropsArray = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type ClusterPropsArray
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [ClusterPropsArray]
    // Serialize the length for message field [ClusterPropsArray]
    bufferOffset = _serializer.uint32(obj.ClusterPropsArray.length, buffer, bufferOffset);
    obj.ClusterPropsArray.forEach((val) => {
      bufferOffset = ClusterProps.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type ClusterPropsArray
    let len;
    let data = new ClusterPropsArray(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [ClusterPropsArray]
    // Deserialize array length for message field [ClusterPropsArray]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.ClusterPropsArray = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.ClusterPropsArray[i] = ClusterProps.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    length += 72 * object.ClusterPropsArray.length;
    return length + 4;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/ClusterPropsArray';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '4608baf7edd9b6be483773f66e382aa3';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    Header header
    
    ClusterProps[] ClusterPropsArray
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
    MSG: nesfr3_msgs/ClusterProps
    geometry_msgs/Point min
    geometry_msgs/Point max
    geometry_msgs/Point centroid
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
    const resolved = new ClusterPropsArray(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.ClusterPropsArray !== undefined) {
      resolved.ClusterPropsArray = new Array(msg.ClusterPropsArray.length);
      for (let i = 0; i < resolved.ClusterPropsArray.length; ++i) {
        resolved.ClusterPropsArray[i] = ClusterProps.Resolve(msg.ClusterPropsArray[i]);
      }
    }
    else {
      resolved.ClusterPropsArray = []
    }

    return resolved;
    }
};

module.exports = ClusterPropsArray;
