#include <OGRE/OgreVector3.h>
#include <OGRE/OgreSceneNode.h>
#include <OGRE/OgreSceneManager.h>

#include <rviz/ogre_helpers/arrow.h>
#include <rviz/ogre_helpers/billboard_line.h>
#include <rviz/ogre_helpers/movable_text.h>

#include "actor_visual.h"

#include <tf2_geometry_msgs/tf2_geometry_msgs.h>

#include <array>


namespace nesfr3_rviz_plugins
{

// BEGIN
ActorVisual::ActorVisual( Ogre::SceneManager* scene_manager, Ogre::SceneNode* parent_node )
{
  scene_manager_ = scene_manager;

  // Ogre::SceneNode s form a tree, with each node storing the
  // transform (position and orientation) of itself relative to its
  // parent.  Ogre does the math of combining those transforms when it
  // is time to render.
  //
  // Here we create a node to store the pose of the Actor's header frame
  // relative to the RViz fixed frame.
  frame_node_ = parent_node->createChildSceneNode();

  // We create the arrow object within the frame node so that we can
  // set its position and direction relative to its header frame.
  arrow.reset(new rviz::Arrow( scene_manager_, frame_node_ ));

  left_body.reset(new rviz::BillboardLine( scene_manager_, frame_node_ ));
  left_body->setLineWidth(0.01f);
  left_body->setColor(0.0f, 1.0f, 0.0f, 1.0f);

  right_body.reset(new rviz::BillboardLine( scene_manager_, frame_node_ ));
  right_body->setLineWidth(0.01f);
  right_body->setColor(0.0f, 1.0f, 0.0f, 1.0f);

  shoulders.reset(new rviz::BillboardLine( scene_manager_, frame_node_ ));
  shoulders->setLineWidth(0.01f);
  shoulders->setColor(0.0f, 1.0f, 0.0f, 1.0f);

  face.reset(new rviz::BillboardLine( scene_manager_, frame_node_ ));
  face->setLineWidth(0.01f);
  face->setColor(0.0f, 1.0f, 0.0f, 1.0f);

  left_body_points = {5,7,9,11,13,15};
  right_body_points = {6,8,10,12,14,16};
  shoulders_points = {5,6};
  face_points = {0,1,2,3,4};

    
  tracking_id.reset(new rviz::MovableText( Ogre::String("tracking_id"), Ogre::String("Liberation Sans"), Ogre::Real(0.6), Ogre::ColourValue(1.0f, 1.0f, 1.0f, 1.0f) ));
  tracking_id->setLocalTranslation( Ogre::Vector3(-0.25, 1, 0) ); //the first one is horizontal offset, the second one is vertical offset
  frame_node_->attachObject(&*tracking_id);

  name.reset(new rviz::MovableText( Ogre::String("name"), Ogre::String("Liberation Sans"), Ogre::Real(0.6), Ogre::ColourValue(1.0f, 1.0f, 1.0f, 1.0f) ));
  name->setLocalTranslation( Ogre::Vector3(-0.25, 1.7, 0) ); //the first one is horizontal offset, the second one is vertical offset
  frame_node_->attachObject(&*name);


  //constant properties of the arrow
  arrow->setScale( Ogre::Vector3(0.4, 1, 1) );
  arrow->setColor( 1.0f, 0.0f, 1.0f, 1.0f );
}

ActorVisual::~ActorVisual()
{
  frame_node_->detachAllObjects();
  // Destroy the frame node since we don't need it anymore.
  scene_manager_->destroySceneNode( frame_node_ );
}

void ActorVisual::setMessage( const nesfr3_msgs::Actor msg )
{
  Ogre::Quaternion orientation(msg.pose.pose.orientation.w, -msg.pose.pose.orientation.x, -msg.pose.pose.orientation.y, msg.pose.pose.orientation.z);

  Ogre::Vector3 pos( msg.pose.pose.position.x, msg.pose.pose.position.y, msg.pose.pose.position.z );
  arrow->setPosition( pos );
  arrow->setOrientation( orientation );

  tracking_id->setGlobalTranslation( pos );
  tracking_id->setCaption(std::to_string(msg.tracking_id));
  int length_id = log10(msg.tracking_id) + 1;
  tracking_id->setLocalTranslation( Ogre::Vector3(-0.125 * length_id, 1, 0) );
  
  name->setGlobalTranslation( pos );
  int length_name = msg.name.size();
  name->setLocalTranslation( Ogre::Vector3(-0.125 * length_name, 1.7, 0) );
  if(length_name != 0)
    name->setCaption(msg.name);

  left_body->clear();
  right_body->clear();
  shoulders->clear();
  face->clear();

  for(int i=0; i<left_body_points.size(); i++){
    int num = left_body_points[i];
    if(msg.points[num].confidence > 0.2)
      left_body->addPoint(Ogre::Vector3 (msg.points[num].point.x, msg.points[num].point.y, msg.points[num].point.z));
  }

  for(int i=0; i<right_body_points.size(); i++){
    int num = right_body_points[i];
    if(msg.points[num].confidence > 0.2)
      right_body->addPoint(Ogre::Vector3 (msg.points[num].point.x, msg.points[num].point.y, msg.points[num].point.z));
  }

  for(int i=0; i<shoulders_points.size(); i++){
    int num = shoulders_points[i];
    if(msg.points[num].confidence > 0.2)
      shoulders->addPoint(Ogre::Vector3 (msg.points[num].point.x, msg.points[num].point.y, msg.points[num].point.z));
  }
 for(int i=0; i<face_points.size(); i++){
    int num = face_points[i];
    if(msg.points[num].confidence > 0.2)
      face->addPoint(Ogre::Vector3 (msg.points[num].point.x, msg.points[num].point.y, msg.points[num].point.z));
  }   
}

// Position and orientation are passed through to the SceneNode.
void ActorVisual::setFramePosition( const Ogre::Vector3& position )
{
  frame_node_->setPosition( position );
}

void ActorVisual::setFrameOrientation( const Ogre::Quaternion& orientation )
{
  frame_node_->setOrientation( orientation );
}
// END

} // end namespace nesfr3_rviz_plugins
