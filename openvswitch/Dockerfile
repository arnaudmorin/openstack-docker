FROM kolla/debian-source-openvswitch-base:yoga
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list
#RUN modprobe openvswitch
RUN mkdir -p /run/openvswitch
RUN ovsdb-tool create "/var/lib/openvswitch/conf.db"

USER root
