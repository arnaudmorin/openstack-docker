#
# Builder
#
FROM ubuntu:24.04 AS builder
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    build-essential \
    cmake \
    curl \
    python3 \
    ninja-build \
    pkg-config \
    bison \
    libfl-dev \
    libbenchmark-dev \
    libgmock-dev \
    libz-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

ENV PATH=${PATH}:/workspace/srcs/bde-tools/bin
ENV PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig:/opt/bb/lib64/pkgconfig

# Download and build BlazingMQ dependencies (BDE, NTF)
# Then download and build BlazingMQ from source
ARG BMQ_VERSION=main
RUN set -eux \
    && mkdir -p srcs bin \
    # -- fetch build_deps.sh and run it to build BDE + NTF --
    && curl -SL "https://github.com/bloomberg/blazingmq/archive/refs/heads/${BMQ_VERSION}.tar.gz" \
       | tar -xzC srcs/ \
    && mv srcs/blazingmq-${BMQ_VERSION} srcs/bmq \
    && cp srcs/bmq/docker/build_deps.sh bin/build_deps.sh \
    && chmod +x bin/build_deps.sh \
    && bin/build_deps.sh \
    # -- build BlazingMQ --
    && cd srcs/bmq \
    && cmake -S . -B cmake.bld/Linux -G Ninja \
        -DCMAKE_TOOLCHAIN_FILE=/workspace/srcs/bde-tools/BdeBuildSystem/toolchains/linux/gcc-default.cmake \
        -DCMAKE_BUILD_TYPE=RelWithDebInfo \
        -DBDE_BUILD_TARGET_SAFE=ON \
        -DBDE_BUILD_TARGET_64=ON \
        -DBDE_BUILD_TARGET_CPP23=ON \
        -DCMAKE_PREFIX_PATH=/workspace/srcs/bde-tools/BdeBuildSystem \
        -DCMAKE_INSTALL_LIBDIR=lib64 \
    && cmake --build cmake.bld/Linux --parallel 8 --target bmqbrkr bmqtool \
    && cmake --install cmake.bld/Linux --prefix=/bmq --component bmqbrkr \
    && cmake --install cmake.bld/Linux --prefix=/bmq --component bmqtool \
    && mv /bmq/bin/bmqbrkr.tsk /bmq/bin/bmqbrkr \
    && mv /bmq/bin/bmqtool.tsk /bmq/bin/bmqtool \
    && rm -rf /workspace

#
# Runner
#
FROM ubuntu:24.04
LABEL maintainer="Arnaud Morin <arnaud.morin@gmail.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
    dumb-init \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /bmq /usr/local

RUN groupadd bmq \
    && useradd bmq --home /var/local/bmq --system --gid bmq --shell /usr/bin/bash

USER bmq
WORKDIR /var/local/bmq
RUN mkdir -p logs storage/archive

CMD [ "dumb-init", "--single-child", "--", "/usr/local/bin/bmqbrkr", "/etc/local/bmq" ]
