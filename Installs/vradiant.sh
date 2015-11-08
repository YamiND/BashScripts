#!/bin/bash 

#################################
# Please Read:  	        #
# This script has been tested   #
# on the following platforms:   #
#			        #
# Ubuntu 14.04 		        #
# Ubuntu 15.10		        #
#			        #
# TODO:				# 
# Install vradiant to the 	#
# system directory as an actual #
# application			#
#################################

sudo apt-get install git subversion g++ libgtkglext1-dev libjpeg8-dev liblzma-dev libxml2-dev libsqlite3-dev zlib1g-dev

git clone git://git.vecxis.org/vradiant.git ~/vradiant/

cd ~/vradiant/

make

echo "The file to launch is called radiant.x86 in ~/vradiant/install/"
