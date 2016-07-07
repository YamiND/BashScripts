#!/bin/bash

###########################
# Require running as root #
###########################

if [[ $EUID -ne 0 ]]; then
 	echo "You must be a root user or run with sudo" 2>&1
 	exit 1
fi

##########################
# Determine Distribution #
##########################

if [ -f /etc/lsb-release ]; then
    OS=$(cat /etc/lsb-release | grep DISTRIB_ID | cut -d'=' -f2)
elif [ -f /etc/redhat-release ]; then
	OS=$(cat /etc/redhat-release | cut -f1 -d' ')
elif [ -f /etc/debian_version ]; then
	OS=Debian # What the crap Debian
fi

#############################
# Ask for routing interface #
#############################

ls /sys/class/net

read -p "What is the network interface you wish to server traffic on? " routingInterface

####################
# DNS Server Input #
####################

read -p "Enter DNS Server 1 (Google is 8.8.8.8): " dnsServerPrim
read -p "Enter DNS Server 2 (Google 2 is 8.8.4.4): " dnsServerSecon

###########################
# Get Certificate Details #
###########################

read -p "Enter the Province/State: " keyProvince
read -p "Enter the City: " keyCity
read -p "Enter the Organization Name: " keyOrg
read -p "Enter the Admin Email: " keyEmail
read -p "Enter the OU: " keyOu
read -p "Enter the Common Name: " keyCn

#####################################
# OpenVPN Variables and directories #
#####################################

ovpnConfigDir="/etc/openvpn"
easyRSADir="$ovpnConfigDir/easy-rsa"
ovpnServerConfig="$ovpnConfigDir/server.conf"
ovpnKeyDir="$easyRSADir/keys"
sampleRSADir="/usr/share/easy-rsa/2.0"

rsaVarConfig="$easyRSADir/vars"
serverName="server"
sysctlConfig="/etc/sysctl.conf"

#########################################
# Install packages required for OpenVPN #
# I don't understand multi-yum reqs     #
#########################################

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	yum -y install epel-release 
	yum -y install openvpn 
	yum -y install easy-rsa 
	yum -y install iptables-services 
elif [ "$OS" == "Ubuntu" ] || [ "$OS" == "Debian" ]; then	
	apt-get install -y openvpn easy-rsa 
fi

###############################################
# Copy sample server config to $ovpnConfigDir #
# Create easy-rsa directory on Ubuntu/Debian  #
###############################################

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	ovpnSampleConfig="/usr/share/doc/$(ls /usr/share/doc/ | grep "openvpn")/sample/sample-config-files/server.conf"
elif [ "$OS" == "Ubuntu" ] || [ "$OS" == "Debian" ]; then
	gunzip /usr/share/doc/$(ls /usr/share/doc/ | grep "openvpn")/examples/sample-config-files/server.conf.gz
	ovpnSampleConfig="/usr/share/doc/$(ls /usr/share/doc/ | grep "openvpn")/examples/sample-config-files/server.conf"
fi

cp $ovpnSampleConfig $ovpnConfigDir

################################################
# Modify $ovpnServerConf file with our changes #
################################################

sed -i "s/;push \"redirect-gateway def1 bypass-dhcp\"/push \"redirect-gateway def1 bypass-dhcp\"/g" $ovpnServerConfig
sed -i "s/;push \"dhcp-option DNS 208.67.222.222\"/push \"dhcp-option DNS $dnsServerPrim\"/g" $ovpnServerConfig
sed -i "s/;push \"dhcp-option DNS 208.67.220.220\"/push \"dhcp-option DNS $dnsServerSecon\"/g" $ovpnServerConfig
sed -i "s/;user nobody/user nobody/g" $ovpnServerConfig
sed -i "s/;group nobody/group nobody/g" $ovpnServerConfig
sed -i "s/;duplicate-cn/duplicate-cn/g" $ovpnServerConfig

