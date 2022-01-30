FROM kolla/debian-source-neutron-server:victoria
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/config.json /var/lib/kolla/config_files/config.json
COPY data/neutron-wsgi.conf /etc/apache2/conf-enabled/neutron-wsgi.conf
COPY data/extend_start.sh /usr/local/bin/kolla_neutron_extend_start
RUN chmod 755 /usr/local/bin/kolla_neutron_extend_start
