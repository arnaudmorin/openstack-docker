#!/bin/bash

# Start rabbit
eval $(/opt/openstack/mistral/bin/pifpaf run rabbitmq)

# Configure transport_url
export OS_DEFAULT__TRANSPORT_URL=$PIFPAF_URL

# Start mistral all-in-one
/opt/openstack/mistral/bin/mistral-server
