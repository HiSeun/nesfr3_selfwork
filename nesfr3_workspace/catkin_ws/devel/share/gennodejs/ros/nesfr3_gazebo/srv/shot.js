// Auto-generated. Do not edit!

// (in-package nesfr3_gazebo.srv)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------

let sensor_msgs = _finder('sensor_msgs');

//-----------------------------------------------------------

class shotRequest {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.human_id = null;
      this.distance = null;
      this.direction = null;
      this.shot_size = null;
    }
    else {
      if (initObj.hasOwnProperty('human_id')) {
        this.human_id = initObj.human_id
      }
      else {
        this.human_id = 0;
      }
      if (initObj.hasOwnProperty('distance')) {
        this.distance = initObj.distance
      }
      else {
        this.distance = 0.0;
      }
      if (initObj.hasOwnProperty('direction')) {
        this.direction = initObj.direction
      }
      else {
        this.direction = new geometry_msgs.msg.Vector3();
      }
      if (initObj.hasOwnProperty('shot_size')) {
        this.shot_size = initObj.shot_size
      }
      else {
        this.shot_size = '';
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type shotRequest
    // Serialize message field [human_id]
    bufferOffset = _serializer.int64(obj.human_id, buffer, bufferOffset);
    // Serialize message field [distance]
    bufferOffset = _serializer.float64(obj.distance, buffer, bufferOffset);
    // Serialize message field [direction]
    bufferOffset = geometry_msgs.msg.Vector3.serialize(obj.direction, buffer, bufferOffset);
    // Serialize message field [shot_size]
    bufferOffset = _serializer.string(obj.shot_size, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type shotRequest
    let len;
    let data = new shotRequest(null);
    // Deserialize message field [human_id]
    data.human_id = _deserializer.int64(buffer, bufferOffset);
    // Deserialize message field [distance]
    data.distance = _deserializer.float64(buffer, bufferOffset);
    // Deserialize message field [direction]
    data.direction = geometry_msgs.msg.Vector3.deserialize(buffer, bufferOffset);
    // Deserialize message field [shot_size]
    data.shot_size = _deserializer.string(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += object.shot_size.length;
    return length + 44;
  }

  static datatype() {
    // Returns string type for a service object
    return 'nesfr3_gazebo/shotRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '0eb907bc5a14eb6290a41494f46426a4';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    int64 human_id
    float64 distance
    geometry_msgs/Vector3 direction
    string shot_size
    
    
    ================================================================================
    MSG: geometry_msgs/Vector3
    # This represents a vector in free space. 
    # It is only meant to represent a direction. Therefore, it does not
    # make sense to apply a translation to it (e.g., when applying a 
    # generic rigid transformation to a Vector3, tf2 will only apply the
    # rotation). If you want your data to be translatable too, use the
    # geometry_msgs/Point message instead.
    
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
    const resolved = new shotRequest(null);
    if (msg.human_id !== undefined) {
      resolved.human_id = msg.human_id;
    }
    else {
      resolved.human_id = 0
    }

    if (msg.distance !== undefined) {
      resolved.distance = msg.distance;
    }
    else {
      resolved.distance = 0.0
    }

    if (msg.direction !== undefined) {
      resolved.direction = geometry_msgs.msg.Vector3.Resolve(msg.direction)
    }
    else {
      resolved.direction = new geometry_msgs.msg.Vector3()
    }

    if (msg.shot_size !== undefined) {
      resolved.shot_size = msg.shot_size;
    }
    else {
      resolved.shot_size = ''
    }

    return resolved;
    }
};

class shotResponse {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.shot = null;
    }
    else {
      if (initObj.hasOwnProperty('shot')) {
        this.shot = initObj.shot
      }
      else {
        this.shot = new sensor_msgs.msg.Image();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type shotResponse
    // Serialize message field [shot]
    bufferOffset = sensor_msgs.msg.Image.serialize(obj.shot, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type shotResponse
    let len;
    let data = new shotResponse(null);
    // Deserialize message field [shot]
    data.shot = sensor_msgs.msg.Image.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += sensor_msgs.msg.Image.getMessageSize(object.shot);
    return length;
  }

  static datatype() {
    // Returns string type for a service object
    return 'nesfr3_gazebo/shotResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '14466610b979205befadf9c3c1ba0c1a';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    
    sensor_msgs/Image shot
    
    
    
    
    ================================================================================
    MSG: sensor_msgs/Image
    # This message contains an uncompressed image
    # (0, 0) is at top-left corner of image
    #
    
    Header header        # Header timestamp should be acquisition time of image
                         # Header frame_id should be optical frame of camera
                         # origin of frame should be optical center of camera
                         # +x should point to the right in the image
                         # +y should point down in the image
                         # +z should point into to plane of the image
                         # If the frame_id here and the frame_id of the CameraInfo
                         # message associated with the image conflict
                         # the behavior is undefined
    
    uint32 height         # image height, that is, number of rows
    uint32 width          # image width, that is, number of columns
    
    # The legal values for encoding are in file src/image_encodings.cpp
    # If you want to standardize a new string format, join
    # ros-users@lists.sourceforge.net and send an email proposing a new encoding.
    
    string encoding       # Encoding of pixels -- channel meaning, ordering, size
                          # taken from the list of strings in include/sensor_msgs/image_encodings.h
    
    uint8 is_bigendian    # is this data bigendian?
    uint32 step           # Full row length in bytes
    uint8[] data          # actual matrix data, size is (step * rows)
    
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
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new shotResponse(null);
    if (msg.shot !== undefined) {
      resolved.shot = sensor_msgs.msg.Image.Resolve(msg.shot)
    }
    else {
      resolved.shot = new sensor_msgs.msg.Image()
    }

    return resolved;
    }
};

module.exports = {
  Request: shotRequest,
  Response: shotResponse,
  md5sum() { return '635e9215bafe4f59d545a92d1d2ef52b'; },
  datatype() { return 'nesfr3_gazebo/shot'; }
};
