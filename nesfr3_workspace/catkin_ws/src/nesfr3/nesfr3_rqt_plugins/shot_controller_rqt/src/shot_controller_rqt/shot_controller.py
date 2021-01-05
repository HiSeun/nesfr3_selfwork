import os
import rospy
import rospkg

from qt_gui.plugin import Plugin
from python_qt_binding import loadUi
from python_qt_binding.QtWidgets import QWidget

from nesfr3_services.srv import *

import thread
import threading
import time


class ShotController(Plugin):

    def __init__(self, context):
        super(ShotController, self).__init__(context)
        # Give QObjects reasonable names
        self.setObjectName('ShotController')

        # Process standalone plugin command-line arguments
        from argparse import ArgumentParser
        parser = ArgumentParser()
        # Add argument(s) to the parser.
        parser.add_argument("-q", "--quiet", action="store_true",
                      dest="quiet",
                      help="Put plugin in silent mode")
        args, unknowns = parser.parse_known_args(context.argv())
        if not args.quiet:
            print 'arguments: ', args
            print 'unknowns: ', unknowns

        # Create QWidget
        self._widget = QWidget()
        # Get path to UI file which should be in the "resource" folder of this package
        ui_file = os.path.join(rospkg.RosPack().get_path('shot_controller_rqt'), 'resource', 'ShotController.ui')
        # Extend the widget with all attributes and children from UI file
        loadUi(ui_file, self._widget)
        # Give QObjects reasonable names
        self._widget.setObjectName('ShotControllerUi')
        # Show _widget.windowTitle on left-top of each plugin (when 
        # it's set in _widget). This is useful when you open multiple 
        # plugins at once. Also if you open multiple instances of your 
        # plugin at once, these lines add number to make it easy to 
        # tell from pane to pane.
        if context.serial_number() > 1:
            self._widget.setWindowTitle(self._widget.windowTitle() + (' (%d)' % context.serial_number()))
        # Add widget to the user interface
        context.add_widget(self._widget)

        self._widget.current_distance_box.valueChanged.connect(self._on_current_distance_box_changed)
        self._widget.distance_slider.valueChanged.connect(self._on_current_distance_slider_changed)

        self._widget.current_angle_box.valueChanged.connect(self._on_current_angle_box_changed)
        self._widget.angle_slider.valueChanged.connect(self._on_current_angle_slider_changed)

        self.number_of_actors = 0
        self.number_of_robots = 0
        thread.start_new_thread(self._topics_scanning_thread, ())


        self._widget.actor_box.currentTextChanged.connect(self._on_actor_box_changed)
        self._widget.robot_box.currentTextChanged.connect(self._on_robot_box_changed)

        

        self._widget.shot_size_box.addItems(["FS", "MFS", "MS", "MCU", "CU", "ECU"])

        self._widget.shot_size_box.currentTextChanged.connect(self._on_shot_size_box_changed)
        
        self._change_robot()

        #service_call takes a whole second, if it could be just called asynchronously it would've been ok, but only rclpy for ROS2 had that option
        #therefore there's a thread sending the request so that the UI doesn't take a second to respond to every change
        self.e = threading.Event()
        thread.start_new_thread(self._sending_thread, ())

    def _on_current_distance_box_changed(self):
        self._widget.distance_slider.setValue((self._widget.current_distance_box.value() - 1) / 15 * 1500 - 750)
        self.e.set()

    def _on_current_distance_slider_changed(self):
        self._widget.current_distance_box.setValue((self._widget.distance_slider.value() + 750.0) / 1500.0 * 15 + 1.0)

    def _on_current_angle_box_changed(self):
        self._widget.angle_slider.setValue(self._widget.current_angle_box.value() * 1000.0)
        self.e.set()

    def _on_current_angle_slider_changed(self):
        self._widget.current_angle_box.setValue(self._widget.angle_slider.value() / 1000.0)

    def _on_actor_box_changed(self):
        self.e.set() 

    def _on_robot_box_changed(self):
        self._change_robot()
        self.e.set()

    def _on_shot_size_box_changed(self):
        self.e.set()



    def _sending_thread(self):
        while True:
            self.e.wait()

            #wait for the input to be finilized
            while(self.e.isSet()):
                self.e.clear()
                time.sleep(1)
                
            self._send_request()


    def _send_request(self):
        actor_id = self._widget.actor_box.currentText()
        robot_id = self._widget.robot_box.currentText()

        if actor_id == '' or robot_id == '':
            return

        actor_id = int(actor_id)
        robot_id = int(robot_id)

        distance = self._widget.current_distance_box.value()
        angle = self._widget.current_angle_box.value()
        shot_size = self._widget.shot_size_box.currentText()

        self.service_call(actor_id, robot_id, distance, angle, shot_size)

        print("\n")
        print("actor id: " + str(actor_id))
        print("robot id: " + str(robot_id))
        print("distance: " + str(distance))
        print("angle: " + str(angle))
        print("shot size: " + shot_size)
        print("\n")
          

    def _change_robot(self):
        robot_id = self._widget.robot_box.currentText()

        if robot_id == '':
            return

        robot_id = int(robot_id)

        service_name = "nesfr3/" + str(robot_id) + "/shot_cmd"
        rospy.wait_for_service(service_name)
        self.service_call = rospy.ServiceProxy(service_name, FollowActor)


    def _topics_scanning_thread(self):
        while True:
            topics = rospy.get_published_topics()

            max_robot_index = 0
            max_actor_index = 0

            for pair in topics:
                topic = pair[0]

                if len(topic) > 8 and topic[:8] == "/nesfr3/":
                    robot_index = self._get_index(topic, 8)
                    if robot_index > max_robot_index:
                        max_robot_index = robot_index

                if len(topic) > 14 and topic[:14] == "/gazebo/Actor/":
                    actor_index = self._get_index(topic, 14)
                    if actor_index > max_actor_index:
                        max_actor_index = actor_index
            

            if max_robot_index != self.number_of_robots:
                self._widget.robot_box.clear()

                for i in range(1, max_robot_index + 1):
                    self._widget.robot_box.addItem(str(i))

                self.number_of_robots = max_robot_index

            if max_actor_index != self.number_of_actors:
                self._widget.actor_box.clear()

                for i in range(1, max_actor_index + 1):
                    self._widget.actor_box.addItem(str(i))

                self.number_of_actors = max_actor_index


            time.sleep(1)



    def _get_index(self, topic, start):
        i = start
        while i < len(topic) and topic[i] != '/':
            i += 1

        return int(topic[start:i])

    """
    Qt methods
    """

    def shutdown_plugin(self):
        # unregister all publishers here
       pass

    def save_settings(self, plugin_settings, instance_settings):
        instance_settings.set_value(
            'curr_dist_box', self._widget.current_distance_box.value())
        instance_settings.set_value(
            'dist_sldr', self._widget.distance_slider.value())
        instance_settings.set_value(
            'curr_ang_box', self._widget.current_angle_box.value())
        instance_settings.set_value(
            'ang_sldr', self._widget.angle_slider.value())
        
    def restore_settings(self, plugin_settings, instance_settings):
        value = self._widget.current_distance_box.value()
        value = instance_settings.value('curr_dist_box', value)
        self._widget.current_distance_box.setValue(float(value))

        value = self._widget.distance_slider.value()
        value = instance_settings.value('dist_sldr', value)
        self._widget.distance_slider.setValue(float(value))

        value = self._widget.current_angle_box.value()
        value = instance_settings.value('curr_ang_box', value)
        self._widget.current_angle_box.setValue(float(value))

        value = self._widget.angle_slider.value()
        value = instance_settings.value('ang_sldr', value)
        self._widget.angle_slider.setValue(float(value))
        