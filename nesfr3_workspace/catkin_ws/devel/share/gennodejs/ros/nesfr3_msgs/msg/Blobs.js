// Auto-generated. Do not edit!

// (in-package nesfr3_msgs.msg)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let Blob = require('./Blob.js');

//-----------------------------------------------------------

class Blobs {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.cluster_id = null;
      this.blobs = null;
    }
    else {
      if (initObj.hasOwnProperty('cluster_id')) {
        this.cluster_id = initObj.cluster_id
      }
      else {
        this.cluster_id = 0;
      }
      if (initObj.hasOwnProperty('blobs')) {
        this.blobs = initObj.blobs
      }
      else {
        this.blobs = [];
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type Blobs
    // Serialize message field [cluster_id]
    bufferOffset = _serializer.int32(obj.cluster_id, buffer, bufferOffset);
    // Serialize message field [blobs]
    // Serialize the length for message field [blobs]
    bufferOffset = _serializer.uint32(obj.blobs.length, buffer, bufferOffset);
    obj.blobs.forEach((val) => {
      bufferOffset = Blob.serialize(val, buffer, bufferOffset);
    });
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type Blobs
    let len;
    let data = new Blobs(null);
    // Deserialize message field [cluster_id]
    data.cluster_id = _deserializer.int32(buffer, bufferOffset);
    // Deserialize message field [blobs]
    // Deserialize array length for message field [blobs]
    len = _deserializer.uint32(buffer, bufferOffset);
    data.blobs = new Array(len);
    for (let i = 0; i < len; ++i) {
      data.blobs[i] = Blob.deserialize(buffer, bufferOffset)
    }
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += 16 * object.blobs.length;
    return length + 8;
  }

  static datatype() {
    // Returns string type for a message object
    return 'nesfr3_msgs/Blobs';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '38502a899cca6d893c4fabfdf43cd8e8';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
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
    const resolved = new Blobs(null);
    if (msg.cluster_id !== undefined) {
      resolved.cluster_id = msg.cluster_id;
    }
    else {
      resolved.cluster_id = 0
    }

    if (msg.blobs !== undefined) {
      resolved.blobs = new Array(msg.blobs.length);
      for (let i = 0; i < resolved.blobs.length; ++i) {
        resolved.blobs[i] = Blob.Resolve(msg.blobs[i]);
      }
    }
    else {
      resolved.blobs = []
    }

    return resolved;
    }
};

module.exports = Blobs;
