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

i=1

while [ $i -lt 2 ]; do
echo "This script allows you to manage VM settings"
echo "You can add a VM, remove a VM, and other modifications"
echo ""
echo "What would you like to do today?"

echo "1) Create a VM"
echo "2) Start a VM"
echo "3) Enable/Disable Remote VM access"
echo "4) Delete a VM"
echo "5) Stop a VM"
echo "6) Exit"
echo ""
echo ""

read -p "What would you like to do? [1-6] " choice
case $choice in
	1)
	sh ./createvm.sh
	;;
	2)
	sh ./startvm.sh
	;;
	3)
	sh ./vmremoteview.sh
	;;
	4)
	sh ./deletevm.sh
	;;
	5)
	sh ./stopvm.sh
	;;
	6)
	read -p "Are you sure you want to exit? [y/n] " loop
	if [ "$loop" = 'y' ]
        then
              i=$[ $i + 2 ]
        else
        	clear
	fi
	;;
esac

done
