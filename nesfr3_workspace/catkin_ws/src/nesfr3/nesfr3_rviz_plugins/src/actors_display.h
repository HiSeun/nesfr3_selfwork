#ifndef ACTORS_DISPLAY_H
#define ACTORS_DISPLAY_H

#ifndef Q_MOC_RUN
#include <boost/circular_buffer.hpp>

#include <rviz/message_filter_display.h>

#include <nesfr3_msgs/Actor.h>
#include <nesfr3_msgs/Actors.h>

#endif

namespace Ogre
{
class SceneNode;
}

// All the source in this plugin is in its own namespace.  This is not
// required but is good practice.
namespace nesfr3_rviz_plugins
{

class ActorVisual;

// BEGIN
// Here we declare our new subclass of rviz::Display.  Every display
// which can be listed in the "Displays" panel is a subclass of
// rviz::Display.
class ActorsDisplay: public rviz::MessageFilterDisplay<nesfr3_msgs::Actors>
{
Q_OBJECT
public:
  // Constructor.  pluginlib::ClassLoader creates instances by calling
  // the default constructor, so make sure you have one.
  ActorsDisplay();
  virtual ~ActorsDisplay();

  // Overrides of protected virtual functions from Display.  As much
  // as possible, when Displays are not enabled, they should not be
  // subscribed to incoming data and should not show anything in the
  // 3D view.  These functions are where these connections are made
  // and broken.
protected:
  virtual void onInitialize();

  // A helper to clear this display back to the initial state.
  virtual void reset(); // not sure if this is needed


  // Function to handle an incoming ROS message.
private:
  void processMessage( const nesfr3_msgs::Actors::ConstPtr& msg );

  // boost::shared_ptr<ActorVisual> cur_visual;

  std::vector<boost::shared_ptr<ActorVisual>> actors; 

  uint32_t number_of_actors = 0;


};
// END

} // end namespace nesfr3_rviz_plugins

#endif // ACTOR_DISPLAY_H
// %EndTag(FULL_SOURCE)%
