#
# Builder
#

# NOTE(arnaud) this is a local build I did locally from mistral src folder
FROM openstack-mistral:latest AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install mistral-extra
WORKDIR /src/mistral-extra/
RUN git clone https://opendev.org/openstack/mistral-extra.git . -b stable/2025.1 && \
    /opt/openstack/mistral/bin/pip install -r requirements.txt && \
    /opt/openstack/mistral/bin/pip install .

# Install some extras stuff
RUN /opt/openstack/mistral/bin/pip install PyMySQL -c https://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/mistral /opt/openstack/mistral

USER root
CMD [ "dumb-init", "--single-child", "--" , "/opt/openstack/mistral/bin/mistral-server", "--server", "all", "--config-file", "/etc/mistral/mistral.conf" ]
