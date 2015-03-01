#!/bin/bash

clear

echo "This script allows you to access other scripts of mine in an easy manner"
echo "This script assumes the other scripts are in the same directory as this script"
echo ""
echo ""
echo ""

i=1

while [ $i -lt 2 ]; do

echo "What would you like to do today?"

echo "1) Create a Virtual Machine"
echo "2) Start a Virtual Machine"
echo "3) Start a VNC Service (UNIMPLEMENTED)"
echo "4) Restart Apache (UNIMPLEMENTED)"
echo "5) Create a new Virtual Directory with Apache (UNIMPLEMENTED)"
echo "6) Set up an FTP server (UNIMPLEMENTED)"
echo "7) Add an FTP user (UNIMPLEMENTED)"
echo "8) Exit"
echo ""
echo ""

read -p "What would you like to do? [1-7] " choice
case $choice in
	1)
	sh ./createvm.sh
	;;
	2)
	sh ./startvm.sh
	;;
	3)
	;;
	4)
	;;
	5)
	;;
	6)
	;;
	7)
	;;
	8)
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
         fi
clear
done
