FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install nova-api
CMD /usr/bin/uwsgi_python37 --http-socket :8775 --ini /etc/nova/nova-api-metadata-uwsgi.ini
EXPOSE 8775
