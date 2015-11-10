#!/bin/bash

########################################################
# This script will hard stop a VM. Data loss may occur #
########################################################

read -p "What is the name of the VM? " vmName

sudo virsh destroy $vmName


