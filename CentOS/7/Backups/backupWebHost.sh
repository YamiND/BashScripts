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
mkdir ~/tempDir/mysql
mkdir ~/tempDir/httpd

tempDir=~/tempDir
wwwDirBackup=$tempDir/www
mysqlBackup=$tempDir/sqlBackup.sql
httpdConfigBackup=$tempDir/httpd.conf
timeStamp=$(date -u)

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

tar -zcvf 

