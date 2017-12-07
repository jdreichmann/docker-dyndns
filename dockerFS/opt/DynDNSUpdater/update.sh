#!/bin/bash

# Where the 'old' IP Adress is stored
IP_STORE="current-ip.txt"

# Where the update should be sent to
HTTP_USER=""
HTTP_PASS=""
URL=""
HOSTNAME_PARAM="hostname"
HOSTNAME_VALUE=""
OWN_IP_PARAM="myip"

# Retrieve current IP adress
CURRENT_IP=$(curl -s $INFO_URL | python3 -c "import sys, json; print(json.load(sys.stdin)['IPv4'])")
echo "current IP is: $CURRENT_IP \n"

# Load 'old' IP
STORED_IP=$(cat $IP_STORE)
echo "stored IP is: $STORED_IP \n"

if [[ ! $STORED_IP == $CURRENT_IP ]]; then
	# Make an update
	curl -u ${HTTP_USER}:${HTTP_PASS} "${URL}?${HOSTNAME_PARAM}=${HOSTNAME_VALUE}&${OWN_IP_PARAM}=${CURRENT_IP}"
fi;
