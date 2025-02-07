
#
# Builder
#

FROM debian:bookworm-slim AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/openstack/

RUN python3 -m venv mistral && \
    /opt/openstack/mistral/bin/pip install --upgrade pip setuptools

# Install mistral
RUN cd /tmp/ && git clone https://opendev.org/openstack/mistral.git && cd mistral && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt && \
    /opt/openstack/mistral/bin/pip install .

# Install mistral-extra
RUN cd /tmp/ && git clone https://opendev.org/openstack/mistral-extra.git && cd mistral-extra && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt && \
    /opt/openstack/mistral/bin/pip install .

# Install some extras stuff
RUN /opt/openstack/mistral/bin/pip install PyMySQL -c https://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt

# I use pifpaf to start rabbitmq
RUN /opt/openstack/mistral/bin/pip install pifpaf

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init rabbitmq-server \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/mistral /opt/openstack/mistral
COPY data/start.sh /usr/local/bin/mistral-start.sh

RUN chmod +x /usr/local/bin/mistral-start.sh

USER root
