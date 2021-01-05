/*
 * Copyright (C) 2016 Open Source Robotics Foundation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
*/


#include <gazebo/gazebo.hh>
#include <gazebo/common/common.hh>
#include <ignition/math/Vector3.hh>
#include <ros/ros.h>
#include <geometry_msgs/Point.h>
#include <nesfr3_msgs/Actor.h>

#include <string>
#include <iostream>
#include <functional>
#include <ignition/math.hh>
#include "gazebo/physics/physics.hh"
#include "nesfr3_gazebo/actor_plugin.hh"
#include <nav_msgs/Odometry.h>

#include <tf2/LinearMath/Quaternion.h>


using namespace gazebo;
GZ_REGISTER_MODEL_PLUGIN(ActorPlugin)

#define WALKING_ANIMATION "walking"
#define actor_z 1.0138


/////////////////////////////////////////////////
ActorPlugin::ActorPlugin()
{
}

/////////////////////////////////////////////////
void ActorPlugin::Load(physics::ModelPtr _model, sdf::ElementPtr _sdf)
{

  this->sdf = _sdf;
  this->actor = boost::dynamic_pointer_cast<physics::Actor>(_model);
  this->world = this->actor->GetWorld();

  this->connections.push_back(event::Events::ConnectWorldUpdateBegin(
          std::bind(&ActorPlugin::OnUpdate, this, std::placeholders::_1)));


  

  this->fixed_direction = false;
  this->fixed_angle = false;



  this->Reset();

  if (_sdf->HasElement("x_lower"))
    this->x_lower = _sdf->Get<double>("x_lower");
  else
    this->x_lower = -22;

  if (_sdf->HasElement("x_upper"))
    this->x_upper = _sdf->Get<double>("x_upper");
  else
    this->x_upper = 17;

  if (_sdf->HasElement("y_lower"))
    this->y_lower = _sdf->Get<double>("y_lower");
  else
    this->y_lower = -18;

  if (_sdf->HasElement("y_upper"))
    this->y_upper = _sdf->Get<double>("y_upper");
  else
    this->y_upper = 6;
  


  // Read in the target weight
  if (_sdf->HasElement("target_weight"))
    this->targetWeight = _sdf->Get<double>("target_weight");
  else
    this->targetWeight = 1.15;

  // Read in the obstacle weight
  if (_sdf->HasElement("obstacle_weight"))
    this->obstacleWeight = _sdf->Get<double>("obstacle_weight");
  else
    this->obstacleWeight = 1.5;

  // Read in the animation factor (applied in the OnUpdate function).
  if (_sdf->HasElement("animation_factor"))
    this->animationFactor = _sdf->Get<double>("animation_factor");
  else
    this->animationFactor = 4.5;


  if (_sdf->HasElement("robots_to_ignore"))
    this->robots_to_ignore = _sdf->Get<int>("robots_to_ignore");
  else
    this->robots_to_ignore = 0;

  for (uint32_t i = 1; i <= this->robots_to_ignore; i++)
    this->ignoreModels.push_back("nesfr3_" + std::to_string(i));


  // Add our own name to models we should ignore when avoiding obstacles.
  this->ignoreModels.push_back(this->actor->GetName());

  // Read in the other obstacles to ignore
  if (_sdf->HasElement("ignore_obstacles"))
  {
    sdf::ElementPtr modelElem =
      _sdf->GetElement("ignore_obstacles")->GetElement("model");
    while (modelElem)
    {
      this->ignoreModels.push_back(modelElem->Get<std::string>());
      modelElem = modelElem->GetNextElement("model");
    }
  }

  for (uint32_t i = 0; i < this->world->ModelCount(); ++i)
  {
    physics::ModelPtr model = this->world->ModelByIndex(i);
  }
  

  this->nh_ = new ros::NodeHandle();

  if (_sdf->HasElement("id"))
    this->id = _sdf->Get<int>("id");
  else
    this->id = 1;
  
  this->msg_pub = this->nh_->advertise<nesfr3_msgs::Actor>("/gazebo/Actor/" + std::to_string(this->id), 1);
}


/////////////////////////////////////////////////
void ActorPlugin::Reset()
{
  this->velocity = 0.8;
  this->lastUpdate = 0;


  if (this->sdf && this->sdf->HasElement("target"))
    this->target = this->sdf->Get<ignition::math::Vector3d>("target");
  else
    this->target = ignition::math::Vector3d(0, -5, actor_z);

  auto skelAnims = this->actor->SkeletonAnimations();
  if (skelAnims.find(WALKING_ANIMATION) == skelAnims.end())
  {
    gzerr << "Skeleton animation " << WALKING_ANIMATION << " not found.\n";
  }
  else
  {
    // Create custom trajectory
    this->trajectoryInfo.reset(new physics::TrajectoryInfo());
    this->trajectoryInfo->type = WALKING_ANIMATION;
    this->trajectoryInfo->duration = 1.0;

    this->actor->SetCustomTrajectory(this->trajectoryInfo);
  }
}

