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
RUN python3 -m venv cinder && \
    /opt/openstack/cinder/bin/pip install --upgrade pip setuptools

# Install cinder
WORKDIR /src/cinder
RUN git clone https://opendev.org/openstack/cinder.git . -b stable/2025.1 && \
    /opt/openstack/cinder/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/cinder/bin/pip install PyMySQL python-memcached -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/cinder/bin/pip install uwsgi

# Custom oslo.messaging
RUN /opt/openstack/cinder/bin/pip install git+https://github.com/arnaudmorin/oslo.messaging.git@master
RUN /opt/openstack/cinder/bin/pip install blazingmq

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 sudo qemu-utils nfs-common \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/cinder /opt/openstack/cinder
COPY --from=builder /src/cinder/etc/cinder /etc/cinder

RUN ln -s /opt/openstack/cinder/bin/cinder-rootwrap /usr/bin/cinder-rootwrap
RUN ln -s /opt/openstack/cinder/bin/privsep-helper /usr/bin/privsep-helper
