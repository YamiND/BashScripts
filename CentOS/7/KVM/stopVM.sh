#!/bin/bash

####################################################
# This script will attempt to gracefully stop a VM #
####################################################

sudo virsh list --all

read -p "What is the name of the VM? " vmName

sudo virsh shutdown $vmName
