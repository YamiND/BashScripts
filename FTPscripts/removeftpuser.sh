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

echo "This script is designed to remove an FTP user that was added"
echo "with my other script. This by no means is meant to remove users created with a different FTP setup"
echo "You may also remove a batch list of FTP users"
echo "If you decide to do so, have a list of their user names in a file vertically seperated"
echo "The FTP user directories will also be deleted, so please back up anything you value."
echo ""
echo ""
echo "1) Remove bulk users (Via Text File)"
echo "2) Remove a single user"
echo ""
read -p "What would you like to do? " choice
case $choice in
	1)
	clear
	read -p "Where is the directory that the text file is located in? " dir
	echo ""
	echo "What is the file called?"
	read -p "Please enter the full text file name: "  file
	NAMES="$(< $dir/$file)"

	echo "The file name and location you gave me was $dir/$file"
	read -p "Is this correct? [y/n] " loop
	if [ "$loop" = 'y' ]
        then
       	clear  
        	#echo "Please use an absolute path when selecting the delete point"
    		#read -p "Where are the FTP directories that will be deleted? " sysdir
      		for NAME in $NAMES;
      			deluser --remove-home $NAME
			done
	fi
	;;
	2)
	clear
	read -p "What is the name of the FTP user you with to remove?" name
		deluser --remove-home $NAME
	;;
esac

echo "Your FTP user(s) should now be removed and their directories deleted"