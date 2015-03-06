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
cd FTPscripts/
i=1


while [ $i -lt 2 ]; do
echo "This script allows you to manage FTP settings"
echo "You can add FTP users, remove FTP users, and more"
echo ""
echo "What would you like to do today?"

echo "1) Add FTP user"
echo "2) Remove FTP user"
echo "3) Setup new SFTP server"
echo "4) Delete SFTP server"
echo "5) Exit"
echo ""
echo ""

read -p "What would you like to do? [1-6] " choice
case $choice in
	1)
	sh ./addftpuser.sh
	;;
	2)
	sh ./removeftpuser.sh 
	;;
	3) 
	sh ./newftpserver.sh
	;;
	4)
	sh ./removeftpserver.sh
	;;
	5)
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