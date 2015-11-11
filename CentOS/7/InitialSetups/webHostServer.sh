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

tempDir=~/temp
mkdir $tempDir/configBackup

########################
# INITIAL SERVER SETUP #
########################

#########################
# Update/Upgrade System #
#########################

sudo yum -y update

#######################
# Enable Repositories # 
#######################

sudo yum -y install epel-release

###########################
# Install Basic Utilities #
###########################

sudo yum -y install htop policycoreutils-python git wget

########################################
# Install OpenSSH Server and Configure #
########################################

sudo yum -y install openssh-server
cp /etc/ssh/sshd_config ~/sshd_config.backup
sudo sed -i '/PermitRootLogin yes/c\PermitRootLogin no' /etc/ssh/sshd_config
sudo sed -i '/#Port 25/c\Port 1069' /etc/ssh/sshd_config 

##########################################
# Configure SELinux and Firewall for SSH #
##########################################

sudo semanage port -a -t ssh_port_t -p tcp 1069

sudo firewall-cmd --permanent --add-port=1069/tcp
sudo firewall-cmd --reload

########################
# Disable ICMP Replies #
########################

sudo echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf

######################
# Reload sysctl conf #
######################

sudo sysctl -p

##################
# WEB HOST SETUP #
##################

###################
# Install MariaDB #
###################

sudo yum -y install mariadb-server

###################
# Restart MariaDB #
###################

sudo systemctl restart mariadb

#####################
# Configure MariaDB #
#####################

sudo mysql_secure_installation

############################
# Start MariaDB on startup #
############################

sudo systemctl enable mariadb

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
# php-gd			  #
# php-mysql connector		  #
###################################

sudo yum -y install httpd php php-gd php-mysql

####################################
# Create copy of important configs #
####################################

cp /etc/php.ini $tempDir/configBackup/php.ini.backup
cp /etc/httpd/conf/httpd.conf $tempDir/configBackup/httpd.conf.backup

################################
# Change PHP's max upload size #
################################

sudo sed -i '/upload_max_filesize/c\upload_max_filesize = 20M' /etc/php.ini
sudo sed -i '/post_max_size/c\post_max_size = 20M' /etc/php.ini

############
# Hide PHP #
############

sudo sed -i '/expose_php/c\expose_php = off' /etc/php.ini

#############################
# Remove the welcome screen #
#############################

sudo rm -f /etc/httpd/conf.d/welcome.conf

####################################
# Copy VirtualHost config files to #
# /etc/httpd/conf/httpd.conf   	   #
####################################

for file in $tempDir/apache/*;
do
	sudo echo "$(cat $file)" >> /etc/httpd/conf/httpd.conf
done

############################################
# Copy client directories to /var/www/html #
############################################

sudo cp -R $tempDir/www/* /var/www/html/

#########################################
# Change Ownerships and set Permissions #
# Wordpress is finicky			#
#########################################

sudo chown -R apache:apache /var/www/html

sudo find /var/www/html/ -type f -exec chmod 664 {} \;
sudo find /var/www/html/ -type d -exec chmod 775 {} \;

#############################################################
# Add an exception to SELinux to allow php files to be run  #
# Any files within that directory (should be document root) #
#############################################################

sudo semanage fcontext -a -t httpd_sys_script_exec_t '/var/www/html(/.*)?'
sudo restorecon -R -v /var/www/html/

############################################
# Add exception to the firewall and reload #
# This should open the HTTPS port          #
############################################

sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --reload

##############################################
# Start the httpd service and enable at boot #
##############################################

sudo systemctl start httpd 
sudo systemctl enable httpd 
