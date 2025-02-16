// Generated by gencpp from file nesfr3_services/FollowActorRequest.msg
// DO NOT EDIT!


#ifndef NESFR3_SERVICES_MESSAGE_FOLLOWACTORREQUEST_H
#define NESFR3_SERVICES_MESSAGE_FOLLOWACTORREQUEST_H


#include <string>
#include <vector>
#include <map>

#include <ros/types.h>
#include <ros/serialization.h>
#include <ros/builtin_message_traits.h>
#include <ros/message_operations.h>


namespace nesfr3_services
{
template <class ContainerAllocator>
struct FollowActorRequest_
{
  typedef FollowActorRequest_<ContainerAllocator> Type;

  FollowActorRequest_()
    : actor_id(0)
    , robot_id(0)
    , distance(0.0)
    , angle(0.0)
    , shot_size()
    , use_gt(0)  {
    }
  FollowActorRequest_(const ContainerAllocator& _alloc)
    : actor_id(0)
    , robot_id(0)
    , distance(0.0)
    , angle(0.0)
    , shot_size(_alloc)
    , use_gt(0)  {
  (void)_alloc;
    }



   typedef uint32_t _actor_id_type;
  _actor_id_type actor_id;

   typedef uint32_t _robot_id_type;
  _robot_id_type robot_id;

   typedef double _distance_type;
  _distance_type distance;

   typedef double _angle_type;
  _angle_type angle;

   typedef std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other >  _shot_size_type;
  _shot_size_type shot_size;

   typedef uint32_t _use_gt_type;
  _use_gt_type use_gt;





  typedef boost::shared_ptr< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> > Ptr;
  typedef boost::shared_ptr< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> const> ConstPtr;

}; // struct FollowActorRequest_

typedef ::nesfr3_services::FollowActorRequest_<std::allocator<void> > FollowActorRequest;

typedef boost::shared_ptr< ::nesfr3_services::FollowActorRequest > FollowActorRequestPtr;
typedef boost::shared_ptr< ::nesfr3_services::FollowActorRequest const> FollowActorRequestConstPtr;

// constants requiring out of line definition



template<typename ContainerAllocator>
std::ostream& operator<<(std::ostream& s, const ::nesfr3_services::FollowActorRequest_<ContainerAllocator> & v)
{
ros::message_operations::Printer< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >::stream(s, "", v);
return s;
}


template<typename ContainerAllocator1, typename ContainerAllocator2>
bool operator==(const ::nesfr3_services::FollowActorRequest_<ContainerAllocator1> & lhs, const ::nesfr3_services::FollowActorRequest_<ContainerAllocator2> & rhs)
{
  return lhs.actor_id == rhs.actor_id &&
    lhs.robot_id == rhs.robot_id &&
    lhs.distance == rhs.distance &&
    lhs.angle == rhs.angle &&
    lhs.shot_size == rhs.shot_size &&
    lhs.use_gt == rhs.use_gt;
}

template<typename ContainerAllocator1, typename ContainerAllocator2>
bool operator!=(const ::nesfr3_services::FollowActorRequest_<ContainerAllocator1> & lhs, const ::nesfr3_services::FollowActorRequest_<ContainerAllocator2> & rhs)
{
  return !(lhs == rhs);
}


} // namespace nesfr3_services

namespace ros
{
namespace message_traits
{





template <class ContainerAllocator>
struct IsFixedSize< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct IsFixedSize< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> const>
  : FalseType
  { };

template <class ContainerAllocator>
struct IsMessage< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
  : TrueType
  { };

template <class ContainerAllocator>
struct IsMessage< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> const>
  : TrueType
  { };

template <class ContainerAllocator>
struct HasHeader< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
  : FalseType
  { };

template <class ContainerAllocator>
struct HasHeader< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> const>
  : FalseType
  { };


template<class ContainerAllocator>
struct MD5Sum< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
{
  static const char* value()
  {
    return "99227585c2a2e2d95dc78c237396ff04";
  }

  static const char* value(const ::nesfr3_services::FollowActorRequest_<ContainerAllocator>&) { return value(); }
  static const uint64_t static_value1 = 0x99227585c2a2e2d9ULL;
  static const uint64_t static_value2 = 0x5dc78c237396ff04ULL;
};

template<class ContainerAllocator>
struct DataType< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
{
  static const char* value()
  {
    return "nesfr3_services/FollowActorRequest";
  }

  static const char* value(const ::nesfr3_services::FollowActorRequest_<ContainerAllocator>&) { return value(); }
};

template<class ContainerAllocator>
struct Definition< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
{
  static const char* value()
  {
    return "uint32 actor_id\n"
"uint32 robot_id			\n"
"float64 distance	\n"
"float64 angle 		\n"
"string shot_size\n"
"uint32 use_gt\n"
;
  }

  static const char* value(const ::nesfr3_services::FollowActorRequest_<ContainerAllocator>&) { return value(); }
};

} // namespace message_traits
} // namespace ros

namespace ros
{
namespace serialization
{

  template<class ContainerAllocator> struct Serializer< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
  {
    template<typename Stream, typename T> inline static void allInOne(Stream& stream, T m)
    {
      stream.next(m.actor_id);
      stream.next(m.robot_id);
      stream.next(m.distance);
      stream.next(m.angle);
      stream.next(m.shot_size);
      stream.next(m.use_gt);
    }

    ROS_DECLARE_ALLINONE_SERIALIZER
  }; // struct FollowActorRequest_

} // namespace serialization
} // namespace ros

namespace ros
{
namespace message_operations
{

template<class ContainerAllocator>
struct Printer< ::nesfr3_services::FollowActorRequest_<ContainerAllocator> >
{
  template<typename Stream> static void stream(Stream& s, const std::string& indent, const ::nesfr3_services::FollowActorRequest_<ContainerAllocator>& v)
  {
    s << indent << "actor_id: ";
    Printer<uint32_t>::stream(s, indent + "  ", v.actor_id);
    s << indent << "robot_id: ";
    Printer<uint32_t>::stream(s, indent + "  ", v.robot_id);
    s << indent << "distance: ";
    Printer<double>::stream(s, indent + "  ", v.distance);
    s << indent << "angle: ";
    Printer<double>::stream(s, indent + "  ", v.angle);
    s << indent << "shot_size: ";
    Printer<std::basic_string<char, std::char_traits<char>, typename ContainerAllocator::template rebind<char>::other > >::stream(s, indent + "  ", v.shot_size);
    s << indent << "use_gt: ";
    Printer<uint32_t>::stream(s, indent + "  ", v.use_gt);
  }
};

} // namespace message_operations
} // namespace ros

#endif // NESFR3_SERVICES_MESSAGE_FOLLOWACTORREQUEST_H
