FROM arnaudmorin/openstack-base:victoria
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && apt-get -y install placement-api python3-pymysql
CMD /usr/bin/uwsgi_python37 --http-socket :8778 --ini /etc/placement/placement-api-uwsgi.ini
EXPOSE 8778
