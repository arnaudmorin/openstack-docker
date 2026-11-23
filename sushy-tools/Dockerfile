#
# Builder
#
FROM debian:trixie-slim AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip git \
    && rm -rf /var/lib/apt/lists/*

# Create venv
WORKDIR /opt/openstack/
RUN python3 -m venv sushy-tools && \
    /opt/openstack/sushy-tools/bin/pip install --upgrade pip setuptools

# Hash of the upstream sources (see upstream-ref.sh), so the build cache
# is invalidated as soon as upstream moves
ARG UPSTREAM_REF

# NOTE(aruan) sushy-tools has no stable branch, and no release has the rescue based
# PXE boot of its nova driver yet (2.2.0 is older): pin the master commit tested with it
ARG SUSHY_TOOLS_COMMIT=30fd6a95d0f74a0cce2c6a31b9583162ba7c12d9

# Install sushy-tools, and openstacksdk for its nova driver
WORKDIR /src/sushy-tools
RUN git clone https://opendev.org/openstack/sushy-tools.git . && \
    git checkout ${SUSHY_TOOLS_COMMIT} && \
    /opt/openstack/sushy-tools/bin/pip install -c https://opendev.org/openstack/requirements/raw/branch/stable/2026.2/upper-constraints.txt . openstacksdk

#
# Runner
#
FROM debian:trixie-slim
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y \
    python3 dumb-init libpython3.13 \
    vim curl procps \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openstack/sushy-tools /opt/openstack/sushy-tools

USER root

EXPOSE 8000
CMD [ "dumb-init", "--single-child", "--", "/opt/openstack/sushy-tools/bin/sushy-emulator" ]
