FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install keystone
CMD /usr/bin/uwsgi_python37 --http-socket :5000 --ini /etc/keystone/keystone-uwsgi.ini
EXPOSE 5000
