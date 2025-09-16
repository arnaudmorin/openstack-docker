#
# Builder
#
FROM debian:bookworm-slim AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip python3-dev git \
    && rm -rf /var/lib/apt/lists/*

# Create venv
WORKDIR /opt/openstack/
RUN python3 -m venv keystone && \
    /opt/openstack/keystone/bin/pip install --upgrade pip setuptools

# Install keystone
WORKDIR /src/keystone
RUN git clone https://opendev.org/openstack/keystone.git . -b stable/2025.1 && \
    /opt/openstack/keystone/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/keystone/bin/pip install PyMySQL -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/keystone/bin/pip install uwsgi

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.11 apache2 libapache2-mod-wsgi-py3 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/keystone

COPY --from=builder /opt/openstack/keystone /opt/openstack/keystone

USER root

EXPOSE 5000
CMD [ "dumb-init", "--single-child", "--", "/opt/openstack/keystone/bin/keystone-wsgi-public", "--port", "5000", "--host", "0.0.0.0" ]
