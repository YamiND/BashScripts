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

echo "This script is meant to easily add FTP user accounts"
echo "and point them to a directory"
echo "First we need to figure out how we're adding an user(s)"
echo ""
echo ""

echo "1) Add a set of users from a file"
echo "2) Add a single user via the terminal"

read -p "What method would you like? [1-2] " choice

echo "Second, we need to assign these users to a group"
read -p "What should the group be called? " groupname
case $choice in
	1)
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
      		      
            i=$[ $i + 2 ]
      		echo "Now we need to know where our ftp users will have their main directory"
      		echo "Some common ones are:"
      		echo "/var/www/ftpusers"
      		echo "/home/useraccount/ftpusers"
      		echo "and so forth"
      		echo "Since you are inputting them from a file they will not get their own home directory"
      		echo "This is fine since each user will be chrooted to their own directory"
      		echo ""

      		read -p "Where shall the FTP user directories be placed? " sysdir

      		echo "Match Group $groupname" >> /etc/ssh/sshd_config
      		echo "ChrootDirectory $dir/%u" >> /etc/ssh/sshd_config
      		echo "ForceCommand internal-sftp" >> /etc/ssh/sshd_config
      		serivce ssh restart
      		groupadd $groupname
      		for NAME in $NAMES; do
      			useradd -s /usr/sbin/nologin $NAME
				usermod -a -G $groupname $NAME
			done
        
        else
        	clear
	fi
	;;
	2)
	;;
esac
done