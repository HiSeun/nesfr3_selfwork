#include <OGRE/OgreSceneNode.h>
#include <OGRE/OgreSceneManager.h>

#include <tf/transform_listener.h>

#include <rviz/visualization_manager.h>
#include <rviz/frame_manager.h>

#include "actor_visual.h"

#include "actors_display.h"


namespace nesfr3_rviz_plugins
{

// BEGIN
// The constructor must have no arguments, so we can't give the
// constructor the parameters it needs to fully initialize.
ActorsDisplay::ActorsDisplay()
{
}

// After the top-level rviz::Display::initialize() does its own setup,
// it calls the subclass's onInitialize() function.  This is where we
// instantiate all the workings of the class.  We make sure to also
// call our immediate super-class's onInitialize() function, since it
// does important stuff setting up the message filter.
//
//  Note that "MFDClass" is a typedef of
// ``MessageFilterDisplay<message type>``, to save typing that long
// templated class name every time you need to refer to the
// superclass.
void ActorsDisplay::onInitialize()
{ 
  MFDClass::onInitialize();
  actors.reserve(100);  // hopefully there won't be more than 50 actors, 
                        // if there are increase the number or do something to insure the correct vector size
  for (int i=0; i<100; i++){
    boost::shared_ptr<ActorVisual> actor;
    actors.push_back(actor);
    actors[i].reset(new ActorVisual( context_->getSceneManager(), scene_node_ ));
  }
}

ActorsDisplay::~ActorsDisplay()
{
}

// Clear the visuals by deleting their objects.
// not sure if this is needed
void ActorsDisplay::reset()
{
  MFDClass::reset();
}




// This is our callback to handle an incoming message.
void ActorsDisplay::processMessage( const nesfr3_msgs::Actors::ConstPtr& msg )
{
  // Here we call the rviz::FrameManager to get the transform from the
  // fixed frame to the frame in the header of this Actors message.  If
  // it fails, we can't do anything else so we return.

  Ogre::Quaternion orientation;
  Ogre::Vector3 position;
  if( !context_->getFrameManager()->getTransform( msg->header.frame_id,
                                                  msg->header.stamp,
                                                  position, orientation ))
  {
    ROS_DEBUG( "Error transforming from frame '%s' to frame '%s'",
               msg->header.frame_id.c_str(), qPrintable( fixed_frame_ ));
    return;
  }

  uint32_t num_actors = msg->actors.size();

  // Now set or update the contents of the chosen visual.

  for (uint32_t i = 0; i < num_actors; i++)
  {
   const nesfr3_msgs::Actor single_msg = (msg->actors)[i];

    actors[i]->setMessage( single_msg  );
    actors[i]->setFramePosition( position );
    actors[i]->setFrameOrientation( orientation );
  }

}

} // end namespace nesfr3_rviz_plugins

// Tell pluginlib about this class.  It is important to do this in
// global scope, outside our package's namespace.
#include <pluginlib/class_list_macros.h>
PLUGINLIB_EXPORT_CLASS(nesfr3_rviz_plugins::ActorsDisplay, rviz::Display )
// END
