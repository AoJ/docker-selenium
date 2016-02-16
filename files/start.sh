#!/usr/bin/env sh
set -em

# XVFB as dummy X server
echo "starting Xvfb with DISPLAY=${DISPLAY} screen=${SCREEN} geometry=${GEOMETRY}"
Xvfb ${DISPLAY} -screen ${SCREEN} ${GEOMETRY}     \
  -ac -r -cc 4 -accessx                           \
  -xinerama +extension Composite                  \
  -extension RANDR +extension GLX                 &


# x11vnc
echo starting x11vnc on display=$DISPLAY port=${VNC_PORT}
x11vnc -forever -usepw -shared -rfbport ${VNC_PORT} -display $DISPLAY &


# selenium and java
DISPLAY=$DISPLAY.0 java -jar /opt/selenium/selenium-server-standalone.jar &


# primitive init system ;)
trap 'for job in $(jobs -p); do kill $job; done' 0
wait