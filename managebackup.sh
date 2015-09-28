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
cd BackupScripts/
i=1


while [ $i -lt 2 ]; do
echo "This script allows you to manage various Backups"
echo "You can backup containers, backup individual web directories and mysql"
echo "Please note that these scripts backup to a remote location via scp"
echo "This will require SSH access to the remote machine"
echo ""
echo "What would you like to do today?"

echo "1) Backup a single lxc container"
echo "2) Backup all lxc containers in /var/lib/lxc"
echo "3) Backup an individual web directory and its corresponding mysql database"
echo "4) Backup all containers and the home directory of the main server"
echo "5) Exit"
echo ""
echo ""

read -p "What would you like to do? [1-6] " choice
case $choice in
	1)
	sh ./lxc_backup_single.sh
	;;
	2)
	sh ./lxc_backup_all.sh
	;;
	3) 
	sh ./website_backup.sh
	;;
	4)
	sh ./powerhouse_backup.sh
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
