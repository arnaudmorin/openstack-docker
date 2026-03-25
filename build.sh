#!/bin/bash

find * -maxdepth 0 -type d | while read folder ; do
    cd $folder
    docker build -t antoninruan/openstack-${folder}:2026.1 .
    docker push antoninruan/openstack-${folder}:2026.1
    cd ..
done
