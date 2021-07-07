FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install nova-consoleproxy
CMD /usr/bin/python3 /usr/bin/nova-spicehtml5proxy --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-spicehtml5proxy.log
