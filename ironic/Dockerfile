#
# Builder
#
FROM debian:trixie-slim AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip python3-dev git libpcre2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global user.email "arnaud.morin@gmail.com" && git config --global user.name "Arnaud M."

# Create venv
WORKDIR /opt/openstack/
RUN python3 -m venv ironic && \
    /opt/openstack/ironic/bin/pip install --upgrade pip setuptools

# Hash of the upstream sources (see upstream-ref.sh), so the build cache
# is invalidated as soon as upstream moves
ARG UPSTREAM_REF

# Install ironic (sushy, the redfish client, comes with its requirements)
WORKDIR /src/ironic
RUN git clone https://opendev.org/openstack/ironic.git . -b stable/2026.2 && \
    /opt/openstack/ironic/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/ironic/bin/pip install PyMySQL python-memcached redis -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt

# Install uwsgi, with internal routing support from libpcre2-dev
RUN /opt/openstack/ironic/bin/pip install uwsgi

# Custom oslo.messaging
RUN /opt/openstack/ironic/bin/pip install git+https://github.com/arnaudmorin/oslo.messaging.git@stable/2026.2
# NOTE(aruan) BlazingMQ SDK with authentication and TLS, from the fork until it is released upstream
RUN /opt/openstack/ironic/bin/pip install https://github.com/arnaudmorin/blazingmq-sdk-python/releases/download/v1.2.3-secure.cdec8fc/blazingmq-1.2.3-cp313-cp313-manylinux_2_28_x86_64.whl

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

# NOTE(aruan) qemu-utils converts the images the conductor serves over http,
# genisoimage builds the config drives
RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 libpcre2-8-0 \
    qemu-utils genisoimage \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/ironic /opt/openstack/ironic

USER root
