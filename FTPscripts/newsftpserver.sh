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
echo "First we need to figure out how we're adding an user(s)"
echo ""
echo ""

echo "1) Add a set of users from a file"
echo "2) Add a single user via the terminal"
echo ""
echo ""
echo "Note: If you add users from a file, each user will be assigned a random password"
echo ""
read -p "What method would you like? [1-2] " choice
echo ""
echo ""
case $restrict in
      y)
      echo "I need to know where the list of usernames are"
      echo "the format you enter the username in the file will be the same way"
      echo "their directories are named"
      echo "Unless it is in the same directory as this script,"
      echo "Please enter the absolute path of the directory"
      echo "The format of a directory looks like: "
      echo "/home/username/Downloads"
      echo ""

      read -p "What is the directory the text file is located in? " dir
      echo ""
      echo "What is the file called?"
      read -p "Please enter the full text file name: "  file
      NAMES="$(< $dir/$file)"

      echo "The file name and location you gave me was $dir/$file"
      read -p "Is this correct? [y/n] " loop
      if [ "$loop" = 'y' ]
        then
            clear
                        
                  echo "Now we need to know where our ftp users will have their main directory"
                  echo "Some common ones are:"
                  echo "/var/www/ftpusers"
                  echo "/home/useraccount/ftpusers"
                  echo "and so forth"
                  echo "Since you are inputting them from a file they will not get their own home directory"
                  echo "This is fine since each user will be chrooted to their own directory"
                  echo ""

          echo "Please use an absolute path"
                  read -p "Where shall the FTP user directories be placed? " sysdir

                  
                  for NAME in $NAMES; do
                        useradd -d $sysdir/$NAME $NAME
                        mkdir -p $sysdir/$NAME

            #pass=echo $[ 1 + $[ RANDOM % 10 ]]
            #echo -e "test$pass\ntest$pass" | passwd $NAME
                        usermod -G $groupname $NAME
          if [ "$restrict" = 'y' ];
            then
                        chown root:root $sysdir/$NAME
          fi
                        chmod 755 $sysdir/$NAME
                        cd $sysdir/$NAME
                        mkdir public_html
                        chown $NAME:$groupname *
            #echo "test$pass"

                  done

      fi
      ;;
      n)
            clear
            read -p "What is the name of the user you wish to add? " NAME
            echo ""
            echo "Now we need to know where our ftp users will have their main directory"
            echo "Some common ones are:"
            echo "/var/www/ftpusers"
            echo "/home/useraccount/ftpusers"
            echo "and so forth"
            echo "The user will be chrooted to that directory"
            echo ""

                  read -p "Where shall the FTP user directories be placed? " sysdir
            
          mkdir -p $sysdir/$NAME
            useradd -d $sysdir/$NAME $NAME
          #pass=echo $[ 1 + $[ RANDOM % 10 ]]
          #echo -e "test$pass\ntest$pass" | passwd $NAME
          usermod -G $groupname $NAME
          if [ "$restrict" = 'y' ];
            then
            chown root:root $sysdir/$NAME
          fi
          chmod 755 $sysdir/$NAME
          cd $sysdir/$NAME
          mkdir public_html
          chown $NAME:$groupname *
            clear
      ;;
esac
            ;;
            n)
            ;;
      esac
      echo "Your sftp server should be set up!"