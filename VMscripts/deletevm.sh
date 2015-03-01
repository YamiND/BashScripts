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
echo "This script will delete a VM"
echo "Please be careful when using this"
echo "The script writer is not at fault for any data loss"
echo "You have been warned"
i=1
if [ "$#" -ne 1 ]; then

while [ $i -lt 2 ]; do
read -p "What is the name of the VM you wish to delete? " name
	VBoxManage unregistervm $name -delete

read -p "Do you wish to delete another VM? [y/n] " continue
	 if [ "$continue" = 'n' ]
                        then
                                i=$[ $i + 2 ]
                fi
done

else
	VBoxManage unregistervm $1 -delete

fi