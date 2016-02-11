FROM ubuntu:14.04
MAINTAINER AooJ <aooj@n13.cz>

ENV NODE_VERSION=v0.10.6
ENV NODE_OS=-linux-x64

WORKDIR /tmp

RUN	apt-get update && apt-get install -y wget && \
	wget https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}${NODE_OS}.tar.gz && \
	tar -xzf node-${NODE_VERSION}${NODE_OS}.tar.gz && \
        cd node-${NODE_VERSION}${NODE_OS}
