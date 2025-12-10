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
RUN python3 -m venv barbican && \
    /opt/openstack/barbican/bin/pip install --upgrade pip setuptools

# Install barbican
WORKDIR /src/barbican
RUN git clone https://opendev.org/openstack/barbican.git . -b stable/2025.2 && \
    /opt/openstack/barbican/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.2/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/barbican/bin/pip install PyMySQL python-memcached -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.2/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/barbican/bin/pip install uwsgi

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 sudo qemu-utils nfs-common \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/barbican /opt/openstack/barbican
COPY --from=builder /src/barbican/etc/barbican /etc/barbican
