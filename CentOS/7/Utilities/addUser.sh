#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi

tempDir=$(mktemp -d)
newUsers=$tempDir/newUsers.txt

genpasswd() 
{
    < /dev/urandom LC_CTYPE=C tr -dc _A-Z-a-z-0-9 | head -c8
}

addUser()
{
    for user in $username; 
    do 
        randomPass=$(genpasswd 8) 
	useradd -m $user
	echo "$user:$randomPass" | chpasswd
	echo "$user:$randomPass" >> $newUsers
    done
}

read -p "Are you adding users from a list? [y/n] " userList 

case $userList in

    y)
	read -p "Where is the text file containing the list of users? " userListLocation

	username = $(cat $userListLocation)
	addUser
	read -p "Would you like to store the Usernames and files in a file? [y/n] " storeUsers

	if [ $storeUsers = "y" ]; then
	    cat $newUsers > ~/newUsers.txt
	    echo "The file is located at ~/newUsers.txt"
	else
	    cat $newUsers
	fi
    ;;

    n)
	read -p "What would you like to call the username? " username
	addUser
	cat $newUsers
    ;;
esac

rm -rf $tempDir