/////////////////////////////////////////////////
void ActorPlugin::ChooseNewTarget()
{
  ignition::math::Vector3d newTarget(this->target);
  while ((newTarget - this->target).Length() < 2.0)
  {
    newTarget.X(ignition::math::Rand::DblUniform(this->x_lower + 1, this->x_upper - 1)); 
    newTarget.Y(ignition::math::Rand::DblUniform(this->y_lower + 1, this->y_upper - 1));
    newTarget.Z(actor_z);

    for (unsigned int i = 0; i < this->world->ModelCount(); ++i) // we don't want models to be close to the new target
    {

      ignition::math::Vector3d diff_vector = this->world->ModelByIndex(i)->WorldPose().Pos() - newTarget;

      diff_vector.Z() = 0;

      double dist = diff_vector.Length();
      if (dist < 2.0)
      {
        newTarget = this->target;
        break;
      }
    }
  }
  this->target = newTarget;
}

/////////////////////////////////////////////////
void ActorPlugin::HandleObstacles(ignition::math::Vector3d &_pos)
{
  for (unsigned int i = 0; i < this->world->ModelCount(); ++i)
  {
    physics::ModelPtr model = this->world->ModelByIndex(i);
    if (std::find(this->ignoreModels.begin(), this->ignoreModels.end(),
          model->GetName()) == this->ignoreModels.end())
    {
      ignition::math::Vector3d offset = model->WorldPose().Pos() -
        this->actor->WorldPose().Pos();

      offset.Z() = 0;

      double modelDist = offset.Length();
      if (modelDist < 3.0)
      {
        double invModelDist = this->obstacleWeight / modelDist;

        offset.Normalize();
        offset *= invModelDist;
        _pos -= offset;
      }
    }
  }
}




  
  



/////////////////////////////////////////////////
void ActorPlugin::OnUpdate(const common::UpdateInfo &_info)
{
  // Time delta
  double dt = (_info.simTime - this->lastUpdate).Double();

  if (dt < 0)
    dt = 0;

  ignition::math::Pose3d pose = this->actor->WorldPose();
  ignition::math::Vector3d pos = this->target - pose.Pos();
  ignition::math::Vector3d rpy = pose.Rot().Euler();


  double distance = pos.Length();

  // Choose a new target position if the actor has reached its current
  // target.
  if (distance < 0.3)  
  {
    this->ChooseNewTarget();
    pos = this->target - pose.Pos();
  }

  // Normalize the direction vector, and apply the target weight
  pos = pos.Normalize() * this->targetWeight;

  // Adjust the direction vector by avoiding obstacles
  this->HandleObstacles(pos);

  pos.Normalize();

  // Compute the yaw orientation

  //the idea is that when a wide turn is need to be made(> 10 degrees), it is done and the actor walks straight for at least 0.5 sec 
  //so that he doesn't start turning again in a different direction and gets stuck turning back and forth


  //0.5sec is short enough so that the actor shouldn't hit anything as (the turning time + 0.5sec) is not enough time for something to get in the way
  if (!this->fixed_angle)
  {
    if (this->fixed_direction && ((_info.simTime - this->fixed_direction_time).Double() > 0.5 || (_info.simTime - this->fixed_direction_time).sec < 0))
      this->fixed_direction = false;

    if (this->fixed_direction)
    {
      ignition::math::Vector3d forward_vector(sin(rpy.Z()), -cos(rpy.Z()), 0);
      pose.Pos() += forward_vector * this->velocity * dt;
    
    } else {

      ignition::math::Angle yaw = atan2(pos.Y(), pos.X()) + M_PI/2 - rpy.Z();
      yaw.Normalize();

      if (std::abs(yaw.Radian()) > IGN_DTOR(10))
      {
        this->desirable_yaw = (atan2(pos.Y(), pos.X()) + M_PI/2);
        this->fixed_angle = true;
      
        pose.Rot() = ignition::math::Quaterniond(M_PI/2, 0, rpy.Z()+
          yaw.Radian() * 0.01); 
      } else {
          pose.Pos() += pos * this->velocity * dt;
          pose.Rot() = ignition::math::Quaterniond(M_PI/2, 0, rpy.Z()+yaw.Radian());
      }
    
    }

  } else { // angle is fixed
    ignition::math::Angle yaw = this->desirable_yaw - rpy.Z();

    yaw.Normalize();

    if (std::abs(yaw.Radian()) > IGN_DTOR(10))
    {
      pose.Rot() = ignition::math::Quaterniond(M_PI/2, 0, rpy.Z()+
        yaw.Radian() * 0.01); 
    } else { //rotated enough, now it's time to walk in this direction instead of turning somewhere again
      this->fixed_angle = false;
      this->fixed_direction = true;
      this->fixed_direction_time = _info.simTime;

      ignition::math::Vector3d forward_vector(sin(rpy.Z()), -cos(rpy.Z()), 0);
      pose.Pos() += forward_vector * this->velocity * dt;

    }
  } 


  // Make sure the actor stays within bounds
  pose.Pos().X(std::max(this->x_lower, std::min(this->x_upper, pose.Pos().X())));
  pose.Pos().Y(std::max(this->y_lower, std::min(this->y_upper, pose.Pos().Y())));
  pose.Pos().Z(actor_z);

  // Distance traveled is used to coordinate motion with the walking
  // animation
  

  double distanceTraveled = (pose.Pos() -
      this->actor->WorldPose().Pos()).Length();

  this->actor->SetWorldPose(pose, false, false);
  this->actor->SetScriptTime(this->actor->ScriptTime() +
    (distanceTraveled * this->animationFactor));
  this->lastUpdate = _info.simTime;


  this->Publish();

}

