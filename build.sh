#!/bin/bash

find * -maxdepth 0 -type d | while read folder ; do
    cd $folder
    sudo docker build -t arnaudmorin/openstack-${folder}:2025.2 .
    sudo docker push arnaudmorin/openstack-${folder}:2025.2
    cd ..
done
