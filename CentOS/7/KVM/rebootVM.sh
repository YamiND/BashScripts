#!/bin/sh

################################
# This script will reboot a VM #
################################

read -p "What is the name of the VM? " vmName

virsh reboot $vmName