// publishes the 17 points of the actor
void ActorPlugin::Publish() 
{
  nesfr3_msgs::Actor msg;

  msg.header.frame_id = "/nesfr3/1/map";
  msg.header.stamp = ros::Time::now();
  msg.tracking_id = this->id;
  msg.name = this->actor->GetName();

  auto links = this->actor->GetLinks();
  auto link_pose = links[0];

  msg.pose.pose.position.x = link_pose->WorldPose().Pos().X();
  msg.pose.pose.position.y = link_pose->WorldPose().Pos().Y();
  msg.pose.pose.position.z = link_pose->WorldPose().Pos().Z();

  msg.pose.pose.orientation.x = this->actor->WorldPose().Rot().X();
  msg.pose.pose.orientation.y = this->actor->WorldPose().Rot().Y();
  msg.pose.pose.orientation.z = this->actor->WorldPose().Rot().Z();
  msg.pose.pose.orientation.w = this->actor->WorldPose().Rot().W();

  for (int i = 0; i < msg.pose.covariance.size(); i++) {
    msg.pose.covariance[i] = 0;
  }

  for (int i = 0; i < msg.points.size(); i++) {
    msg.points[i].confidence = 1.0;
  }

  this->ExtractData(&msg.points[0].point, "mixamorig_Nose");

  this->ExtractData(&msg.points[1].point, "mixamorig_LeftEye");
  this->ExtractData(&msg.points[2].point, "mixamorig_RightEye");

  this->ExtractData(&msg.points[3].point, "mixamorig_LeftEar");
  this->ExtractData(&msg.points[4].point, "mixamorig_RightEar");

  this->ExtractData(&msg.points[5].point, "mixamorig_LeftArm");
  this->ExtractData(&msg.points[6].point, "mixamorig_RightArm");

  this->ExtractData(&msg.points[7].point, "mixamorig_LeftForeArm");
  this->ExtractData(&msg.points[8].point, "mixamorig_RightForeArm");

  this->ExtractData(&msg.points[9].point, "mixamorig_LeftHand");
  this->ExtractData(&msg.points[10].point, "mixamorig_RightHand");

  this->ExtractData(&msg.points[11].point, "mixamorig_LeftUpLeg");
  this->ExtractData(&msg.points[12].point, "mixamorig_RightUpLeg");

  this->ExtractData(&msg.points[13].point, "mixamorig_LeftLeg");
  this->ExtractData(&msg.points[14].point, "mixamorig_RightLeg");

  this->ExtractData(&msg.points[15].point, "mixamorig_LeftFoot");
  this->ExtractData(&msg.points[16].point, "mixamorig_RightFoot");

  this->msg_pub.publish(msg);
}

inline void ActorPlugin::ExtractData(auto *msg_point, std::string name)
{
  auto link = this->actor->GetLink(name);
  if (link)
  {
    msg_point->x = link->WorldPose().Pos().X();
    msg_point->y = link->WorldPose().Pos().Y();
    msg_point->z = link->WorldPose().Pos().Z();
  }
}
