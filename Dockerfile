FROM alpine:3.2
MAINTAINER AooJ <aooj@n13.cz>


WORKDIR /tmp

RUN     apk add --update ca-certificates openjdk7-jre-base unzip wget sudo bash xvfb               \
     && rm -rf /var/cache/apk/*

RUN     mkdir -p /opt/selenium                                                                     \
     && wget --no-verbose                                                                          \
	http://selenium-release.storage.googleapis.com/2.48/selenium-server-standalone-2.48.2.jar  \
	-O /opt/selenium/selenium-server-standalone.jar

RUN     adduser seluser -s /bin/bash -D                                                            \
     && addgroup seluser wheel                                                                     \
     && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/wheel                              \
     && echo 'seluser:secret' | chpasswd

RUN apk add --update xrdp xfce4
RUN apk add --update vino
ADD xrdp.ini /etc/xrdp/xrdp.ini
RUN mkdir -p /run/openrc && touch /run/openrc/softlevel
# RUN echo xfce4-session >~/.xsession
RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && apk update && apk add x11vnc@testing
ENV SCREEN_WIDTH 1360
ENV SCREEN_HEIGHT 1020
ENV SCREEN_DEPTH 24
ENV DISPLAY :99.0
