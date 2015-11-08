#!/bin/bash

#############################################################
# Please Read: 						    #
#							    # 
# This script assumes the images are of the extension .img  #
#							    #
############################################################# 

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

virsh list
virsh pool-list

read -p "What is the name of the VM? " vmName
read -p "What is the name of the storage pool? " vmPool

vmStorage="$vmName.img"

virsh destroy $vmName
virsh undefine $vmName
virsh vol-delete --pool $vmPool $vmStorage

echo "The VM should now be removed"
