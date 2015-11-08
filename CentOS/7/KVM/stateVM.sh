#!/bin/bash

#####################################################
# This script will list the current state of the VM #
#####################################################

read -p "What is the name of the VM? " vmName

virsh domname $vmName
