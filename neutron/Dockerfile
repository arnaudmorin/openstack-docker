#
# Builder
#
FROM debian:trixie-slim AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip python3-dev git \
    && rm -rf /var/lib/apt/lists/*

# Create venv
WORKDIR /opt/openstack/
RUN python3 -m venv neutron && \
    /opt/openstack/neutron/bin/pip install --upgrade pip setuptools

# Hash of the upstream sources (see upstream-ref.sh), so the build cache
# is invalidated as soon as upstream moves
ARG UPSTREAM_REF

# Install neutron
WORKDIR /src/neutron
RUN git clone https://opendev.org/openstack/neutron.git . -b stable/2026.2 && \
    /opt/openstack/neutron/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/neutron/bin/pip install PyMySQL python-memcached redis -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/neutron/bin/pip install uwsgi

# Install neutron-wireguard
RUN /opt/openstack/neutron/bin/pip install -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt git+https://github.com/arnaudmorin/neutron-wireguard

# Custom oslo.messaging
RUN /opt/openstack/neutron/bin/pip install git+https://github.com/arnaudmorin/oslo.messaging.git@stable/2026.2
# NOTE(arnaud) BlazingMQ SDK with authentication and TLS, from the fork until it is released upstream
RUN /opt/openstack/neutron/bin/pip install https://github.com/arnaudmorin/blazingmq-sdk-python/releases/download/v1.2.3-secure.e307e1a/blazingmq-1.2.3-cp313-cp313-manylinux_2_28_x86_64.whl

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/neutron /opt/openstack/neutron
COPY --from=builder /src/neutron/etc/neutron/api-paste.ini /etc/neutron/api-paste.ini

USER root
CMD [ "dumb-init", "--single-child", "--" , "/opt/openstack/neutron/bin/neutron-server"]
