#!/bin/bash

# This script must be ran as root
# This script only asks for the name, and that can be supplied as an argument
# This assumes ubuntu 14.04 for the install. If you update this, you need to change
# the vmOS to reflect this

sudo virsh list --all

read -p "What do you want to call the VM? " vmName

vmDescription="Ubuntu"
vmISO=~/ubuntuServer.iso
vmGeneric="ubuntu"
vmOS="ubuntutrusty"
vmCPU="4"
vmRAM="4096"
vmSpace="30"
vmGraphics="vnc"
vmNetwork="br0"
vmAutoStart="y"
vmLocation="/var/lib/libvirt/images/$vmName.img,bus=virtio,size=$vmSpace"
currentVNC=$(grep --exclude-dir={autostart,networks} "<graphics type='vnc'" /etc/libvirt/qemu/* | cut -d"/" -f5 | cut -d"." -f1)

# Remove VNC from any Configs and reboot the VMs if they are running
if grep --quiet --exclude-dir={autostart,networks} "<graphics type='vnc'" /etc/libvirt/qemu/* 
then
    for vm in $currentVNC
    do
        vmConfig="/etc/libvirt/qemu/"$vm".xml"
        vmStatus=$(sudo virsh list --all | grep "$vm" | awk '{print $3}')

        sudo sed -i "/<graphics type='vnc'/d" $vmConfig
        if [ "$vmStatus" == "running" ]
        then
           sudo virsh reboot $vm
        fi
    done
    sudo systemctl restart libvirtd
fi

# Install the VM
sudo virt-install \
    -n $vmName \
    --description "$vmDescription" \
    --os-type=$vmGeneric \
    --os-variant=$vmOS \
    --ram=$vmRAM \
    --vcpus=$vmCPU \
    --disk path=$vmLocation \
    --graphics $vmGraphics \
    --cdrom $vmISO \
    --network bridge:$vmNetwork

sudo virsh autostart $vmName

echo "You can now access this VM by connecting to the server via VNC"
