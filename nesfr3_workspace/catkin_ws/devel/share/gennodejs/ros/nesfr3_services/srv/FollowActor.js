// Auto-generated. Do not edit!

// (in-package nesfr3_services.srv)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;

//-----------------------------------------------------------


//-----------------------------------------------------------

class FollowActorRequest {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.actor_id = null;
      this.robot_id = null;
      this.distance = null;
      this.angle = null;
      this.shot_size = null;
      this.use_gt = null;
    }
    else {
      if (initObj.hasOwnProperty('actor_id')) {
        this.actor_id = initObj.actor_id
      }
      else {
        this.actor_id = 0;
      }
      if (initObj.hasOwnProperty('robot_id')) {
        this.robot_id = initObj.robot_id
      }
      else {
        this.robot_id = 0;
      }
      if (initObj.hasOwnProperty('distance')) {
        this.distance = initObj.distance
      }
      else {
        this.distance = 0.0;
      }
      if (initObj.hasOwnProperty('angle')) {
        this.angle = initObj.angle
      }
      else {
        this.angle = 0.0;
      }
      if (initObj.hasOwnProperty('shot_size')) {
        this.shot_size = initObj.shot_size
      }
      else {
        this.shot_size = '';
      }
      if (initObj.hasOwnProperty('use_gt')) {
        this.use_gt = initObj.use_gt
      }
      else {
        this.use_gt = 0;
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type FollowActorRequest
    // Serialize message field [actor_id]
    bufferOffset = _serializer.uint32(obj.actor_id, buffer, bufferOffset);
    // Serialize message field [robot_id]
    bufferOffset = _serializer.uint32(obj.robot_id, buffer, bufferOffset);
    // Serialize message field [distance]
    bufferOffset = _serializer.float64(obj.distance, buffer, bufferOffset);
    // Serialize message field [angle]
    bufferOffset = _serializer.float64(obj.angle, buffer, bufferOffset);
    // Serialize message field [shot_size]
    bufferOffset = _serializer.string(obj.shot_size, buffer, bufferOffset);
    // Serialize message field [use_gt]
    bufferOffset = _serializer.uint32(obj.use_gt, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type FollowActorRequest
    let len;
    let data = new FollowActorRequest(null);
    // Deserialize message field [actor_id]
    data.actor_id = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [robot_id]
    data.robot_id = _deserializer.uint32(buffer, bufferOffset);
    // Deserialize message field [distance]
    data.distance = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [angle]
    data.angle = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [shot_size]
    data.shot_size = _deserializer.string(buffer, bufferOffset);
    // Deserialize message field [use_gt]
    data.use_gt = _deserializer.uint32(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += object.shot_size.length;
    return length + 32;
  }

  static datatype() {
    // Returns string type for a service object
    return 'nesfr3_services/FollowActorRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '99227585c2a2e2d95dc78c237396ff04';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    uint32 actor_id
    uint32 robot_id			
    float64 distance	
    float64 angle 		
    string shot_size
    uint32 use_gt
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new FollowActorRequest(null);
    if (msg.actor_id !== undefined) {
      resolved.actor_id = msg.actor_id;
    }
    else {
      resolved.actor_id = 0
    }

    if (msg.robot_id !== undefined) {
      resolved.robot_id = msg.robot_id;
    }
    else {
      resolved.robot_id = 0
    }

    if (msg.distance !== undefined) {
      resolved.distance = msg.distance;
    }
    else {
      resolved.distance = 0.0
    }

    if (msg.angle !== undefined) {
      resolved.angle = msg.angle;
    }
    else {
      resolved.angle = 0.0
    }

    if (msg.shot_size !== undefined) {
      resolved.shot_size = msg.shot_size;
    }
    else {
      resolved.shot_size = ''
    }

    if (msg.use_gt !== undefined) {
      resolved.use_gt = msg.use_gt;
    }
    else {
      resolved.use_gt = 0
    }

    return resolved;
    }
};

class FollowActorResponse {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
    }
    else {
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type FollowActorResponse
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type FollowActorResponse
    let len;
    let data = new FollowActorResponse(null);
    return data;
  }

  static getMessageSize(object) {
    return 0;
  }

  static datatype() {
    // Returns string type for a service object
    return 'nesfr3_services/FollowActorResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return 'd41d8cd98f00b204e9800998ecf8427e';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new FollowActorResponse(null);
    return resolved;
    }
};

module.exports = {
  Request: FollowActorRequest,
  Response: FollowActorResponse,
  md5sum() { return '99227585c2a2e2d95dc78c237396ff04'; },
  datatype() { return 'nesfr3_services/FollowActor'; }
};
