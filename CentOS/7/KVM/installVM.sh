#!/bin/bash

#################################################
# Please read:                                  #
# This script might not need to be run		# 
# as root.					# 
# 						#
# Please consult the Documentation or man page  #
# if you have any difficulties			#
#################################################

while menu=true;
do
	read -p "What do you want to call the VM: " vmName
	read -p "Description of the VM: " vmDescription
	read -p "OS Type (Windows, Linux, etc) " vmOStype
	read -p "Distribution/Version of OS: " vmOSvariant
	read -p "Amount of RAM (in MB) for VM: " vmRAM
	read -p "Amount of Space (in GB) to allocate: " vmSpace
	read -p "Amount of CPUs to allocate: " vmCPUs
	read -p "Graphics Type (vnc, none, etc): " vmGraphics
	read -p "Location and name of bootable iso: " vmISO
	read -p "Name of network Bridge: " vmNetwork

	echo "The information for this VM is:\n
	      VM Name: $vmName
	      VM Description: $vmDescription
	      VM OS Type: $vmOStype
	      VM OS Variant: $vmOSvariant
	      VM RAM: $vmRAM
	      VM Space: $vmSpace
	      VM CPUs: $vmCPUs
	      VM Graphics: $vmGraphics
              Location of ISO: $vmISO
 	      Network Interface: $vmNetwork "

	read -p "Is this information correct? [y/n] " vmInfo
	
	case $vmInfo in
	y)
	break
	;;	
	esac
	
done

vmLocation="/var/lib/libvirt/images/$vmName.img,bus=virtio,size=$vmSpace"

virt-install \
-n $vmName \
--description "$vmDescription" \
--os-type=$vmOStype \
--os-variant=$vmOSvariant \
--ram=$vmRAM \
--vcpus=$vmCPUs \
--disk path=$vmLocation \
--graphics $vmGraphics \
--cdrom $vmISO \
--network bridge:$vmNetwork

echo "You can now access this VM by connecting to the server via VNC"
