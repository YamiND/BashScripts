#!/bin/bash 

#################################
# Please Read:  	        #
# This script has been tested   #
# on the following platforms:   #
#			        #
# Ubuntu 14.04 		        #
# Ubuntu 15.10		        #
# Linux Mint 17			#
#			        #
#################################

getDistro=$(cat /etc/*-release | grep "DISTRIB_ID" | cut -d '=' -f2)

if [ "$getDistro" = "Ubuntu" ]
then 
	menuLocation=~/.local/share/applications/vradiant.desktop
else
	menuLocation=/usr/share/applications/vradiant.desktop
fi

sudo apt-get install git subversion g++ libgtkglext1-dev libjpeg8-dev liblzma-dev libxml2-dev libsqlite3-dev zlib1g-dev

git clone git://git.vecxis.org/vradiant.git ~/vradiant/

cd ~/vradiant/

make

sudo cp -R install /usr/share/vradiant
sudo ln -s /usr/share/vradiant/radiant.x86 /usr/bin/vradiant
sudo cp ~/Desktop/vradiant.png /usr/share/icons/gnome/512x512/apps/

sudo echo "
[Desktop Entry]
Encoding=UTF-8
Exec=vradiant
Icon=/usr/share/icons/gnome/512x512/apps/vradiant.png
Type=Application
Terminal=false
Comment=Map Editor for Vecxis/Nexuiz/Xonotic
Name=vRadiant
GenericName=vradiant
StartupNotify=false
Categories=Game;
" >> $menuLocation

if [ "$getDistro" = "Ubuntu" ]
then
	echo "vRadiant can be accessed from the terminal by typing in
vradiant, and if you reboot you should be able to see the icon in Unity"
else
	echo "vRadiant can be accessed from the terminal by typing in "vradiant", or through your GUI menu"
fi

