#!/bin/bash
clear
echo "This script will start a VM headless"
echo "All you need to do is supply a name"
echo "Windows apparently doesn't like starting headless"
echo "Either that or I'm taking shortcuts"
echo "For future reference, you can supply a single command line argument"
echo "To start a VM. Example:"
echo "./startvm.sh Ubuntu  -- where Ubuntu is the name of the VM"
echo "VMs with name spaces have issues"
echo ""

i=1
if [ "$#" -ne 1 ]; then

while [ $i -lt 2 ]; do
read -p "What is the name of the VM you wish to start? " name
VBoxManage startvm $name --type headless

read -p "Do you wish to start another VM? [y/n] " continue
	 if [ "$continue" = 'n' ]
                        then
                                i=$[ $i + 2 ]
                fi
done

else
	VBoxManage startvm $1 --type headless

fi
