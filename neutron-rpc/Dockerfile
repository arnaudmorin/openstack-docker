FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install neutron-rpc-server
CMD /usr/bin/python3 /usr/bin/neutron-rpc-server --config-file=/etc/neutron/neutron.conf --config-dir=/etc/neutron/server.conf.d --config-file=/etc/neutron/plugins/ml2/ml2_conf.ini --log-file=/var/log/neutron/neutron-rpc-server.log
