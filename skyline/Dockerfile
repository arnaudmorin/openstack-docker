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
RUN python3 -m venv skyline && \
    /opt/openstack/skyline/bin/pip install --upgrade pip setuptools

# Install skyline-console
RUN /opt/openstack/skyline/bin/pip install -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt https://tarballs.opendev.org/openstack/skyline-console/skyline-console-stable-2025.1.tar.gz

# Install skyline
WORKDIR /src/skyline
RUN git clone https://opendev.org/openstack/skyline-apiserver.git . -b stable/2025.1 && \
    /opt/openstack/skyline/bin/pip install -r requirements.txt -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt .

# Install some extras stuff
RUN /opt/openstack/skyline/bin/pip install PyMySQL -c https://opendev.org/openstack/requirements/raw/branch/stable/2025.1/upper-constraints.txt

#
# Runner
#
FROM debian:bookworm-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.11 nginx \
    vim curl procps \
    && rm -rf /var/lib/apt/list/*

RUN mkdir -p /etc/skyline /var/log/skyline /var/lib/skyline

COPY --from=builder /opt/openstack/skyline /opt/openstack/skyline
COPY --from=builder /src/skyline/skyline_apiserver/db /src/skyline/skyline_apiserver/db

# Copy gunicorn config
COPY --from=builder /src/skyline/etc/gunicorn.py /etc/skyline/gunicorn.py
# Fix from master to work with 2025.1
RUN sed -i -r 's/reuse_port = True/reuse_port = False/' /etc/skyline/gunicorn.py

# Create a script for db-sync
COPY skyline-db-sync /usr/local/bin/skyline-db-sync
RUN chmod +x /usr/local/bin/skyline-db-sync

COPY skyline-start /usr/local/bin/skyline-start
RUN chmod +x /usr/local/bin/skyline-start

EXPOSE 8080

CMD ["/usr/local/bin/skyline-start"]
