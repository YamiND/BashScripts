#!/bin/bash

#######################################
# This script will start a VM by name #
#######################################

sudo virsh list --all

read -p "What is the name of the VM? " vmName

sudo virsh start $vmName
