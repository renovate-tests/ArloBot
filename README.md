[![Build Status](https://travis-ci.com/chrisl8/ArloBot.svg)](https://travis-ci.com/chrisl8/ArloBot)
[![codecov](https://codecov.io/gh/chrisl8/ArloBot/branch/melodic/graph/badge.svg)](https://codecov.io/gh/chrisl8/ArloBot)

ArloBot Package for ROS
=======================

## and SO MUCH MORE! ##

1. This package provides a set of ROS packages for using a [Parallax Arlo Platform](http://www.parallax.com/product/arlo-robotic-platform-system "Parallax") robot to run all of the demonstration projects for the [Robot Operating System (ROS)](http://www.ros.org/ "ROS") based on the old [TurtleBot](http://wiki.ros.org/Robots/TurtleBot "TurtleBot")

This package also includes:
 0. An all in one install script that should get things as close to working as possible by running one install script.
 1. A Python and Curses based Serial Interface testing utility to help diagnose problems and confirm your hardware is working.
 2. A set of Bash script utilities to help in working with the robot.
 4. A set of Node.js based utilities to automate many repeated tasks.
 5. A Node.js based Server to run the robot at all times, along with:
 6. A React based web GUI to interact with the robot.
 7. Other fun things like Twilio and Pushover integration.

### Mobile Friendly Web Interface  
![Alt text](/screenshots/arlobotNewWebInterface.png "Web Interface")

### Curses Serial Testing Interface:  
`~/catkin_ws/src/ArloBot/scripts/PropellerSerialTest.sh`  
![Alt text](/screenshots/PropellerSerialTest.png "Serial Test Program")

* An python curses based serial communications test program allows testing of ALL Propeller board functions over serial with zero use of ROS to more easily ensure the hardware is working before starting ROS.

# Build a Robot! #
First you need to build a robot!

## Parts List ##
* Robot
* On board computer
* 3D Sensor

The Arlo Robotic Platform is a complete kit, which I recommend buying from Parallax: [Arlo Complete Robot System](https://www.parallax.com/product/28966)

You will also need a few other items (laptop and 3D sensor) which I have some details about on the [Parts List Wiki Page](https://github.com/chrisl8/ArloBot/wiki/Parts-List " Parts List")

## Building ##
Follow the excellent [Arlo Robot Assembly Guide](http://learn.parallax.com/tutorials/robot/arlo/arlo-robot-assembly-guide "Assembly Guide") at Parallax to both assemble and test your Arlo Robot platform.  
 Be sure you have fully understood and run all of their tests before moving on with using ROS.

Check out my blog: [ArloBot Build Index](http://ekpyroticfrood.net/?p=162 "Ekpyrotic Frood Blog")

And also jump on the [Parallax Forums](http://forums.parallax.com/ "Parallax Forums") and start searching and asking questions!

Because the Arlo platform comes as a kit, building it should be pretty straight forward, but we will all help you out with any problems you run into.  
Ask questions in the [Parallax Forums](http://forums.parallax.com/ "Parallax Forums"), on [GitHub](https://github.com/chrisl8/ArloBot/issues "Create an Issue"), on the [ROS for Arlobot Google Group](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!forum/ros-for-arlobot "ROS for Arlobot"), and on my [blog](http://ekpyroticfrood.net/ "My Blog").

Once your robot is built, you can use this package.

## Requirements ##
Arlobot operates on ROS Melodic which requires Ubuntu *18.04 LTS*.

If you put a fresh copy of Ubuntu 18.04 LTS on your robot's laptop then you can use the quick install script below.

## Quick Install: ##
There is now a script to install everything. Just run:

```
bash <(wget -qO- --no-cache -o /dev/null https://raw.githubusercontent.com/chrisl8/ArloBot/melodic/setup-melodic.sh)
```

Be sure to read the instructions that the script will print at the end about editing the config files in ~/.arlobot/

To update your code just run the same script again, and it will pull down and compile anything new without erasing custom settings.

Please note that you will need the code to run on your Propeller board. This is stored in the "Propeller C Code for ArloBot" folder. Details on the Propeller code and setup are here: [http://ekpyroticfrood.net/?p=165](http://ekpyroticfrood.net/?p=165)

## Propeller Serial Interface Test ##
Before you start trying to get ROS running, but after you have loaded the C code onto the Propeller Activity board, use the PropellerSerialTest to test the hardware and interface.  

Place the robot up on blocks so it won't drive into anything if it goes nuts, and then run:  
`~/catkin_ws/src/ArloBot/scripts/PropellerSerialTest.sh`  
This provides an interface to send all controls, commands, and settings directly to the Propeller Activity Board without involving ROS. Use this to test everything and make sure your robot's hardware is functioning before you start playing with ROS.

#### Serial Test Usage
0. Make sure the robot is on blocks off of the floor so when the motors run it will stay still and not run into anything.  
1. On the robot run `~/catkin_ws/src/ArloBot/scripts/PropellerSerialTest.sh` It will not start moving or doing anything yet, but it may soon! 
2. The Proximity Sensors, that is the PING and/or InfraRed (IR) sensors, can cause the robot to move to avoid obstacles or refuse to move when commanded to. The bottom row of the status shows their measurements. The second from the bottom row shows if the Propeller Activity Board's built in safety code has determined if it is safe to move forward or backward or not at all.  There is also the line `Escaping:False` which indicates if the code is attempting to move to get away from something too close.  
Since we are on blocks, let's turn this off, so it won't run the motors unless we tell it to. This will prevent it from just driving the wheels in response to you or something close to your test setup.  
Pres `s` for Settings and then `a` to ignore All proximity sensors.  
The line next to `Settings` that says `ignoreAllProximitySensors:No` will change to `ignoreAllProximitySensors:Yes`.
3. Next note along the `Settings` line that `pluggedIn` is `Yes`. This will prevent the Propeller Activity Board code from sending any commands to the motor. Normally the only way to override this is through ROS. It is a safety measure that prevents the robot from ever moving if ROS is not running. We will override this now. If you left the Settings menu press `s` to get back in. Then `p` for Plugged in to turn that off.  `pluggedIn:Yes` will change to `pluggedIn:Yes` Now the robot can move.  
4. Now `q` to get out of Settings and `m` to send Move commands.  Use the letters `i` to make the wheels move the robot forward.  
** IT WORKS!  **
You should probably test all of the functions available, but this has at least shown you how to use the test program and that your hardware is working.  You can use the Sensor output data to ensure your sensors work and diagnose issues with your hardware or code settings.  
There is also the ability to send Test packets to the robot to check for serious serial errors.  
Note that if you do the `r - Run speed test` there will be errors. It basically tests the ability for the code to slow down the transfer rate until the connection is stable, so errors will pop up as it attempts to go too fast and then backs off and retries. This is normal.  

## Quick Start of Entire Robot: ##
To start the Web Interface, which also allows starting ROS run:
```
~/catkin_ws/src/ArloBot/startRobot.sh
```
and point your web browser at the URL it gives you.

If you use Ubuntu there should also be a desktop icon on the robot's desktop that you can run to do the same thing and bring up this web page on the robot itself.

## Workstation via [x11docker](https://github.com/mviereck/x11docker)
If you want to run RVIZ or other ROS tools from a remote Linux workstation, you do not have to install ROS on it. Instead try using [x11docker](https://github.com/mviereck/x11docker) via this setup script:

```
bash <(wget -qO- --no-cache -o /dev/null https://raw.githubusercontent.com/chrisl8/ArloBot/melodic/workstation-melodic-via-x11docker.sh)
```  
Then use these commands to run various remote functions via Docker:  
`docker-view-navigation.sh`  
`docker-ros-view-robot.sh`  
`docker-ros-xterm.sh`  

The above works for me on Ubuntu 19.10.

## Updating Code

To update your code just run the same script again and it will pull down and compile anything new without erasing custom settings.

## Full Arlobot Setup Instructions: ##
Complete setup and usage instructions are at my blog:
http://ekpyroticfrood.net/?p=162

## Edit your robot's Description ##
`roscd arlobot_description/urdf`  
and then read the Readme.txt file there!

## WARNING: BY DEFAULT YOUR ROBOT WILL TRY TO MOVE EVEN WHEN IT IS PLUGGED IN!!!!
Edit `~/.arlobot/arlobot.yaml`  
Set `monitorACconnection: True` to have ROS monitor the power connection and FREEZE  
the robot whenever the laptop is plugged into AC power  

If you want to disable AC connection monitoring in real time, while ROS is running, run:  
`rosparam set /arlobot/monitorACconnection False`

## NOTE: Robot may be stuck or moving in response to sensors
The Infrared, PING, and "plugged in" state of the robot can prevent it from moving or cause it to move by itself.  
Once ROS is running, if you want to ensure that ONLY ROS input causes movement, and that the robot responds to ROS even if the PING or IR sensors sense an obstacle, you can quickly tell it to ignore all sensor input by running:  
`~/catkin_ws/src/ArloBot/scripts/ignoreAllSensors.sh`  
Notice that you must run that **AFTER ROS is started**, and run it every time you start ROS when testing with sensors ignored.

# Basic ROS based usage instructions #
Depending on what you want to do there are different ways to "bring up" the robot with just ROS.<br/>These are the "recipes" that are well tested so far:

### Basic TeleOp with 3D sensor use ###
```
roslaunch arlobot_bringup minimal.launch --screen
# In a new Terminal:
roslaunch arlobot_teleop keyboard_teleop.launch
# In a new Terminal:
# Replace "kinect" with "asus_xtion_pro" or "astra", depending on what sensor you have
export ARLOBOT_3D_SENSOR=kinect
roslaunch arlobot_bringup 3dsensor.launch
# From a Terminal in the desktop (NOT over SSH):
roslaunch arlobot_rviz_launchers view_robot.launch
# Do this:
  Set your Global Options->Fixed Frame to "odom
    Drive and see if the robot appears to move properly on the grid.
  Turn on LaserScan and set the Decay Time to 650
    Rotate the robot in a circle, and see if you get a reasonable picture of the room.
  Turn off Laser Scan and turn on Registered DepthCloud to see if you get a picture of the room overlayed properly onto the 3D virtual world in RVIZ.
```

### Remote Control with an xBox 360 joystick ###
http://ekpyroticfrood.net/?p=115
```
roslaunch arlobot_bringup minimal.launch --screen
# In a new Terminal:
rosparam set /joystick/dev "/dev/input/js0"
roslaunch turtlebot_teleop xbox360_teleop.launch --screen
```

### Gmapping Demo (SLAM Map building) ###
http://wiki.ros.org/turtlebot_navigation/Tutorials/Build%20a%20map%20with%20SLAM
```
roslaunch arlobot_bringup minimal.launch --screen
# In a new Terminal:
roslaunch arlobot_navigation gmapping_demo.launch --screen
# In a new Terminal:
roslaunch arlobot_teleop keyboard_teleop.launch
# From a Terminal in the desktop (NOT over SSH):
roslaunch arlobot_rviz_launchers view_navigation.launch
# When you are done, save your map!
rosrun map_server map_saver -f ~/rosmaps/my_map1
# Do this:
  Make sure that obstacles in the 3D Camera view are shown in the local costmap
    It is possible to map walls, while the 3D is ignored by the costmap!
    I find this is caused by the max_obstacle_height being set below the 3D Sensor's height
    in costmap_common_params.yaml on the "scan:" line
```

### AMCL (Navigating the map we built above ###
http://wiki.ros.org/turtlebot_navigation/Tutorials/Autonomously%20navigate%20in%20a%20known%20map
```
roslaunch arlobot_bringup minimal.launch --screen
# In a new Terminal:
roslaunch arlobot_navigation amcl_demo.launch map_file:=~/rosmaps/my_map1.yaml
# From a Terminal in the desktop (NOT over SSH):
roslaunch arlobot_rviz_launchers view_navigation.launch --screen
```

Please report an issue for any problems or if you need me to clarify anything!  
 Ask questions in the [Parallax Forums](http://forums.parallax.com/ "Parallax Forums"), on [GitHub](https://github.com/chrisl8/ArloBot/issues "Create an Issue"), on the [ROS for Arlobot Google Group](https://groups.google.com/forum/?utm_medium=email&utm_source=footer#!forum/ros-for-arlobot "ROS for Arlobot"), and on my [blog](http://ekpyroticfrood.net/ "My Blog"). We will write more documentation as we answer questions, and I hope you will also write instructions when you do your build!


# Script Based Operation #

All of the functions above also have quick launch scripts.
`cd ~/catkin_ws/src/ArloBot/scripts`

### Start ROS ###
Start just the most basic pieces  
`start-arlobot-only.sh`  
OR  
Start everything  
`start-robot.sh`
### Basic TeleOp ###
`keyboard-teleop.sh`
### Automatically unplug itself ###
`unPlug.sh`
### Remote Control with an xBox 360 joystick ###
This is built into the `start-robot.sh` script.
### Gmapping Demo (SLAM Map building) ###
`make-map-gmapping.sh`  
Or use Cartographer instead of Gmapping:  
`make-map-cartographer.sh`
View with rviz:  
`view-navigation.sh`  
Save the map:  
`save-map.sh`
### AMCL (Navigating the map we built above ###
List available maps:  
`listMaps.sh`  
Load the map:  
`load-map.sh`  
View with rviz:
`view-navigation.sh`
### Shut down ROS and everything related to it ###
`kill_ros.sh`

The scripts call ROS files, so you can modify the ROS files listed in the scripts to modify how ROS operates.

Note that xBox 360 Controller operation is always live when ROS is running this way.


# Web Based Operation #

Finally the entire robot can be operated from the web.  
Go to http://<robot_ip_address>:8080/

All of the basic robot operations are available.  
- Use the Startup/Shutdown Panel to start ROS.
- Use the Navigation Panel to:
  - Make a new Map
  - Load an existing Map
  - Add waypoints to a map
- Use the Remote Control Panel to control the robot from the web site
  - This works well from a smartphone
- Explore all of the other options. 

The web site uses the same scripts from above, so you can modify them or the ROS files that they call to modify how ROS operates.

Note that xBox 360 Controller operation is always live when ROS is running from the web site.

## Convenience Scripts ##
Look in the scripts folder for a set of handy scripts for starting up and shutting down various aspects of Arlobot.

## Tuning
See the [RobotTuningNotes](RobotTuningNotes.md) for guidance on tuning robot parameters.

## Freenect warnings

These warnings are normal if you are using a Kinect. You can ignore them.
```
[ WARN] [1564761452.151374277]: Could not find any compatible depth output mode for 1. Falling back to default depth output mode 1.
[ WARN] [1564761452.222812571]: Camera calibration file /home/chrisl8/.ros/camera_info/rgb_B00$64729659136B.yaml not found.
[ WARN] [1564761452.230197119]: Using default parameters for RGB camera calibration.   [ WARN] [1564761452.230247519]: Camera calibration file /home/chrisl8/.ros/camera_info/depth_B00364729659136B.yaml not found.
[ WARN] [1564761452.230264691]: Using default parameters for IR camera calibration.
```

## HB-25 Motor Controller Support Gone! ##
Parallax has updated the Arlo platform to use their new DHB-10 Dual H-Bridge controller.  
My robot now uses the DHB-10 motor controller.  
Unfortunately I do not have time to support two controllers, especially when I only have one. (If I had money and time to build a second robot, maybe I could.)  
If you have HB-25 controllers, you can try using the last release that I made that still supported them here:  
[Old Propeller Code Release](https://github.com/chrisl8/ArloBot/releases/tag/oldPropellerCode)


## Contributing
All code contributions are greatly welcomed! I almost always accept pull requests. Worst case, I accept it, find an issue, and fix it, but even code that I have to fix up is better than code I have to write from scratch!  
Feel free to use this repository for [Hacktoberfest](https://hacktoberfest.digitalocean.com/) or other code contribution events, or just to get your feet wet using git. I'm happy to get spelling corrections and documentation improvements.  
I use [prettier](https://prettier.io/) on my JavaScript code, [Black](https://pypi.org/project/black/) on my Python code, and [shfmt](https://github.com/mvdan/sh) on my Bash code to format it. However, I won't let code formatting prevent me from accepting a pull request. I can tidy it up later.
