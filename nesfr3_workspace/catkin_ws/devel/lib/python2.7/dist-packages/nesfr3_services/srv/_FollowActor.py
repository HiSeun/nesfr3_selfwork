# This Python file uses the following encoding: utf-8
"""autogenerated by genpy from nesfr3_services/FollowActorRequest.msg. Do not edit."""
import codecs
import sys
python3 = True if sys.hexversion > 0x03000000 else False
import genpy
import struct


class FollowActorRequest(genpy.Message):
  _md5sum = "99227585c2a2e2d95dc78c237396ff04"
  _type = "nesfr3_services/FollowActorRequest"
  _has_header = False  # flag to mark the presence of a Header object
  _full_text = """uint32 actor_id
uint32 robot_id			
float64 distance	
float64 angle 		
string shot_size
uint32 use_gt
"""
  __slots__ = ['actor_id','robot_id','distance','angle','shot_size','use_gt']
  _slot_types = ['uint32','uint32','float64','float64','string','uint32']

  def __init__(self, *args, **kwds):
    """
    Constructor. Any message fields that are implicitly/explicitly
    set to None will be assigned a default value. The recommend
    use is keyword arguments as this is more robust to future message
    changes.  You cannot mix in-order arguments and keyword arguments.

    The available fields are:
       actor_id,robot_id,distance,angle,shot_size,use_gt

    :param args: complete set of field values, in .msg order
    :param kwds: use keyword arguments corresponding to message field names
    to set specific fields.
    """
    if args or kwds:
      super(FollowActorRequest, self).__init__(*args, **kwds)
      # message fields cannot be None, assign default values for those that are
      if self.actor_id is None:
        self.actor_id = 0
      if self.robot_id is None:
        self.robot_id = 0
      if self.distance is None:
        self.distance = 0.
      if self.angle is None:
        self.angle = 0.
      if self.shot_size is None:
        self.shot_size = ''
      if self.use_gt is None:
        self.use_gt = 0
    else:
      self.actor_id = 0
      self.robot_id = 0
      self.distance = 0.
      self.angle = 0.
      self.shot_size = ''
      self.use_gt = 0

  def _get_types(self):
    """
    internal API method
    """
    return self._slot_types

  def serialize(self, buff):
    """
    serialize message into buffer
    :param buff: buffer, ``StringIO``
    """
    try:
      _x = self
      buff.write(_get_struct_2I2d().pack(_x.actor_id, _x.robot_id, _x.distance, _x.angle))
      _x = self.shot_size
      length = len(_x)
      if python3 or type(_x) == unicode:
        _x = _x.encode('utf-8')
        length = len(_x)
      buff.write(struct.Struct('<I%ss'%length).pack(length, _x))
      _x = self.use_gt
      buff.write(_get_struct_I().pack(_x))
    except struct.error as se: self._check_types(struct.error("%s: '%s' when writing '%s'" % (type(se), str(se), str(locals().get('_x', self)))))
    except TypeError as te: self._check_types(ValueError("%s: '%s' when writing '%s'" % (type(te), str(te), str(locals().get('_x', self)))))

  def deserialize(self, str):
    """
    unpack serialized message in str into this message instance
    :param str: byte array of serialized message, ``str``
    """
    codecs.lookup_error("rosmsg").msg_type = self._type
    try:
      end = 0
      _x = self
      start = end
      end += 24
      (_x.actor_id, _x.robot_id, _x.distance, _x.angle,) = _get_struct_2I2d().unpack(str[start:end])
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      start = end
      end += length
      if python3:
        self.shot_size = str[start:end].decode('utf-8', 'rosmsg')
      else:
        self.shot_size = str[start:end]
      start = end
      end += 4
      (self.use_gt,) = _get_struct_I().unpack(str[start:end])
      return self
    except struct.error as e:
      raise genpy.DeserializationError(e)  # most likely buffer underfill


  def serialize_numpy(self, buff, numpy):
    """
    serialize message with numpy array types into buffer
    :param buff: buffer, ``StringIO``
    :param numpy: numpy python module
    """
    try:
      _x = self
      buff.write(_get_struct_2I2d().pack(_x.actor_id, _x.robot_id, _x.distance, _x.angle))
      _x = self.shot_size
      length = len(_x)
      if python3 or type(_x) == unicode:
        _x = _x.encode('utf-8')
        length = len(_x)
      buff.write(struct.Struct('<I%ss'%length).pack(length, _x))
      _x = self.use_gt
      buff.write(_get_struct_I().pack(_x))
    except struct.error as se: self._check_types(struct.error("%s: '%s' when writing '%s'" % (type(se), str(se), str(locals().get('_x', self)))))
    except TypeError as te: self._check_types(ValueError("%s: '%s' when writing '%s'" % (type(te), str(te), str(locals().get('_x', self)))))

  def deserialize_numpy(self, str, numpy):
    """
    unpack serialized message in str into this message instance using numpy for array types
    :param str: byte array of serialized message, ``str``
    :param numpy: numpy python module
    """
    codecs.lookup_error("rosmsg").msg_type = self._type
    try:
      end = 0
      _x = self
      start = end
      end += 24
      (_x.actor_id, _x.robot_id, _x.distance, _x.angle,) = _get_struct_2I2d().unpack(str[start:end])
      start = end
      end += 4
      (length,) = _struct_I.unpack(str[start:end])
      start = end
      end += length
      if python3:
        self.shot_size = str[start:end].decode('utf-8', 'rosmsg')
      else:
        self.shot_size = str[start:end]
      start = end
      end += 4
      (self.use_gt,) = _get_struct_I().unpack(str[start:end])
      return self
    except struct.error as e:
      raise genpy.DeserializationError(e)  # most likely buffer underfill

