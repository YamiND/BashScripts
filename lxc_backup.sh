#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

read -p "Username of the remote machine: " username
read -p "IP Address of remote machine: " IP
read -p "Full path of directory to transfer file to: " filelocation

scpdetails=$username@$IP:$filelocation

cd /var/lib/lxc

for container in *;
do
	timestamp=$(date +"%m%d%Y")
	containerbackup=$container$timestamp
	compressed=$containerbackup".tar.gz"
	lxc-shutdown -n $container
	sleep 30

	cp -R $container ~/$containerbackup
	cd ~/
	tar -czf $compressed $containerbackup 
	scp $compressed $scpdetails 
	rm -rf $containerbackup
	rm $compressed
	lxc-start -n $container -d
done

echo "Containers have been backed up"
echo "Double check your IP settings and make sure it came back up properly"

