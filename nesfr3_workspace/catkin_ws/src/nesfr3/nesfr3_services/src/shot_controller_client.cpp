#include "ros/ros.h"
#include "nesfr3_services/FollowActor.h"

int main(int argc, char **argv)
{
  ros::init(argc, argv, "shot_controller_client");


  if (argc != 7)
  {
    ROS_INFO("Usage: rosrun nesfr3_services shot_controller_client actor_id robot_id distance angle shot_size use_gt");
    return 1;
  }

  ros::NodeHandle n;
  nesfr3_services::FollowActor srv;

  uint32_t robot_id = atoi(argv[2]);

  srv.request.actor_id = atoi(argv[1]);
  srv.request.robot_id = robot_id;
  srv.request.distance = std::stod(argv[3]);
  srv.request.angle = std::stod(argv[4]);
  srv.request.shot_size = argv[5];
  srv.request.use_gt = atoi(argv[6]);

  ros::ServiceClient client = n.serviceClient<nesfr3_services::FollowActor>("nesfr3/" + std::to_string(robot_id) + "/shot_cmd");

  if (srv.request.shot_size != "FS" && srv.request.shot_size != "MFS" 
    && srv.request.shot_size != "MS" && srv.request.shot_size != "MCU" 
    && srv.request.shot_size != "CU" && srv.request.shot_size != "ECU")
  {
    ROS_ERROR("Please choose shot_size to be one of FS, MFS, MS, MCU, CU, or ECU.");
    return 1;
  }

  if (client.call(srv))
  {
    ROS_INFO("Ok");
  }
  else
  {
    ROS_ERROR("Error");
    return 1;
  }

  return 0;
}