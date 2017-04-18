#!/bin/bash

# Run this script on the home server
# This script will require key-based authentication from the NAT'd server to the Relay server

###########################
# Require running as root #
###########################

if [[ $EUID -ne 0 ]]; then
        echo "You must be a root user or run with sudo" 2>&1
        exit 1
fi

# Relay IP
RELAY_IP="35.58.0.104"

# Relay SSH Port
RELAY_SSH_PORT="1069"

# Relay SSH User
RELAY_SSH_USER="ubuntu"

# Install autossh
apt install autossh

# Set up autossh command
autossh -M 10900 -fN -o "PubkeyAuthentication=yes" -o "StrictHostKeyChecking=false" -o "PasswordAuthentication=no" -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R $RELAY_IP:10022:localhost:$RELAY_SSH_PORT $RELAY_SSH_USER@$RELAY_IP