#######################################
# Copy easyRSA samples to $easyRSADir #
#######################################

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	mkdir $easyRSADir
	cp -rf $sampleRSADir/* $easyRSADir 
elif [ "$OS" == "Ubuntu" ] || [ "$OS" == "Debian" ]; then
	make-cadir $easyRSADir
fi

##################################
# Create directory to store keys #
##################################

mkdir -p $ovpnKeyDir 

##############################################
# Modify Certificate values in $rsaVarConfig #
##############################################

sed -i "s/export KEY_PROVINCE=\"CA\"/export KEY_PROVINCE=\"$keyProvince\"/g" $rsaVarConfig
sed -i "s/export KEY_CITY=\"SanFrancisco\"/export KEY_CITY=\"$keyCity\"/g" $rsaVarConfig
sed -i "s/export KEY_ORG=\"Fort-Funston\"/export KEY_ORG=\"$keyOrg\"/g" $rsaVarConfig
sed -i "s/export KEY_EMAIL=\"me@myhost.mydomain\"/export KEY_EMAIL=\"$keyEmail\"/g" $rsaVarConfig
sed -i "s/export KEY_OU=\"MyOrganizationalUnit\"/export KEY_OU=\"$keyOu\"/g" $rsaVarConfig
sed -i "s/# export KEY_CN=\"CommonName\"/export KEY_CN=\"$keyCn\"/g" $rsaVarConfig

############################################
# Fix OpenSSL not being detected by rename #
############################################

cp $easyRSADir/openssl-1.0.0.cnf $easyRSADir/openssl.cnf

##################################################
# Load in new certificate variables and clean up #
##################################################

cd $easyRSADir
source ./vars
./clean-all

########################################
# Fix pkitool on Ubuntu* distributions #
########################################

if [ "$OS" == "Ubuntu" ]; then
	sed -i "s/KEY_ALTNAMES=\"$KEY_CN\"/KEY_ALTNAMES=\"DNS:${KEY_CN}\"/g" $easyRSADir/pkitool
fi 

############################################
# Generate the Certificate Authority Certs #
############################################

$easyRSADir/pkitool --initca

############################
# Generate server cert/key #
############################

$easyRSADir/pkitool --server  $serverName

##########################################
# Build Diffie-Hellman key exchange file #
##########################################

$easyRSADir/build-dh

############################################
# Copy keys and *.crts into $ovpnConfigDir #
############################################

cd $ovpnKeyDir
cp dh2048.pem ca.crt server.crt server.key $ovpnConfigDir/

################################
# Install and enable iptables  # 
################################

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	systemctl enable iptables
	systemctl start iptables
fi

iptables --flush

##########################################
# Setup iptables routing and save config #
##########################################

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $routingInterface -j MASQUERADE

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	iptables-save > /etc/sysconfig/iptables
elif [ "$OS" == "Ubuntu" ] || [ "$OS" == "Debian" ]; then
	iptables-save > ~/iptables
fi

##########################
# Enable IPv4 Forwarding #
##########################

if grep -Fxq "net.ipv4.ip_forward = 1" $sysctlConfig
then
	echo "IPv4 forwarding already enabled"
else
	sed -i '1i net.ipv4.ip_forward = 1' $sysctlConfig
fi

#################
# Reload sysctl #
#################

sysctl -p 

###################################################
# Restart networking for iptables to take effect  #
###################################################

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	systemctl restart network.service
elif [ "$OS" == "Ubuntu" ] || [ "$OS" == "Debian" ]; then
	systemctl restart networking
fi

###################################
# Enable && Start OpenVPN Service #
###################################

if [ "$OS" == "CentOS" ] || [ "$OS" == "Red Hat" ]; then
	systemctl -f enable openvpn@server.service
	systemctl start openvpn@server.service
elif [ "$OS" == "Ubuntu" ] || [ "$OS" == "Debian" ]; then
	systemctl -f enable OpenVPN
	systemctl start openvpn 
fi
