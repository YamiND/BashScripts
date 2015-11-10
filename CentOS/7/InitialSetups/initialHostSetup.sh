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
sudo yum -y upgrade

#######################
# Enable Repositories # 
#######################

sudo -y yum install epel-release

###########################
# Install Basic Utilities #
###########################

sudo yum -y install htop policycoreutils-python git

########################################
# Install OpenSSH Server and Configure #
########################################

sudo yum -y install openssh-server
sudo cp /etc/ssh/sshd_config ~/sshd_config.backup
sudo sed -i '/PermitRootLogin yes/c\PermitRootLogin no' /etc/ssh/sshd_config

# If SSHD does not autoenable: sudo systemctl enable sshd.service

##################
# Installing KVM #
##################

sudo yum -y install kvm qemu-kvm python-virtinst libvirt libvirt-python libguestfs-tools

#####################
# Enabling libvirtd #
#####################

sudo chkconfig libvirtd on

########################
# Disable ICMP Replies #
#######################

echo "net.ipv4.icmp_echo_ignore_all = 1" >> /etc/sysctl.conf
sysctl -p
