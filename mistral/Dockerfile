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
RUN python3 -m venv mistral && \
    /opt/openstack/mistral/bin/pip install --upgrade pip setuptools

# Install mistral
WORKDIR /src/mistral
RUN git clone https://opendev.org/openstack/mistral.git . -b stable/2025.1 && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install mistral-extra
WORKDIR /src/mistral-extra/
RUN git clone https://opendev.org/openstack/mistral-extra.git . -b stable/2025.1 && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/mistral/bin/pip install PyMySQL python-memcached -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/mistral/bin/pip install uwsgi

RUN ln -s /opt/openstack/mistral/bin/mistral-server /usr/local/bin/

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.11 \
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
