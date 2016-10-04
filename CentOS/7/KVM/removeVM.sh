#!/bin/bash

#############################################################
# Please Read: 						                        #
#							                                # 
# This script assumes the images are of the extension .img  #
# This script will remove a VM and delete it		        #
############################################################# 

sudo virsh list --all
sudo virsh pool-list

read -p "What is the name of the VM? " vmName
read -p "What is the name of the storage pool? " vmPool

vmStorage="$vmName.img"

sudo virsh destroy $vmName
sudo virsh undefine $vmName
sudo virsh vol-delete --pool $vmPool $vmStorage

echo "The VM should now be removed"
