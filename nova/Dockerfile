FROM kolla/nova-base:2024.2-debian-bookworm
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list
COPY data/nova-wsgi.conf /etc/apache2/conf-enabled/nova-wsgi.conf
COPY data/nova-metadata-wsgi.conf /etc/apache2/conf-enabled/nova-metadata-wsgi.conf

# The following packages are needed to run nova-vncproxy and nova-spicehtml5proxy
RUN apt-get update && apt-get install -y \
    novnc \
    spice-html5 \
    websockify

USER root
