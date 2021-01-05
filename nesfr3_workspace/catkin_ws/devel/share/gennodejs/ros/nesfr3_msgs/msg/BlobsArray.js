// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Blobs = require('./Blobs.js');
let geometry_msgs = _finder('geometry_msgs');
let std_msgs = _finder('std_msgs');

//-----------------------------------------------------------

class BlobsArray {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.header = null;
      this.poses = null;
      this.blobsArray = null;
      this.tracking_id = null;
    }
    else {
      if (initObj.hasOwnProperty('header')) {
        this.header = initObj.header
      }
      else {
        this.header = new std_msgs.msg.Header();
      }
      if (initObj.hasOwnProperty('poses')) {
        this.poses = initObj.poses
      }
      else {
        this.poses = [];
      }
      if (initObj.hasOwnProperty('blobsArray')) {
        this.blobsArray = initObj.blobsArray
      }
      else {
        this.blobsArray = [];
      }
      if (initObj.hasOwnProperty('tracking_id')) {
        this.tracking_id = initObj.tracking_id
      }
      else {
        this.tracking_id = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type BlobsArray
    // Serialize message field [header]
    bufferOffset = std_msgs.msg.Header.serialize(obj.header, buffer, bufferOffset);
    // Serialize message field [poses]
    // Serialize the length for message field [poses]
    bufferOffset = _serializer.uint32(obj.poses.length, buffer, bufferOffset);
    obj.poses.forEach((val) => {
      bufferOffset = geometry_msgs.msg.Pose.serialize(val, buffer, bufferOffset);
    });
    // Serialize message field [blobsArray]
    // Serialize the length for message field [blobsArray]
    bufferOffset = _serializer.uint32(obj.blobsArray.length, buffer, bufferOffset);
    obj.blobsArray.forEach((val) => {
      bufferOffset = Blobs.serialize(val, buffer, bufferOffset);
    });
    // Serialize message field [tracking_id]
    bufferOffset = _arraySerializer.int32(obj.tracking_id, buffer, bufferOffset, null);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type BlobsArray
    let len;
    let data = new BlobsArray(null);
    // Deserialize message field [header]
    data.header = std_msgs.msg.Header.deserialize(buffer, bufferOffset);
    // Deserialize message field [poses]
    // Deserialize array length for message field [poses]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.poses = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.poses[i] = geometry_msgs.msg.Pose.deserialize(buffer, bufferOffset)
    }
    // Deserialize message field [blobsArray]
    // Deserialize array length for message field [blobsArray]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.blobsArray = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.blobsArray[i] = Blobs.deserialize(buffer, bufferOffset)
    }
    // Deserialize message field [tracking_id]
    data.tracking_id = _arrayDeserializer.int32(buffer, bufferOffset, null)
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += std_msgs.msg.Header.getMessageSize(object.header);
    length += 56 * object.poses.length;
    object.blobsArray.forEach((val) => {
      length += Blobs.getMessageSize(val);
    });
    length += 4 * object.tracking_id.length;
    return length + 12;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/BlobsArray';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'a4470e8359735d32f7fb025238b974ce';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    Header header
    
    geometry_msgs/Pose[] poses
    Blobs[] blobsArray
    int32[] tracking_id
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
    MSG: nesfr3_msgs/Blobs
    int32 cluster_id
    Blob[] blobs
    ================================================================================
    MSG: nesfr3_msgs/Blob
    int32 x
    int32 y
    int32 width
    int32 height
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new BlobsArray(null);
    if (msg.header !== undefined) {
      resolved.header = std_msgs.msg.Header.Resolve(msg.header)
    }
    else {
      resolved.header = new std_msgs.msg.Header()
    }

    if (msg.poses !== undefined) {
      resolved.poses = new Array(msg.poses.length);
      for (let i = 0; i < resolved.poses.length; ++i) {
        resolved.poses[i] = geometry_msgs.msg.Pose.Resolve(msg.poses[i]);
      }
    }
    else {
      resolved.poses = []
    }

    if (msg.blobsArray !== undefined) {
      resolved.blobsArray = new Array(msg.blobsArray.length);
      for (let i = 0; i < resolved.blobsArray.length; ++i) {
        resolved.blobsArray[i] = Blobs.Resolve(msg.blobsArray[i]);
      }
    }
    else {
      resolved.blobsArray = []
    }

    if (msg.tracking_id !== undefined) {
      resolved.tracking_id = msg.tracking_id;
    }
    else {
      resolved.tracking_id = []
    }

    return resolved;
    }
};

module.exports = BlobsArray;
