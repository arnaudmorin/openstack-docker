FROM kolla/keystone-base:2023.2-debian-bookworm
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list
COPY data/keystone-wsgi.conf /etc/apache2/conf-enabled/keystone-wsgi.conf
USER root
