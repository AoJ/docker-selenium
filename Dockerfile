FROM alpine:3.3
MAINTAINER AooJ <aooj@n13.cz>

# better init system. Yes, it's necessary - correct forward signals (INT, TERM, HUP and job control)
# and check for zombie process and re-attach it to itself
# I don't like zooooooombie procceses!
RUN apk add --no-cache --update --repository http://dl-4.alpinelinux.org/alpine/edge/community/ tini

ENV SCREEN 0
ENV DISPLAY :99.0
ENV GEOMETRY=1360x1020x24

ENV VNC_PORT 5900
ENV SEL_VER 2.52
ENV SEL_PATCH 0


WORKDIR /tmp
ADD files/install*.sh /tmp/
# sync is required due to docker storage bug
# https://github.com/docker/docker/issues/9547
RUN chmod +x install.sh && sync && ./install.sh
RUN apk add --no-cache --update firefox@testing
RUN apk add --no-cache --update openjdk8-jre-base
RUN chmod +x install-selenium.sh && sync && ./install-selenium.sh

ADD files/start.sh start.sh
RUN chmod +x start.sh
ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/tmp/start.sh"] #forward singals to all children
CMD "hub"