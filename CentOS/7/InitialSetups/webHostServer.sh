#!/bin/bash

######################################
# Please Read:			     #
# This script assumes your files are #
# as follows: 			     #
# Wordpress files in ~/temp/www/     #
# Apache Configs in ~/temp/apache/   #
# SQL Restore in ~/temp/mysql/	     #
#				     #
# Please seek the documentation for  #
# Examples			     #
######################################


###############################
# Require this be run as root #
###############################

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

tempDir=~/temp
mkdir $tempDir/configBackup

###################
# Install MariaDB #
###################

yum -y install mariadb-server

###################
# Restart MariaDB #
###################

systemctl restart mariadb

#####################
# Configure MariaDB #
#####################

mysql_secure_installation

############################
# Start MariaDB on startup #
############################

systemctl enable mariadb.service

###########################
# Restore tables from SQL #
###########################

mysql -u root -p < $tempDir/mysql/backup.sql

###################################
# Install the following packages: #
# Apache                          #
# php                             #
# SElinux policy utils            #
# git                             #
###################################

yum -y install httpd php policycoreutils-python git

####################################
# Create copy of important configs #
####################################

cp /etc/php.ini $tempDir/configBackup/php.ini.backup
cp /etc/httpd/conf/httpd.conf $tempDir/configBackup/httpd.conf.backup

################################
# Change PHP's max upload size #
################################

sed -i '/upload_max_filesize/c\upload_max_filesize = 20M' /etc/php.ini
sed -i '/post_max_size/c\post_max_size = 20M' /etc/php.ini

############
# Hide PHP #
############

sed -i '/expose_php/c\expose_php = off' /etc/php.ini

#############################
# Remove the welcome screen #
#############################

rm -f /etc/httpd/conf.d/welcome.conf

#################################
# Create the directories for    #
# VirtualHost configuration     #
# files				#
#################################

mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled

##################################
# Add VirtualHost config line to #
# httpd.conf			 #
##################################

echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf

####################################
# Copy VirtualHost config files to #
# /etc/httpd/sites-available and   #
# symlink them to sites-enabled    #
####################################

cp $tempDir/apache/sites-available/ /etc/httpd/sites-available
ln -s /etc/httpd/sites-available/* /etc/httpd/sites-enabled

############################################
# Copy client directories to /var/www/html #
############################################

cp -R $tempDir/www/* /var/www/html/

#########################################
# Change Ownerships and set Permissions #
# Wordpress is finicky			#
#########################################

chown -R apache:apache /var/www/html

find /var/www/html/ -type f -exec chmod 664 {} \;
find /var/www/html/ -type d -exec chmod 775 {} \;

#############################################################
# Add an exception to SELinux to allow php files to be run  #
# Any files within that directory (should be document root) #
#############################################################

semanage fcontext -a -t httpd_sys_script_exec_t '/var/www/html(/.*)?'
restorecon -R -v /var/www/html/

############################################
# Add exception to the firewall and reload #
# This should open the HTTPS port          #
############################################

firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --reload


##############################################
# Start the httpd service and enable at boot #
##############################################

systemctl start httpd 
systemctl enable httpd 
