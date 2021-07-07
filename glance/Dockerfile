FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install glance python-memcache
CMD /usr/bin/uwsgi_python37 --http-socket :9292 --ini /etc/glance/glance-api-uwsgi.ini
EXPOSE 9292
