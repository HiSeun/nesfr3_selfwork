#ifndef ACTOR_VISUAL_H
#define ACTOR_VISUAL_H

#include <nesfr3_msgs/Actor.h>



namespace Ogre
{
class Vector3;
class Quaternion;
}

namespace rviz
{
class Arrow;
class BillboardLine;
class MovableText;
}

namespace nesfr3_rviz_plugins
{

// BEGIN
// Declare the visual class for this display.
//
// Each instance of ActorVisual represents the visualization of a single
// sensor_msgs::Actor message.  Currently it just shows an arrow with
// the direction and magnitude of the acceleration vector, but could
// easily be expanded to include more of the message data.
class ActorVisual
{
public:
  // Constructor.  Creates the visual stuff and puts it into the
  // scene, but in an unconfigured state.
  ActorVisual( Ogre::SceneManager* scene_manager, Ogre::SceneNode* parent_node );

  // Destructor.  Removes the visual stuff from the scene.
  virtual ~ActorVisual();

  // Configure the visual to show the data in the message.
  void setMessage( const nesfr3_msgs::Actor msg );

  // Set the pose of the coordinate frame the message refers to.
  // These could be done inside setMessage(), but that would require
  // calls to FrameManager and error handling inside setMessage(),
  // which doesn't seem as clean.  This way ActorVisual is only
  // responsible for visualization.
  void setFramePosition( const Ogre::Vector3& position );
  void setFrameOrientation( const Ogre::Quaternion& orientation );

private:
  // The object implementing the actual shapes
  boost::shared_ptr<rviz::Arrow> arrow;
  boost::shared_ptr<rviz::MovableText> tracking_id;
  boost::shared_ptr<rviz::MovableText> name;

  boost::shared_ptr<rviz::BillboardLine> left_body;
  boost::shared_ptr<rviz::BillboardLine> right_body;
  boost::shared_ptr<rviz::BillboardLine> shoulders;
  boost::shared_ptr<rviz::BillboardLine> face;

  std::array<int,6> left_body_points;
  std::array<int,6> right_body_points;
  std::array<int,2> shoulders_points;
  std::array<int,5> face_points;

  // A SceneNode whose pose is set to match the coordinate frame of
  // the Actor message header.
  Ogre::SceneNode* frame_node_;

  // The SceneManager, kept here only so the destructor can ask it to
  // destroy the ``frame_node_``.
  Ogre::SceneManager* scene_manager_;
};
// END

} // end namespace nesfr3_rviz_plugins

#endif // ACTOR_VISUAL_H
