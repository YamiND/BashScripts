#!/bin/bash

# TODO Add SSL Layer to further obfuscate from GFW

ovpnConfigDir="/etc/openvpn"
easyRSADir="$ovpnConfigDir/easy-rsa"
ovpnServerConf="$ovpnConfigDir/server.conf"
ovpnKeyDir="$easyRSADir/keys"
sampleRSADir="/usr/share/easy-rsa/2.0"
rsaVarConfig="$easyRSADir/vars"
serverName="server"
routingInterface="eth0"
sysctlConfig="/etc/sysctl.conf"

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user or run with sudo" 2>&1
  exit 1
fi


####################
# DNS Server Input #
####################

read -p "Enter DNS Server 1 (Google is 8.8.8.8): " dnsServer1
read -p "Enter DNS Server 2 (Google 2 is 8.8.8.4): " dnsServer2

####################
# Get Cert Details #
####################

read -p "Enter the Province/State: " keyProvince
read -p "Enter the City: " keyCity
read -p "Enter the Organization Name: " keyOrg
read -p "Enter the Admin Email: " keyEmail
read -p "Enter the OU: " keyOu
read -p "Enter the Common Name: " keyCn

#########################################
# Install packages required for OpenVPN #
#########################################

yum install -y epel-release openvpn easy-rsa 

###############################################
# Copy sample server config to $ovpnConfigDir #
###############################################

cp /usr/share/doc/openvpn-*/sample/sample-config-files/server.conf $ovpnConfigDir

################################################
# Modify $ovpnServerConf file with our changes #
################################################

sed -i 's/;push "redirect-gateway def1 bypass-dhcp"/push "redirect-gateway def1 bypass-dhcp"/g' $ovpnServerConf 
sed -i "s/;push \"dhcp-option DNS 208.67.222.222\"/push \"dhcp-option DNS $dnsServer1\"/g" $ovpnServerConf 
sed -i "s/;push \"dhcp-option DNS 208.67.220.220\"/push \"dhcp-option DNS $dnsServer2\"/g" $ovpnServerConf 
sed -i 's/;user nobody/user nobody/g' $ovpnServerConf
sed -i 's/;group nobody/group nobody/g' $ovpnServerConf
sed -i 's/;duplicate-cn/duplicate-cn/g' $ovpnServerConf

##################################
# Create directory to store keys #
##################################

mkdir -p $ovpnKeyDir 

#######################################
# Copy easyRSA samples to $easyRSADir #
#######################################

cp -rf $sampleRSADir/* $easyRSADir 

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

############################################
# Generate the Certificate Authority Certs #
############################################

$easyRSADir/pkitool --initca

################################
# Fuck it, we're using pkitool #
################################

$easyRSADir/pkitool --server  $serverName

##########################################
# Build Diffie-Hellman key exchange file #
##########################################

$easyRSADir/build-dh

############################################
# Copy keys and *.crts into $ovpnConfigDir #
############################################

cd $ovpnKeyDir
cp dh2048.pem ca.crt server.crt server.key $ovpnConfigDir

##########################################
# Install iptables and disable firewallD # 
##########################################

yum install iptables-services -y

systemctl mask firewalld
systemctl enable iptables
systemctl stop firewalld
systemctl start iptables

iptables --flush

##########################################
# Setup iptables routing and save config #
##########################################

iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $routingInterface -j MASQUERADE

iptables-save > /etc/sysconfig/iptables

##########################
# Enable IPv4 Forwarding #
##########################

if grep -Fxq "net.ipv4.ip_forward = 1" $sysctlConfig
then
	echo "IPv4 forwarding already enabled"
else
	# This is where I break shit (...and NOT test it)
	sed -i '1i net.ipv4.ip_forward = 1' $sysctlConfig
fi

#########################################################
# This is where the networking breaks and I lose SSH... #
#########################################################

systemctl restart network.service

###################################
# Enable && Start OpenVPN Service #
###################################

systemctl -f enable openvpn@server.service
systemctl start openvpn@server.service

