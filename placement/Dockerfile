#
# Builder
#
FROM debian:trixie-slim AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip python3-dev git libpcre2-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git config --global user.email "arnaud.morin@gmail.com" && git config --global user.name "Arnaud M."

# Create venv
WORKDIR /opt/openstack/
RUN python3 -m venv placement && \
    /opt/openstack/placement/bin/pip install --upgrade pip setuptools

# Install placement
WORKDIR /src/placement
RUN git clone https://opendev.org/openstack/placement.git . -b master && \
    /opt/openstack/placement/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/placement/bin/pip install PyMySQL python-memcached redis -c https://opendev.org/openstack/requirements/raw/branch/master/upper-constraints.txt

# Install uwsgi, with internal routing support from libpcre2-dev
RUN /opt/openstack/placement/bin/pip install uwsgi

RUN ln -s /opt/openstack/placement/bin/placement-server /usr/local/bin/

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 libpcre2-8-0 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/placement /opt/openstack/placement

USER root
# For dev purpose (api will have only one worker)
CMD [ "/opt/openstack/placement/bin/uwsgi", "--http", ":8778", "--wsgi-file", "/opt/openstack/placement/bin/placement-api" ]
