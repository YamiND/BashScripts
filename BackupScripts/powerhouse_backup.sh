#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

read -p "Home directory to be backed up: " home_dir
read -p "Username of the remote machine: " username
read -p "IP Address of remote machine: " IP
read -p "Full path of directory to transfer file to: " filelocation

scpdetails=$username@$IP:$filelocation

timestamp=$(date +"%m%d%Y")

cd /var/lib/lxc
mkdir ~/temp
backup_dir=~/temp/
for container in *;
do
	compressed=$container".tar.gz"
	lxc-shutdown -n $container
	sleep 30

	cp -R $container $backup_dir$container
	tar -czf $backup_dir$compressed $backup_dir$container 
	
	lxc-start -n $container -d
	rm -rf $backup_dir$container
done

cd $backup_dir

tar -czf $home_dir".tar.gz" $home_dir

cd ..
backup_file=$backup_dir$(date +"%m%d%Y")".tar.gz"
tar -czf $backup_file $backup_dir

scp $backup_file $scpdetails

echo "The system should be backed up, please check the remote server"
echo "and verify everything works"

