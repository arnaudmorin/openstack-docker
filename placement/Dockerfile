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
RUN python3 -m venv placement && \
    /opt/openstack/placement/bin/pip install --upgrade pip setuptools

# Install placement
WORKDIR /src/placement
RUN git clone https://opendev.org/openstack/placement.git . -b stable/2025.1 && \
    /opt/openstack/placement/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/placement/bin/pip install PyMySQL -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt

# Install uwsgi
RUN /opt/openstack/placement/bin/pip install uwsgi

RUN ln -s /opt/openstack/placement/bin/placement-server /usr/local/bin/

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.11 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/placement /opt/openstack/placement

USER root
# For dev purpose (api will have only one worker)
CMD [ "dumb-init", "--single-child", "--" , "/opt/openstack/placement/bin/placement-api", "--port", "8778", "--host", "0.0.0.0" ]
