#!/bin/bash

#################################################################
# Please read:							# 
# This script assumes the networking is set up.			# 
# If it is not, please see the documentation on at:		#
# https://github.com/YamiND/BashScripts/CentOS/7/Documentation  #
#################################################################

#########################
# Update/Upgrade System #
#########################

sudo yum -y update

#######################
# Enable Repositories # 
#######################

sudo yum -y install epel-release

#################################
# Install packages for bridging #
#################################

sudo yum -y install bridge-utils

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

##################
# Installing KVM #
##################

sudo yum -y install kvm qemu-kvm python-virtinst libvirt libvirt-python libguestfs-tools virt-install

##########################
# Enabling KVM in Kernel #
##########################

sudo modprobe kvm
sudo modprobe kvm_intel

#####################
# Enabling libvirtd #
#####################

sudo chkconfig libvirtd on
sudo systemctl restart libvirtd

##########################
# Enable IPv4 Forwarding #
##########################

sudo echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

#######################
# Enable KVM VNC Port #
#######################

sudo firewall-cmd --zone=public --add-port=5900/tcp --permanent
sudo firewall-cmd --reload

########################
# Disable ICMP Replies #
########################

sudo echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf

######################
# Reload sysctl conf #
######################

sudo sysctl -p

#########################################
# Restart the system for kernel changes #
#########################################

sudo reboot
