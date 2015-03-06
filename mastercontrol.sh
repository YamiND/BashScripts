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
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi
clear

echo "This script allows you to access other scripts of mine in an easy manner"
echo "This script assumes the other scripts are in the same directory as this script"
echo ""
echo ""
echo ""

i=1

while [ $i -lt 2 ]; do

echo "What would you like to do today?"

echo "1) Manage Virtual Machines"
echo "2) Manage FTP server and settings"
echo "3) Start a VNC Service (UNIMPLEMENTED)"
echo "4) Restart Apache (UNIMPLEMENTED)"
echo "5) Create a new Virtual Directory with Apache (UNIMPLEMENTED)"
echo "6) Exit"
echo ""
echo ""

read -p "What would you like to do? [1-7] " choice
case $choice in
	1)
	sh ./managevm.sh
	;;
	2)
	sh ./manageftp.sh
	;;
	3)
	;;
	4)
	;;
	5)
	;;
	6)
	read -p "Are you sure you want to exit? [y/n] " loop
	if [ "$loop" = 'y' ]
              then
              exit
	fi
	;;
esac

read -p "Would you like to do anything else today? [y/n] " loop
	if [ "$loop" = 'n' ]
        then
            i=$[ $i + 2 ]
    	else
    		clear
    fi

done