_struct_I = genpy.struct_I
def _get_struct_I():
    global _struct_I
    return _struct_I
_struct_2I2d = None
def _get_struct_2I2d():
    global _struct_2I2d
    if _struct_2I2d is None:
        _struct_2I2d = struct.Struct("<2I2d")
    return _struct_2I2d
# This Python file uses the following encoding: utf-8
"""autogenerated by genpy from nesfr3_services/FollowActorResponse.msg. Do not edit."""
import codecs
import sys
python3 = True if sys.hexversion > 0x03000000 else False
import genpy
import struct


class FollowActorResponse(genpy.Message):
  _md5sum = "d41d8cd98f00b204e9800998ecf8427e"
  _type = "nesfr3_services/FollowActorResponse"
  _has_header = False  # flag to mark the presence of a Header object
  _full_text = """"""
  __slots__ = []
  _slot_types = []

  def __init__(self, *args, **kwds):
    """
    Constructor. Any message fields that are implicitly/explicitly
    set to None will be assigned a default value. The recommend
    use is keyword arguments as this is more robust to future message
    changes.  You cannot mix in-order arguments and keyword arguments.

    The available fields are:
       

    :param args: complete set of field values, in .msg order
    :param kwds: use keyword arguments corresponding to message field names
    to set specific fields.
    """
    if args or kwds:
      super(FollowActorResponse, self).__init__(*args, **kwds)

  def _get_types(self):
    """
    internal API method
    """
    return self._slot_types

  def serialize(self, buff):
    """
    serialize message into buffer
    :param buff: buffer, ``StringIO``
    """
    try:
      pass
    except struct.error as se: self._check_types(struct.error("%s: '%s' when writing '%s'" % (type(se), str(se), str(locals().get('_x', self)))))
    except TypeError as te: self._check_types(ValueError("%s: '%s' when writing '%s'" % (type(te), str(te), str(locals().get('_x', self)))))

  def deserialize(self, str):
    """
    unpack serialized message in str into this message instance
    :param str: byte array of serialized message, ``str``
    """
    codecs.lookup_error("rosmsg").msg_type = self._type
    try:
      end = 0
      return self
    except struct.error as e:
      raise genpy.DeserializationError(e)  # most likely buffer underfill


  def serialize_numpy(self, buff, numpy):
    """
    serialize message with numpy array types into buffer
    :param buff: buffer, ``StringIO``
    :param numpy: numpy python module
    """
    try:
      pass
    except struct.error as se: self._check_types(struct.error("%s: '%s' when writing '%s'" % (type(se), str(se), str(locals().get('_x', self)))))
    except TypeError as te: self._check_types(ValueError("%s: '%s' when writing '%s'" % (type(te), str(te), str(locals().get('_x', self)))))

  def deserialize_numpy(self, str, numpy):
    """
    unpack serialized message in str into this message instance using numpy for array types
    :param str: byte array of serialized message, ``str``
    :param numpy: numpy python module
    """
    codecs.lookup_error("rosmsg").msg_type = self._type
    try:
      end = 0
      return self
    except struct.error as e:
      raise genpy.DeserializationError(e)  # most likely buffer underfill

_struct_I = genpy.struct_I
def _get_struct_I():
    global _struct_I
    return _struct_I
class FollowActor(object):
  _type          = 'nesfr3_services/FollowActor'
  _md5sum = '99227585c2a2e2d95dc78c237396ff04'
  _request_class  = FollowActorRequest
  _response_class = FollowActorResponse
