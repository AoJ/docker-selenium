#!/usr/bin/env sh
set -e

echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
apk add --update # we delete cache after install all dependencies
apk add ca-certificates unzip wget sudo


adduser seluser -s /bin/bash -D
addgroup seluser wheel
echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/wheel
echo 'seluser:secret' | chpasswd


# XVFB as dummy X server
apk add xvfb
# TODO xrdp vino

# x11vnc
apk add x11vnc@testing
mkdir -p /etc/.vnc
x11vnc -storepasswd "" /etc/.vnc/passwd

# ???
mkdir -p /run/openrc
touch /run/openrc/softlevel

rm -rf /var/cache/apk/*