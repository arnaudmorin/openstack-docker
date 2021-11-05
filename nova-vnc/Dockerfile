FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get --allow-releaseinfo-change update && apt-get -y install nova-consoleproxy
CMD /usr/bin/python3 /usr/bin/nova-novncproxy --config-file=/etc/nova/nova.conf --log-file=/dev/stdout
