#!/bin/bash

# This script will list VMs that have VNC enabled
# And their status
# Sadly this needs root to check the qemu directory and I don't want to be janky with bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root or with sudo permissions" 1>&2
   exit 1
fi

currentVNC=$(grep --exclude-dir={autostart,networks} "<graphics type='vnc'" /etc/libvirt/qemu/* | cut -d"/" -f5 | cut -d"." -f1)

for vm in $currentVNC
do
    vmStatus=$(sudo virsh list --all | grep "$vm" | awk '{print $3 " " $4}')

    echo "$vm has VNC enabled and is currently $vmStatus"
done
