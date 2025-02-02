#!/bin/bash

find * -maxdepth 0 -type d | while read folder ; do
    cd $folder
    sudo docker build -t arnaudmorin/openstack-${folder}:master .
    sudo docker push arnaudmorin/openstack-${folder}:master
    cd ..
done
