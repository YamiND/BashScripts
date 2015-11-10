#!/bin/bash

read -p "Do you wish to enable or disable autostart? [enable/disable] " autoChoice

sudo virsh list --all

read -p "What is the name of the VM? " vmName

case $autoChoice in
	enable)
 	sudo virsh autostart $vmName
	;;

	disable)
	sudo virsh autostart --disable $vmName
	;;
esac
