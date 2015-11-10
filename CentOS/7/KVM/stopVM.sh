#!/bin/bash

####################################################
# This script will attempt to gracefully stop a VM #
####################################################

read -p "What is the name of the VM? " vmName

sudo virsh shutdown $vmName
