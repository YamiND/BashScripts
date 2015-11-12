#!/bin/bash

#########################################
# Please Read:                          #
#             				#
# This script assumes the files are in  #
# the root home directory               #
# 					#
# This script also assumes networking   #
# has been configured correctly         # 
# 					#
# This script also assumes the site     #
# is for HTTPS with the certs           #
# commercial.cert and commercial.key    #
#########################################

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

##########################
# WEB SERVER SETUP BELOW #
##########################

###################################
# Install the following packages: #
# Apache                          #
# php                             #
# mod_ssl                         #
# SElinux policy utils            #
# git                             #
###################################

sudo yum -y install httpd php mod_ssl policycoreutils-python git

########################
# Clone the repository #
########################

git clone https://github.com/YamiND/LTI_Centric_v2.git

#########################
# Move the cloned files #
#########################

sudo mv ./LTI_Centric_v2/* /var/www/html/

####################
# Remove empty dir #
####################

rm -rf ./LTI_Centric_v2

#########################################
# Change Ownerships and set Permissions #
#########################################

sudo chown -R apache:apache /var/www/html
sudo chmod -R 555 /var/www/html

#############################################################
# Add an exception to SELinux to allow php files to be run  #
# Any files within that directory (should be document root) #
#############################################################

sudo semanage fcontext -a -t httpd_sys_script_exec_t '/var/www/html(/.*)?'
sudo restorecon -R -v /var/www/html/

#############################
# Remove the welcome screen #
#############################

sudo rm -f /etc/httpd/conf.d/welcome.conf

#####################
# Copy config files #
#####################

sudo cp ~/httpd.conf /etc/httpd/conf/
sudo cp ~/ssl.conf /etc/httpd/conf.d/

##########################
# Copy Certificate files #
##########################

sudo cp ~/commercial.crt /etc/pki/tls/certs/commercial.crt
sudo cp ~/commercial.key /etc/pki/tls/private/commercial.crt

#######################
# SELinux allow certs #
#######################

sudo restorecon -RvF /etc/pki

############################################
# Add exception to the firewall and reload #
# This should open the HTTPS port          #
############################################

sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --reload

##############################################
# Start the httpd service and enable at boot #
##############################################

systemctl start httpd 
systemctl enable httpd 
