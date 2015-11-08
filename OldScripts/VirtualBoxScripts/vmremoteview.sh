#!/bin/bash
#
#     Copyright (C) 2015  Tyler Postma (Yami)
#
#     This program is free software; you can redistribute it and/or
#     modify it under the terms of the GNU General Public License
#     as published by the Free Software Foundation; either version 2
#     of the License, or (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software
#     Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
clear
echo "VirtualBox allows a Remote Desktop-like service for its VMs"
echo "While insecure over a network, it is handy for a first time startup"
echo "if the VM is not on your physical machine"
echo ""
echo ""
echo "Here are a list of your VMs: "
VBoxManage list vms
echo ""
echo ""
read -p "What is the name of the VM? " name
echo ""
echo "Would you like to: "
echo "1) Start Remote VM View"
echo "2) Disable Remote VM View"
read -p "Choice? [1-2] " choice
	case $choice in 
		1)
		echo "Please enter the IP address of the host machine that the"
		echo "VM will be running on"
		echo ""
		read -p "Host OS' IP address? " ip
		read -p "Port to listen on? " port
		VBoxManage modifyvm $name --vrde on --vrdeport $port --vrdeaddress $ip
		echo ""
		echo "If it is on, the VM should be accessible at $ip:$port "
		;;
		2)
		VBoxManage modifyvm $name --vrde off
		echo ""
		echo "Remote view of $name should be disabled"
		;;
	esac
		