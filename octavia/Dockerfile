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
RUN python3 -m venv octavia && \
    /opt/openstack/octavia/bin/pip install --upgrade pip setuptools

# Install octavia
WORKDIR /src/octavia
RUN git clone https://opendev.org/openstack/octavia.git . -b stable/2026.1 && \
    /opt/openstack/octavia/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/octavia/bin/pip install PyMySQL python-memcached -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.1/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/octavia/bin/pip install uwsgi

# Custom oslo.messaging
RUN /opt/openstack/octavia/bin/pip install git+https://github.com/arnaudmorin/oslo.messaging.git@master
RUN /opt/openstack/octavia/bin/pip install blazingmq

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/octavia /opt/openstack/octavia
