FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install nova-conductor
CMD /usr/bin/python3 /usr/bin/nova-conductor --config-file=/etc/nova/nova.conf --log-file=/var/log/nova/nova-conductor.log
