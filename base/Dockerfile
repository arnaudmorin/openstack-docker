FROM debian:buster
RUN echo 'deb http://deb.debian.org/debian buster-backports main contrib non-free' >> /etc/apt/sources.list
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install extrepo
RUN export DEBIAN_FRONTEND=noninteractive && extrepo enable openstack_victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install ifupdown
