FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install neutron-api
CMD /usr/bin/uwsgi_python37 --http-socket :9696 --ini /etc/neutron/neutron-api-uwsgi.ini
EXPOSE 9696
