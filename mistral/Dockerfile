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
RUN python3 -m venv mistral && \
    /opt/openstack/mistral/bin/pip install --upgrade pip setuptools

# Hash of the upstream sources (see upstream-ref.sh), so the build cache
# is invalidated as soon as upstream moves
ARG UPSTREAM_REF

# Install mistral
WORKDIR /src/mistral
RUN git clone https://opendev.org/openstack/mistral.git . -b stable/2026.2 && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt .

# Install mistral-extra
WORKDIR /src/mistral-extra/
RUN git clone https://opendev.org/openstack/mistral-extra.git . -b stable/2026.2 && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/mistral/bin/pip install PyMySQL python-memcached redis -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/mistral/bin/pip install uwsgi

RUN ln -s /opt/openstack/mistral/bin/mistral-server /usr/local/bin/

# Custom oslo.messaging
RUN /opt/openstack/mistral/bin/pip install git+https://github.com/arnaudmorin/oslo.messaging.git@stable/2026.2
# NOTE(arnaud) BlazingMQ SDK with authentication and TLS, from the fork until it is released upstream
RUN /opt/openstack/mistral/bin/pip install https://github.com/arnaudmorin/blazingmq-sdk-python/releases/download/v1.2.3-secure.e307e1a/blazingmq-1.2.3-cp313-cp313-manylinux_2_28_x86_64.whl

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/mistral /opt/openstack/mistral
COPY data/uwsgi.ini /etc/uwsgi/mistral.ini

USER root
# For api
# /opt/openstack/mistral/bin/uwsgi --ini /etc/uwsgi/mistral.ini
# uwsgi will work only when https://review.opendev.org/c/openstack/mistral/+/959603 will be merged

# For other services
# /opt/openstack/mistral/bin/mistral-server --server executor --config-file /etc/mistral/mistral.conf
# /opt/openstack/mistral/bin/mistral-server --server engine --config-file /etc/mistral/mistral.conf

# For dev purpose (api will have only one worker)
CMD [ "dumb-init", "--single-child", "--" , "/opt/openstack/mistral/bin/mistral-server", "--server", "all", "--config-file", "/etc/mistral/mistral.conf" ]
