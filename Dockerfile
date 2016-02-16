FROM alpine:3.3
MAINTAINER AooJ <aooj@n13.cz>


ENV SCREEN 0
ENV DISPLAY :99.0
ENV GEOMETRY=1360x1020x24

ENV VNC_PORT 5900
ENV SEL_VER 2.52
ENV SEL_PATCH 0

WORKDIR /tmp
ADD files/*.sh /tmp/
RUN chmod +x *.sh
RUN ./install.sh
RUN ./install-selenium.sh


