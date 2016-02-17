#!/usr/bin/env sh
set -e


mkdir -p /opt/selenium
wget --no-verbose                                                                                                   \
	http://selenium-release.storage.googleapis.com/${SEL_VER}/selenium-server-standalone-${SEL_VER}.${SEL_PATCH}.jar  \
	-O /opt/selenium/selenium-server-standalone.jar
