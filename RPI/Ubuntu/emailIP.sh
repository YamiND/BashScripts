#!/bin/bash

###########################
# Require running as root #
###########################

if [[ $EUID -ne 0 ]]; then
 	echo "You must be a root user or run with sudo" 2>&1
 	exit 1
fi

# Get System's IP(s)
PI_IP=$(ip route get 1 | awk '{print $NF;exit}')

# Email to send IP to
EMAIL=""

# Install mail program to email user
# Select Internet Site and follow through the prompts going with defaults
apt -y install mailutils

# Send the email
echo -e "IP Address(es) for your PI are such: $PI_IP" | mail -s "PI IP" "$EMAIL"

