FROM kolla/debian-source-neutron-base:yoga
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list

COPY data/ovs_conf.py.patch /tmp/
RUN patch -u /var/lib/kolla/venv/lib/python3.9/site-packages/neutron/conf/plugins/ml2/drivers/ovs_conf.py /tmp/ovs_conf.py.patch

USER root
