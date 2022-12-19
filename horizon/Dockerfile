FROM kolla/debian-source-horizon:yoga
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/local_settings /etc/openstack-dashboard/local_settings
COPY data/horizon-wsgi.conf /etc/apache2/conf-enabled/horizon-wsgi.conf
USER root
