FROM kolla/debian-source-horizon:wallaby
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/config.json /var/lib/kolla/config_files/config.json
COPY data/local_settings /etc/openstack-dashboard/local_settings
COPY data/horizon-wsgi.conf /etc/apache2/conf-enabled/horizon-wsgi.conf
