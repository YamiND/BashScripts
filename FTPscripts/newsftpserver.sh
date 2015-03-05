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

      echo "This script is meant to be run once on a new system install"
      echo "Or a system where sftp has not already been configured"
      echo "Running this script multiple times may have undesired consequences"
      echo ""
      echo ""
      echo "We can restrict users to their own directory, or give them access to the whole system"
      read -p "Would you like to chroot/jail your users? [y/n] " restrict
      case $restrict in 
            y)
            echo ""
            echo ""
		read -p "What is the group name that you want for ftp users? " groupname
            export groupname=`echo $groupname`
			addgroup --system $groupname
			number=`grep -n "Subsystem" /etc/ssh/sshd_config | cut -d ":" -f1`
      		sed -i "${number}d" /etc/ssh/sshd_config
      		echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config
      		echo "Match Group $groupname" >> /etc/ssh/sshd_config
      		echo "ChrootDirectory %h" >> /etc/ssh/sshd_config
      		echo "X11Forwarding no" >> /etc/ssh/sshd_config
      		echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
      		echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
      		
      		service ssh restart
                  ;;
            n)
            echo ""
            echo ""
            read -p "What is the group name that you want for ftp users? " groupname
                  addgroup --system $groupname
                  number=`grep -n "Subsystem" /etc/ssh/sshd_config | cut -d ":" -f1`
                  sed -i "${number}d" /etc/ssh/sshd_config
                  echo "Subsystem sftp internal-sftp" >> /etc/ssh/sshd_config
                  echo "Match Group $groupname" >> /etc/ssh/sshd_config
                  echo "X11Forwarding no" >> /etc/ssh/sshd_config
                  echo "AllowTcpForwarding no" >> /etc/ssh/sshd_config
                  echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
                  
                  service ssh restart
            ;;
      esac
      read -p "Do you wish to add a user? [y/n] " user
      case $user in 
            y)
            sh ./addftpuser.sh
            ;;
            n)
            ;;
      esac
      echo "Your sftp server should be set up!"