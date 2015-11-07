#!/bin/bash

#########################################
# Please Read:                          #
# This script assumes the files are in  #
# the root home directory               #
#########################################


###############################
# Require this be run as root #
###############################

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi


###################################
# Install the following packages: #
# Apache                          #
# php                             #
# mod_ssl                         #
# SElinux policy utils            #
# git                             #
###################################

yum -y install httpd php mod_ssl policycoreutils-python git


########################
# Clone the repository #
########################

git clone https://github.com/YamiND/LTI_Centric_v2.git


#########################
# Move the cloned files #
#########################

mv ./LTI_Centric_v2/* /var/www/html/


#############################################################
# Add an exception to SELinux to allow php files to be run  #
# Any files within that directory (should be document root) #
#############################################################

semanage fcontext -a -t httpd_sys_script_exec_t '/var/www/html(/.*)?'
restorecon -R -v /var/www/html/


#############################
# Remove the welcome screen #
#############################

rm -f /etc/httpd/conf.d/welcome.conf


#####################
# Copy config files #
#####################

cp ~/httpd.conf /etc/httpd/conf/
cp ~/ssl.conf /etc/httpd/conf.d/


##########################
# Copy Certificate files #
##########################

cp ~/commercial.crt /etc/pki/tls/certs/commercial.crt
cp ~/commercial.key /etc/pki/tls/private/commercial.crt


############################################
# Add exception to the firewall and reload #
############################################

firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload


##############################################
# Start the httpd service and enable at boot #
##############################################

systemctl start httpd 
systemctl enable httpd 


