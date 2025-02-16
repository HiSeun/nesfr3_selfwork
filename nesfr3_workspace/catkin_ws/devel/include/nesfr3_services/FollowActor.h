// Generated by gencpp from file nesfr3_services/FollowActor.msg
// DO NOT EDIT!


#ifndef NESFR3_SERVICES_MESSAGE_FOLLOWACTOR_H
#define NESFR3_SERVICES_MESSAGE_FOLLOWACTOR_H

#include <ros/service_traits.h>


#include <nesfr3_services/FollowActorRequest.h>
#include <nesfr3_services/FollowActorResponse.h>


namespace nesfr3_services
{

struct FollowActor
{

typedef FollowActorRequest Request;
typedef FollowActorResponse Response;
Request request;
Response response;

typedef Request RequestType;
typedef Response ResponseType;

}; // struct FollowActor
} // namespace nesfr3_services


namespace ros
{
namespace service_traits
{


template<>
struct MD5Sum< ::nesfr3_services::FollowActor > {
  static const char* value()
  {
    return "99227585c2a2e2d95dc78c237396ff04";
  }

  static const char* value(const ::nesfr3_services::FollowActor&) { return value(); }
};

template<>
struct DataType< ::nesfr3_services::FollowActor > {
  static const char* value()
  {
    return "nesfr3_services/FollowActor";
  }

  static const char* value(const ::nesfr3_services::FollowActor&) { return value(); }
};


// service_traits::MD5Sum< ::nesfr3_services::FollowActorRequest> should match
// service_traits::MD5Sum< ::nesfr3_services::FollowActor >
template<>
struct MD5Sum< ::nesfr3_services::FollowActorRequest>
{
  static const char* value()
  {
    return MD5Sum< ::nesfr3_services::FollowActor >::value();
  }
  static const char* value(const ::nesfr3_services::FollowActorRequest&)
  {
    return value();
  }
};

// service_traits::DataType< ::nesfr3_services::FollowActorRequest> should match
// service_traits::DataType< ::nesfr3_services::FollowActor >
template<>
struct DataType< ::nesfr3_services::FollowActorRequest>
{
  static const char* value()
  {
    return DataType< ::nesfr3_services::FollowActor >::value();
  }
  static const char* value(const ::nesfr3_services::FollowActorRequest&)
  {
    return value();
  }
};

// service_traits::MD5Sum< ::nesfr3_services::FollowActorResponse> should match
// service_traits::MD5Sum< ::nesfr3_services::FollowActor >
template<>
struct MD5Sum< ::nesfr3_services::FollowActorResponse>
{
  static const char* value()
  {
    return MD5Sum< ::nesfr3_services::FollowActor >::value();
  }
  static const char* value(const ::nesfr3_services::FollowActorResponse&)
  {
    return value();
  }
};

// service_traits::DataType< ::nesfr3_services::FollowActorResponse> should match
// service_traits::DataType< ::nesfr3_services::FollowActor >
template<>
struct DataType< ::nesfr3_services::FollowActorResponse>
{
  static const char* value()
  {
    return DataType< ::nesfr3_services::FollowActor >::value();
  }
  static const char* value(const ::nesfr3_services::FollowActorResponse&)
  {
    return value();
  }
};

} // namespace service_traits
} // namespace ros

#endif // NESFR3_SERVICES_MESSAGE_FOLLOWACTOR_H
