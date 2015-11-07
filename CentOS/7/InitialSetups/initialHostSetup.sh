#!/bin/bash

#################################################################
# Please read:							# 
# This script assumes the networking is set up.			# 
# If it is not, please see the documentation on at:		#
# https://github.com/YamiND/BashScripts/CentOS/7/Documentation  #
#################################################################

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

#########################
# Update/Upgrade System #
#########################

yum -y update
yum -y upgrade

#######################
# Enable Repositories # 
#######################

sudo -y yum install epel-release

###########################
# Install Basic Utilities #
###########################

yum -y install htop policycoreutils-python git


########################################
# Install OpenSSH Server and Configure #
########################################

yum -y install openssh-server
sed -i '/PermitRootLogin yes/c\PermitRootLogin no' /etc/ssh/sshd_config


##################
# Installing KVM #
##################

yum -y install kvm qemu-kvm python-virtinst libvirt libvirt-python libguestfs-tools
