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
RUN python3 -m venv nova && \
    /opt/openstack/nova/bin/pip install --upgrade pip setuptools

# Install nova
WORKDIR /src/nova
RUN git clone https://opendev.org/openstack/nova.git . -b stable/2025.1 && \
    /opt/openstack/nova/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/nova/bin/pip install PyMySQL -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/nova/bin/pip install uwsgi

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.11 \
    novnc spice-html5 websockify \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/nova /opt/openstack/nova
COPY --from=builder /src/nova/etc/nova/api-paste.ini /etc/nova/api-paste.ini
COPY data/init.sh /opt/openstack/bin/nova/init.sh

USER root
#CMD [ "dumb-init", "--single-child", "--" , "/opt/openstack/neutron/bin/neutron-server"]
