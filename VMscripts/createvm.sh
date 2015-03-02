#!/bin/bash
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

clear
echo "Easy way to create new VirtualBox VMs"
echo "Reduces the amount of redundant typing"
echo "This is meant for server VMs, but it should be fine"
echo "for normal VM creation"
echo ""

read -p "Please enter a name for this VM: " name 
VBoxManage createvm --name $name --register

read -p "Please enter the size of the HD you would like to use in MB: " size

VBoxManage createvdi --filename ~/VirtualBox\ VMs/$name/$name.vdi --size $size
VBoxManage storagectl "$name" --name "SATA Controller" --add sata
VBoxManage storagectl "$name" --name "IDE Controller" --add ide
VBoxManage storageattach "$name" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/$name/$name.vdi

echo ""
echo "We need to tell Virtualbox what our OS type is"
echo "I have a prebuilt selection available, but if you're an advanced user,"
echo "you can opt to enter the ID manually"
echo ""

read -p "Would you like to enter the ID manually? [y/n] " advanced
case $advanced in 
	y)
	echo ""
	read -p "Would you like to see the list of OS types [y/n]? " list
	case $list in
		y)
		VBoxManage list ostypes
		;;
		n)
		;;
	esac 

	read -p "Please enter the OS ID: " ostype
	VBoxManage modifyvm $name --ostype $ostype
	;;

	n)
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
	;;
esac
 
echo ""
echo "Now we need to decide how much RAM this VM gets"

read -p "Please enter the amount in MB: " ram

echo "Now we need to select where our ISO is that we will first boot from"
echo "Make sure to enter the full directory path (absolute path); relative access doesn't work"
echo "Your current directory is `pwd`"
echo "an example directory would be /home/username/Documents"
echo ""
echo ""
read -p "Please tell me the directory where the ISO is located on your system: " dir
echo ""

read -p "Name of the iso in the directory: " iso

VBoxManage storageattach "$name" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium $(echo "$dir/$iso")
VBoxManage modifyvm "$name" --memory $ram --acpi on --boot1 dvd 
echo ""
echo ""
echo ""
echo "Now we can set up a NIC, or multiple"
echo "This script will keep looping until you choose not to add one"
echo "1) Add/Modify a NIC"
echo "2) I'm done here"

read -p "Choose an option [1-2]: " network
i=`echo $network`

while [ $i -lt 2 ]; do
	echo ""
	read -p "Please enter the NIC you would like to add/modify [1,2,3,4, as applicable]: " nic
	echo ""
	echo "What type of networking mode would you like to use? "
	echo "Your choices are: "
	echo ""
	echo "1) NAT"
	echo "2) Bridged"
	read -p "Please enter the number for the type you want: " mode
	echo ""
	case $mode in
		1)
		VBoxManage modifyvm $name --nic$nic nat --nictype1 82540EM --cableconnected1 on
		;;		
		2)
		echo ""
		echo "We need the host interface adapter that will be bridged"
		echo "Unix systems can typically run ifconfig to see their adapter names"
		echo "Usual ones are eth0-N, en0-N, em0-N, wlan0-N, etc"
		echo ""
		read -p "Please enter the adapter name/number: " adapter
		VBoxManage modifyvm $name --nic$nic bridged --nictype1 82540EM --cableconnected1 on --bridgeadapter1 $adapter 
		;;
	esac
	echo ""
	read -p "Would you like to add another NIC? [y/n] " choice
		if [ "$choice" = 'n' ]
			then
				i=$[ $i + 2 ]
		fi
done

read -p "Would you like to mess with Remote View? [y/n] " remote
	if [ "$remote" = 'y' ]
			then
		sh ./vmremoteview.sh
	fi
echo ""
read -p "Do you want to start the VM now? [y/n] " start
case $start in
	y)
	VBoxManage startvm $name --type headless 
	;;
	n)
	echo ""
	;;
esac

echo "Your Virtual Machine should be all set up!"
