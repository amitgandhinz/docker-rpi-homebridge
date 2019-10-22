FROM node
MAINTAINER ViViDboarder <vividboarder@gmail.com>

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        avahi-daemon \
        avahi-discover \
        build-essential \
	iputils-ping \
        libavahi-compat-libdnssd-dev \
        libnss-mdns && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
 
RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        libpcap-dev \
        iputils-ping \
        dos2unix \
        ffmpeg

RUN npm config set unsafe-perm true

RUN npm install -g --unsafe-perm \
        homebridge \
        hap-nodejs \
        node-gyp

RUN cd /usr/local/lib/node_modules/homebridge/
RUN npm install --unsafe-perm bignum

RUN mkdir -p /var/run/dbus/

USER root
RUN mkdir -p /root/.homebridge


EXPOSE 5353 51826
VOLUME /root/.homebridge
WORKDIR /root/.homebridge

ADD start.sh /root/.homebridge/start.sh
ADD plugins/plugins.txt /root/.homebridge/plugins/plugins.txt
ADD config.json /root/.homebridge/config.json

CMD dos2unix /root/.homebridge/start.sh && /root/.homebridge/start.sh