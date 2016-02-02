#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi

removeUser()
{
    for user in $username; 
    do 
	if [ $removeHome = "y" ]; then
	    userdel -r $user
	else
	    userdel $user
	fi
    done

    echo "Users removed"
}

read -p "Are you removing users from a list? [y/n] " userList 

case $userList in

    y)
	read -p "Where is the text file containing the list of users? " userListLocation

	username = $(cat $userListLocation)
	read -p "Would you like to remove the users home directory? [y/n] " removeHome 
	removeUser
    ;;

    n)
	read -p "What is the name of the user to remove? " username
	read -p "Would you like to remove the users home directory? [y/n] "     removeHome 	
	removeUser	
    ;;
esac
