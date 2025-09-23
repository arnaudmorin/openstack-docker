#!/bin/bash

if [ -z "$1" ] ; then
    find * -maxdepth 0 -type d | while read folder ; do
        echo $folder
    done
    echo "Which the one to build and push locally? "
    read b
else
    b=$1
fi
pushd ${b}
docker build . -t arnaudmorin/openstack-${b}:local
popd
docker save arnaudmorin/openstack-${b}:local | k3s ctr images import -

echo
echo "Image to use: arnaudmorin/openstack-${b}:local"
