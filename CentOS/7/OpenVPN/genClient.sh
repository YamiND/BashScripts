#!/bin/bash

###############
# Run as Root #
############### 

if [[ $EUID -ne 0 ]]; then
	echo "You must be a root user or run with sudo" 2>&1
	exit 1
fi

###################
# OpenVPN Configs #
###################

ovpnConfigDir="/etc/openvpn"
ovpnServerConf="$ovpnConfigDir/server.conf"
easyRSADir="$ovpnConfigDir/easy-rsa"
rsaVarConfig="$easyRSADir/vars"
ovpnKeyDir="$easyRSADir/keys"
caCert="$ovpnKeyDir/ca.crt"

##############################
# Get client info from field #
##############################

if [ -z "$1" ]; then 
	read -p "Enter new client's name: " client
else
	client=$1
fi

################################
#  Make sure field isn't blank #
################################

if [ -z "$client" ]; then 
	echo "You must provide a client name."
	exit 2
fi

###################################
# Make sure client doesn't exist  #
###################################

if [ -f $ovpnKeyDir/$client.crt ]
then 
	echo "Client $client already exists!"
	exit
fi

####################
# Client Variables #
####################

clientCert="$ovpnKeyDir/$client.crt"
clientKey="$ovpnKeyDir/$client.key"
clientOut="~/$client.ovpn"

####################
# Replace Name Var #
####################

sed -i "s/.*KEY_NAME.*/KEY_NAME=\"$client\"/" $rsaVarConfig

cd $easyRSADir
source ./vars

###########################
# Generate Certs and Keys #
###########################

"$easyRSADir/pkitool" --batch $client

################
# Create .OVPN #
################

###################
# .OVPN Variables #
###################
ovpnPort=$(cat $ovpnServerConf | grep "^[^#;]" | grep "port"  | cut -d ' ' -f2)
serverIP=$(ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')
ovpnDev=$(cat $ovpnServerConf | grep "^[^#;]" | grep "dev" | cut -d ' ' -f2)
ovpnProto=$(cat $ovpnServerConf | grep "^[^#;]" | grep "proto" | cut -d ' ' -f2)

if [ -z $(cat $ovpnServerConf | grep "^[^#;]" | grep "comp-lzo") ]; then
	ovpnComp="comp-lzo"
else
	ovpnComp=""
fi

cat > $clientOut << EOF  
client
dev $ovpnDev
proto $ovpnProto
remote $serverIP $ovpnPort
resolv-retry infinite
nobind
persist-key
persist-tun
$ovpnComp
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

echo "Client $client generated. File located at $clientOut"
