#!/bin/bash

while true;
do

echo "This script allows you to access various KVM controls easily"
echo ""
echo "What would you like to do today?"

echo ""
echo "1) Create a VM"
echo "2) Remove a VM"
echo "3) Start a VM"
echo "4) Reboot a VM"
echo "5) Stop a VM gracefully"
echo "6) Hard stop a VM"
echo "7) List a VM's state"
echo "8) List VMs and status"
echo "9) List Storage Pools"
echo "10) Exit "

read -p "Please select an option: " choice

case $choice in
	1)
	sh ./installVM.sh
	;;
	2)
	sh ./removeVM.sh
	;;
	3)
	sh ./startVM.sh
	;;
	4)
	sh ./rebootVM.sh
	;;
	5)
	sh ./stopVM.sh
	;;
	6)
	sh ./hardStopVM.sh
	;;
	7)
	sh ./stateVM.sh
	;;
	8)
	sh ./listVM.sh
	;;
	9)
	sh ./listPools.sh
	;;	
	10)
	break
	;;
esac
done
