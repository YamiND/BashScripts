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

i=1
while [ $i -lt 2 ]; do
clear
echo "This script will clone a VM for you"
echo "The VM will need to be off for this script to work"
echo ""
echo ""

read -p "Is the VM off? [y/n] " choice
	case $choice in 
		y)
		;;
		n)
		sh ./stopvm.sh
		;;
	esac
echo ""
echo ""
echo "Here is a list of VMs"
VBoxManage list vms

read -p "What is the name of the VM  you wish to clone? " name
read -p "What would you like to call the copy? " clone
	VBoxManage clonevm $name --name $clone --register

echo ""
echo ""
echo "Your VM should now be cloned"
read -p "Would you like to clone another? [y/n] " repeat
if [ "$repeat" = 'n' ]
        then
              i=$[ $i + 2 ]
fi

done 