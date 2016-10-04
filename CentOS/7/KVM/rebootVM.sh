#!/bin/bash

################################
# This script will reboot a VM #
################################

read -p "What is the name of the VM? " vmName

sudo virsh reboot $vmName
