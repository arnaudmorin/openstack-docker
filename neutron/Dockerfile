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

# Install neutron
WORKDIR /src/neutron
RUN git clone https://opendev.org/openstack/neutron.git . -b stable/2025.2 && \
    /opt/openstack/neutron/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.2/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/neutron/bin/pip install PyMySQL python-memcached -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.2/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/neutron/bin/pip install uwsgi

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
COPY --from=builder /src/neutron/etc/api-paste.ini /etc/neutron/api-paste.ini

USER root
CMD [ "dumb-init", "--single-child", "--" , "/opt/openstack/neutron/bin/neutron-server"]
