FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install nova-api
CMD /usr/bin/uwsgi_python37 --http-socket :8774 --ini /etc/nova/nova-api-uwsgi.ini
EXPOSE 8774
