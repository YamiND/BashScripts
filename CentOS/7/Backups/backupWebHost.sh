#!/bin/bash

####################################################
# Please read:					   #
# This script is designed to do a wordpress backup #
# of all VirtualClients as well as back up their   #
# directories in /var/www/html			   #
# This will also backup the database		   #
####################################################

mkdir ~/tempDir
mkdir ~/tempDir/www

tempDir=~/tempDir
wwwDirBackup=$tempDir/www
mysqlBackup=$tempDir/sqlBackup.sql
httpdConfigBackup=$tempDir/httpd.conf
timeStamp=$(date +"%Y-%m-%d")
backupArchive=~/backup$timeStamp.tar.gz

read -p "Do you want to send the backup file via SSH? [y/n] " sshTransfer
read -p "What is the password to the root MySQL/MariaDB account? " dbPass

#######################################
# Backup directories in document root #
#######################################

cp -R /var/www/html/* $wwwDirBackup

########################################
# Backup httpd.conf which contains the #
# VirtualHosts data and other configs  #
########################################

cp /etc/httpd/conf/httpd.conf $httpdConfigBackup

##################################
# Backup MariaDB/MySQL to a .sql #
##################################

mysqldump -u root -p$dbPass --all-databases > $mysqlBackup

####################################
# Throw backup into single archive #
####################################

tar -zcvf $backupArchive -C $tempDir .

#######################################
# Back up the files over SSH if opted #
#######################################

if [ "$sshTransfer" = "y" ]
then
	read -p "IP for SSH? " sshIP
	read -p "Username for SSH? " sshUser
	read -p "Password for SSH? " sshPass
	read -p "Directory to copy to? " sshDir
	read -p "Are you connecting over port 22? [y/n]" sshPort
	
	sshAuth="$sshUser@$sshIP:$sshDir"
	
	case $sshPort in

		y)	
		scp -r $backupArchive $sshAuth
		;;
		n)
		read -p "What is the port number you wish to connect on? " sshNum
		scp -P $sshNum $sshAuth
		;;
	esac
	
	echo "Backup Complete, the archive file is on $sshIP"
fi

##############################
# Remove temporary Directory #
##############################

rm -rf $tempDir

###################
# Echo completion #
###################

echo "Backup complete, the archive is called $backupArchive"
