#!/bin/bash

CONFIG="/opt/DynDNSUpdater/config"

# Source the config file or exit if it cannot be found
if [[ -e "${CONFIG}" ]]; then
	. "${CONFIG}"
elif [[ ! -e "${CONFIG}" ]]; then
	echo "FATAL Config file ('${CONFIG}') not found"
	exit 1
fi;

# Retrieve current IP adress
CURRENT_IP=$(curl -s $URL_INFO | python3 -c "import sys, json; print(json.load(sys.stdin)['IPv4'])")
echo "Current IP is: $CURRENT_IP"

# Load 'old' IP
if [[ -e $IP_STORE ]]; then
	STORED_IP=$(cat $IP_STORE)
	echo "Stored IP is: $STORED_IP"
elif [[ ! -e $IP_STORE ]]; then
	# Create the file to store the IP inside
	touch $IP_STORE
	echo "No IP previously stored, creating IP Store"
fi;

if [[ ! $STORED_IP == $CURRENT_IP ]]; then
	# Make an update
	ANSWER=$(curl -sS -u ${HTTP_USER}:${HTTP_PASS} \
	"${URL_UPDATE}?${HOSTNAME_PARAM}=${HOSTNAME_VALUE}&${OWN_IP_PARAM}=${CURRENT_IP}")
	echo "Answer from DynDNS-Update-Service: $ANSWER"
	echo $CURRENT_IP > $IP_STORE
	echo "Saved current IP into IP Store"
elif [[ $STORED_IP == $CURRENT_IP ]]; then
	echo "IP Adresses match, no update is required"
fi;
