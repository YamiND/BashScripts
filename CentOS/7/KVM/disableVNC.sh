#!/bin/bash

read -p "Name of VM? " vmName

vmConfig="/etc/libvirt/qemu/"$vmName".xml"

sudo sed -i "/<graphics type='vnc'/d" $vmConfig

sudo systemctl restart libvirtd
