#include <OGRE/OgreSceneNode.h>
#include <OGRE/OgreSceneManager.h>

#include <tf/transform_listener.h>

#include <rviz/visualization_manager.h>
#include <rviz/frame_manager.h>

#include "actor_visual.h"

#include "actor_display.h"


namespace nesfr3_rviz_plugins
{

// BEGIN
// The constructor must have no arguments, so we can't give the
// constructor the parameters it needs to fully initialize.
ActorDisplay::ActorDisplay()
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
void ActorDisplay::onInitialize()
{
  MFDClass::onInitialize();
  cur_visual.reset(new ActorVisual( context_->getSceneManager(), scene_node_ ));

}

ActorDisplay::~ActorDisplay()
{
}

// Clear the visuals by deleting their objects.
// not sure if this is needed
void ActorDisplay::reset()
{
  MFDClass::reset();
}




// This is our callback to handle an incoming message.
void ActorDisplay::processMessage( const nesfr3_msgs::Actor::ConstPtr& msg )
{
  // Here we call the rviz::FrameManager to get the transform from the
  // fixed frame to the frame in the header of this Actor message.  If
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

  // Now set or update the contents of the chosen visual.
  cur_visual->setMessage( *msg );
  cur_visual->setFramePosition( position );
  cur_visual->setFrameOrientation( orientation );

}

} // end namespace nesfr3_rviz_plugins

// Tell pluginlib about this class.  It is important to do this in
// global scope, outside our package's namespace.
#include <pluginlib/class_list_macros.h>
PLUGINLIB_EXPORT_CLASS(nesfr3_rviz_plugins::ActorDisplay, rviz::Display )
// END