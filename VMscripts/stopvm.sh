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
echo "This script will stop a VM headless"
echo "All you need to do is supply a name"
echo "For future reference, you can supply a single command line argument"
echo "To start a VM. Example:"
echo "./stop.sh Ubuntu  -- where Ubuntu is the name of the VM"
echo "VMs with name spaces have issues"
echo ""

echo "Here is a list of running VMs: "
VBoxManage list runningvms

i=1
if [ "$#" -ne 1 ]; then

while [ $i -lt 2 ]; do
read -p "What is the name of the VM you wish to stop? " name
VBoxManage controlvm $name poweroff


read -p "Do you wish to stop another VM? [y/n] " continue
	if [ "$continue" = 'n' ]
    	then
    	i=$[ $i + 2 ]
    	clear
    fi
done

else
	VBoxManage controlvm $1 poweroff
fi
