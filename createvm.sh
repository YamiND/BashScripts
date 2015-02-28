#!/bin/bash

read -p "Please enter a name for this VM: " name 

echo $name

#VBoxManage createvm --name $name --register

read -p "Please enter the size of the HD you would like to use in MB: " size

echo $size

#VBoxManage createhd --filename $name --size $size

echo "We need to tell Virtualbox what our OS type is"
echo "We're not dealing with MicroCrap VMs"
echo "Please select a number below"
echo ""
echo "1) Ubuntu (32 bit)"
echo "2) Ubuntu (64 bit)"
echo "3) Debian (32 bit)"
echo "4) Debian (64 bit)"
echo "5) Arch Linux (32 bit)"
echo "6) Arch Linux (64 bit)"
echo "7) Other Linux (32 bit)"
echo "8) Other Linux (64 bit)"
echo ""

read -p "[1-8]: " ostype

#echo $ostype

case $ostype in
	1)
	VBoxManage modifyvm $name --ostype Ubuntu
	;;
	2)
	VBoxManage modifyvm $name --ostype Ubuntu_64
	;;
	3)
	VBoxManage modifyvm $name --ostype Debian
	;;
	4)
	VBoxManage modifyvm $name --ostype Debian_64
	;;
	5)
	VBoxManage modifyvm $name --ostype ArchLinux
	;;
	6)
	VBoxManage modifyvm $name --ostype ArchLinux_64
	;;
	7)
	VBoxManage modifyvm $name --ostype Linux
	;;
	8)
	VBoxManage modifyvm $name --ostype Linux_64
	;;
esac

 
# For adding other supported Operating Systems, you can run
# VBoxManage list ostypes
# To get the full supported list of OSs
# I just didn't want to flood the script with options 
# The line below this one just shows where you manually would add in the type
# VBoxManage modifyvm --ostype Ubuntu
