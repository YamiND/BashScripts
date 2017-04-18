#!/bin/bash

###########################
# Require running as root #
###########################

if [[ $EUID -ne 0 ]]; then
        echo "You must be a root user or run with sudo" 2>&1
        exit 1
fi

# Enter the name of the script you want to run at startup
# For Ubuntu 16.04 systems

read -p "Enter name/location of script to run at startup" scriptName
read -p "Enter name to call service for startup" serviceName

cp $scriptName /etc/init.d/$serviceName

chmod 755 /etc/init.d/$serviceName

update-rc.d $serviceName defaults
