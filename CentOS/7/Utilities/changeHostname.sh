#!/bin/bash

getIP=$( ip route get 8.8.8.8 | awk 'NR==1 {print $NF}')

read -p "What would you like the hostname to be? " getHostname

sudo hostnamectl set-hostname $getHostName

sudo echo $getIP $getHostName >> /etc/hosts
