#!/bin/bash
echo "Easy way to create new VirtualBox VMs"
echo "Reduces the amount of redundant typing"
echo ""

read -p "Please enter a name for this VM: " name 

#echo $name

VBoxManage createvm --name $name --register

read -p "Please enter the size of the HD you would like to use in MB: " size

#echo $size

VBoxManage createhd --filename $name --size $size

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

echo ""
echo "Now we need to decide how much RAM this VM gets"
read -p "Please enter the amount in MB: " ram

#echo $ram
VBoxManage modifyvm $name --memory $ram
VBoxManage storagectl $name --name IDE --add ide --controller PIIX4 --bootable on
VBoxManage storagectl $name --name SATA --add sata --controller IntelAhci --bootable on

echo "Now we need to select where our ISO is that we will first boot from"
echo "Please tell me where the ISO is located on your system "
read -p "and the name of the iso: " iso
VBoxManage storageattach $name --storagectl IDE --port 0 --device 0 --type dvddrive --medium "`echo $iso`"

echo ""
echo "How much RAM should the virtual graphics card have?"
read -p "Please enter the size in megabytes: " vram

VBoxManage modifyvm $name --vram $vram --accelerate3d on --audio alsa --audiocontroller ac97

echo ""
echo "Now we can set up a NIC, or multiple"
echo "This script will keep looping until you choose not to add one"" 
echo "1): Add/Modify a NIC"
echo "2): I'm done here"
read -p "Do you want to add a NIC? [1-2]" network
i=$network

while [ $i -ne "2" ]; do
	echo ""
	read -p "Please enter the NIC you would like to add/modify" nic
	echo ""
	echo "What type of networking mode would you like to use?"
	echo "Your choices are: "
	echo ""
	echo "1) NAT"
	echo "2) Bridged"
	read -p "Please enter the number for the type you want" mode
	echo ""
	case $mode in
		1)
		VBoxManage modifyvm $name --$nic nat --nictype1 82540EM --cableconnected1 on
		;;		
		2)
		VBoxManage modifyvm $name --$nic bridged --nictype1 82540EM --cableconnected1 on
		;;
	esac
	echo ""
	read -p "Would you like to add another NIC?" choice
		if [ $choice -ne "y" ]
			then
				$i="2"
		fi
done

	echo ""
	read -p "Do you want to start the VM now? [y/n]" start
	case $start in
		y)
		VBoxHeadless --startvm $name
		;;
		n)
		echo ""
		echo "The script will now exit"
		exit
		;;
	esac

echo "Your Virtual Machine should be all set up!"

