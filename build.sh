#!/bin/bash

find * -maxdepth 0 -type d | while read folder ; do
    cd $folder
    docker build -t arnaudmorin/openstack-${folder}:victoria .
    docker push arnaudmorin/openstack-${folder}:victoria
    cd ..
done
