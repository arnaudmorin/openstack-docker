FROM kolla/debian-source-mistral-base:yoga
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/mistral-wsgi.conf /etc/apache2/conf-enabled/mistral-wsgi.conf

USER root

# To start mistral-api
# source /etc/apache2/envvars && /usr/sbin/apache2 -DFOREGROUND

# Other services
# /var/lib/kolla/venv/bin/mistral-server --server engine
# /var/lib/kolla/venv/bin/mistral-server --server executor
