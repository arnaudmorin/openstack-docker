#!/bin/bash

shopt -s expand_aliases
alias nova-manage="/opt/openstack/nova/bin/nova-manage"

nova-manage api_db sync || exit 1
nova-manage cell_v2 map_cell0 || exit 1

nova-manage cell_v2 list_cells | grep cell1 > /dev/null

if ! [ $? ]; then
    nova-manage cell_v2 create_cell --name=cell1 --verbose || exit 1
fi

nova-manage db sync
