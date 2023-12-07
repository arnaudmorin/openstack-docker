FROM kolla/horizon:2023.2-debian-bookworm
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list
COPY data/local_settings /etc/openstack-dashboard/local_settings
COPY data/horizon-wsgi.conf /etc/apache2/conf-enabled/horizon-wsgi.conf
USER root
