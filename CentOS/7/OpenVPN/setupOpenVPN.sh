#!/bin/bash

# Rip this out with client generation #
serverIP=$( ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
ovpnPort="1194"
###############################

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

#########################################
# Install packages required for OpenVPN #
#########################################

yum install epel-release openvpn easy-rsa -y

###############################################
# Copy sample server config to $ovpnConfigDir #
###############################################
cp /usr/share/doc/openvpn-*/sample/sample-config-files/server.conf $ovpnConfigDir

################################################
# Modify $ovpnServerConf file with our changes #
################################################

sed -i 's/;push "redirect-gateway def1 bypass-dhcp"/push "redirect-gateway def1 bypass-dhcp"/g' $ovpnServerConf 

sed -i 's/;push "dhcp-option DNS 208.67.222.222"/push "dhcp-option DNS 8.8.8.8"/g' $ovpnServerConf 
sed -i 's/;push "dhcp-option DNS 208.67.220.220"/push "dhcp-option DNS 8.8.8.4"/g' $ovpnServerConf 

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

sed -i 's/export KEY_PROVINCE="CA"/export KEY_PROVINCE="MI"/g' $rsaVarConfig
sed -i 's/export KEY_CITY="SanFrancisco"/export KEY_CITY="Sault Ste Marie"/g' $rsaVarConfig
sed -i 's/export KEY_ORG="Fort-Funston"/export KEY_ORG="LTI"/g' $rsaVarConfig
sed -i 's/export KEY_EMAIL="me@myhost.mydomain"/export KEY_EMAIL="tpostma@lakertech.com"/g' $rsaVarConfig
sed -i 's/export KEY_OU="MyOrganizationalUnit"/export KEY_OU="IT"/g' $rsaVarConfig

sed -i 's/# export KEY_CN="CommonName"/export KEY_CN="openvpn.lakertech.com"/g' $rsaVarConfig

############################################
# Fix OpenSSL not being detected by rename #
############################################
cp $easyRSADir/openssl-1.0.0.cnf $easyRSADir/openssl.cnf

##################################################
# Load in new certificate variables and clean up #
##################################################

source $rsaVarConfig
$easyRSADir/clean-all

############################################
# Generate the Certificate Authority Certs #
############################################

$rsaVarConfig/pkitool --initca

################################
# Fuck it, we're using pkitool #
################################

$rsaVarConfig/pkitool --server  $serverName

##########################################
# Build Diffie-Hellman key exchange file #
##########################################

$rsaVarConfig/build-dh

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
	# This is where I break shit
	sed -i '1i net.ipv4.ip_forward = 1' $sysctlConfig
fi

################################################
# This is where I fucking break the networking #
################################################

systemctl restart network.service

###################################
# Enable && Start OpenVPN Service #
###################################

systemctl -f enable openvpn@server.service
systemctl start openvpn@server.service


##########################################################
# At this point the OpenVPN Server should be running     #
# I am going to include client generation in this script #
# for now and rip it out and make it separate later      #
##########################################################

#################################
# Generate sample client config #
#################################

clientCert="$ovpnKeyDir/client.crt"
clientKey="$ovpnKeyDir/client.key"
caCert="$ovpnKeyDir/ca.crt"

$easyRSADir/pkitool client

cat > ~/client.ovpn << EOF  
client
dev tun
proto udp
remote $serverIP $ovpnPort
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3

<ca>
$(cat $caCert)
</ca>

<cert>
$(cat $clientCert)
</cert>

<key>
$(cat $clientKey)
</key>
EOF


