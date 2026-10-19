#!/bin/bash

find * -maxdepth 0 -type d | while read folder ; do
    cd $folder
    docker build -t arnaudmorin/openstack-${folder}:2026.2 .
    docker push arnaudmorin/openstack-${folder}:2026.2
    cd ..
done
