#!/bin/bash

# This script will install mariadb and open it up for remote connections

sudo yum -y update

sudo yum -y install epel-release
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

#####################
# Open MariaDB Port #
#####################
firewall-cmd --add-port=3306/tcp 
firewall-cmd --permanent --add-port=3306/tcp
