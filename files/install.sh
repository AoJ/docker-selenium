#!/usr/bin/env sh
set -e

echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk add --update # we delete cache after install all dependencies
apk add ca-certificates unzip wget sudo openjdk8-jre-base firefox@testing


adduser seluser -s /bin/bash -D
addgroup seluser wheel
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/wheel
echo 'seluser:secret' | chpasswd


# XVFB as dummy X server
apk add xvfb xrdp vino

# x11vnc
apk add x11vnc@testing

# ???
mkdir -p /run/openrc
touch /run/openrc/softlevel

# selenium and java
cat <<- XRDP > /etc/xrdp/xrdp.ini
	[globals]
	bitmap_cache=yes
	bitmap_compression=yes
	port=3389
	crypt_level=low
	channel_code=1
	max_bpp=24

	[xrdp1]
	name=Vino
	lib=libvnc.so
	ip=127.0.0.1
	port=${VNC_PORT}
	username=ask
	password=ask
XRDP

rm -rf /var/cache/apk/*