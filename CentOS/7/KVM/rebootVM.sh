#!/bin/bash

################################
# This script will reboot a VM #
################################

sudo virsh list --all

read -p "What is the name of the VM? " vmName

sudo virsh reboot $vmName
