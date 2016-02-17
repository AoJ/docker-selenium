#!/usr/bin/env sh
set -em


start_node () {
	cat <<- NODECONFIG > /opt/selenium/config.json
	{
	  "capabilities": [
	    {
	      "browserName": "*firefox",
	      "maxInstances": 1,
	      "seleniumProtocol": "Selenium"
	    },
	    {
	      "browserName": "firefox",
	      "maxInstances": 1,
	      "seleniumProtocol": "WebDriver"
	    }
	  ],
	  "configuration": {
	    "proxy": "org.openqa.grid.selenium.proxy.DefaultRemoteProxy",
	    "maxSession": 1,
	    "port": 5555,
	    "register": true,
	    "registerCycle": 5000
	  }
	}
	NODECONFIG

	# XVFB as dummy X server
	echo "starting Xvfb with DISPLAY=${DISPLAY} screen=${SCREEN} geometry=${GEOMETRY}"
	Xvfb ${DISPLAY} -screen ${SCREEN} ${GEOMETRY}     \
	  -ac -r -cc 4 -accessx                           \
	  -xinerama +extension Composite                  \
	  -extension RANDR +extension GLX                 &
	PID_XVFB=$!

	# x11vnc
	echo starting x11vnc on display=$DISPLAY port=${VNC_PORT}
	x11vnc -forever -usepw -shared -rfbport ${VNC_PORT} -display $DISPLAY &
	PID_X11VNC=$!

	DISPLAY=$DISPLAY java -jar /opt/selenium/selenium-server-standalone.jar      \
		-role node                                                                 \
		-nodeConfig /opt/selenium/config.json                                      \
		$@
}




start_hub () {
	VER=${SEL_VER}.${SEL_PATCH}
	# fix timeout error, see https://github.com/SeleniumHQ/selenium/issues/1557
	# https://github.com/SeleniumHQ/selenium/commit/bf66042eb2aee6d95d5987b1704b52f1260382e6
	if [ ${VER} == "2.49.0" ] || [ ${VER} == "2.49.1" ] || [ ${VER} == "2.50.0" ]; then
		export GRID_TIMEOUT=${GRID_TIMEOUT:-  150000}000
	fi;

	cat <<- HUBCONFIG > /opt/selenium/config.json
		{
		  "host": null,
		  "port": 4444,
		  "prioritizer": null,
		  "capabilityMatcher": "org.openqa.grid.internal.utils.DefaultCapabilityMatcher",
		  "throwOnCapabilityNotPresent": true,
		  "newSessionWaitTimeout": ${GRID_NEW_SESSION_WAIT_TIMEOUT:-  -1},
		  "jettyMaxThreads": ${GRID_JETTY_MAX_THREADS:-  -1},
		  "nodePolling": ${GRID_NODE_POLLING:-  5000},
		  "cleanUpCycle": ${GRID_CLEAN_UP_CYCLE:-  5000},
		  "timeout": ${GRID_TIMEOUT:-  150000},
		  "browserTimeout": ${GRID_BROWSER_TIMEOUT:-  0},
		  "maxSession": ${GRID_MAX_SESSION:-  5},
		  "unregisterIfStillDownAfter": ${GRID_UNREGISTER_IF_STILL_DOWN_AFTER:-  30000}
		}
	HUBCONFIG


	DISPLAY=$DISPLAY.0 java -jar /opt/selenium/selenium-server-standalone.jar -role hub $@
}

case "$1" in
	"node")
			start_node ${@:2}
			;;
	"hub")
			start_hub ${@:2}
			;;
	*)
			exec $@
			;;
esac;