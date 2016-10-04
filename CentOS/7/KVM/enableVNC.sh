#!/bin/bash

sudo virsh list --all

read -p "What is the name of the VM? " vmName

vmConfig="/etc/libvirt/qemu/"$vmName".xml"
vmStatus=$(sudo virsh list --all | grep "$vmName" | awk '{print $3}')

sudo sed -i "/<\/devices>/i <graphics type='vnc' port='-1' autoport='yes'\/>" $vmConfig

sudo systemctl restart libvirtd

if [ "$vmStatus" == "running" ]
then
    echo "$vmName must be restarted to complete the action\n"
    read -p "Do you wish to restart $vmName now? [y/n] " choice

    case $choice in
        y)
            sudo virsh reboot $vmName
            ;;
        n)
            echo "The changes will take place when $vmName is restarted"
            ;;
    esac 
else
    read -p "Do you wish to start $vmName now? [y/n] " choice

    case $choice in
        y)
            sudo virsh start $vmName
            ;;
        n)
            echo "VNC will work when $vmName is turned on"
            ;;
    esac
fi
