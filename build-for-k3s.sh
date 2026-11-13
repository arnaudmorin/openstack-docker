#!/bin/bash
# Build images and import them in k3s as ghcr.io/arnaudmorin/openstack-<folder>:master
#   ./build-for-k3s.sh [folder...]   (default: all folders)
# Logs land in /var/log/build-<folder>.log, JOBS images are built in parallel.
cd $(dirname $(readlink -f $0))
export JOBS=${JOBS:-4}

build() {
    local image=ghcr.io/arnaudmorin/openstack-$1:master
    echo "building $image"
    docker build -t $image $1 &> /var/log/build-$1.log &&
        docker save $image | k3s ctr images import - >> /var/log/build-$1.log &&
        echo "built $image" && return
    echo "FAILED to build $image, see /var/log/build-$1.log"
    return 1
}
export -f build

if [ $# -eq 0 ]; then
    set -- $(find * -maxdepth 0 -type d)
fi
printf '%s\n' "$@" | xargs -P $JOBS -I{} bash -c 'build {}'
