FROM kolla/mistral-base:2023.2-debian-bookworm
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list
COPY data/mistral-wsgi.conf /etc/apache2/conf-enabled/mistral-wsgi.conf

USER root

# To start mistral-api
# source /etc/apache2/envvars && /usr/sbin/apache2 -DFOREGROUND

# Other services
# /var/lib/kolla/venv/bin/mistral-server --server engine
# /var/lib/kolla/venv/bin/mistral-server --server executor
