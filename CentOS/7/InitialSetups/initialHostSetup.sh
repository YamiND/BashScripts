#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi

#Set user account to create and assign a password

User=""
passwd=""

#Add the user

adduser $User
echo "$User:$passwd" | chpasswd

# Give the user sudo access

gpasswd -a $User wheel

# Update the repositories and system
# This script assumes the networking is set up. This also includes the proper bridging interfaces for LXC

yum -y update

# Enable the extra repository (required for packages like htop)

sudo -y yum install epel-release

# Install some basic utilities

yum -y install htop

# Install libvirt requirements

yum -y install libvirt libvirt-client 

# Install LXC and dependencies

yum -y install lxc lxc-templates lxc-extra wget

# Install OpenSSH Server, and fix the damn defaults

yum -y install openssh-server
sed -i '/PermitRootLogin yes/c\PermitRootLogin no' /etc/ssh/sshd_config


# Last thing, remove obsolete packages (and hope this doesn't break something)

yum -y upgrade


# TODO:
# Start the Script that will iterate through the system binary locations and run an md5sum on all packages
# Change the default port of SSH

