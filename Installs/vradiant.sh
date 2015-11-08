#!/bin/bash 

#script to make vradiant work
#had to do some minor changes to make it actually compile

ubuntuVersion=$(lsb_release -r | cut -f 2)

if [ "$ubuntuVersion" = "15.10" ]
then
	sudo apt-get install git subversion g++ libgtkglext1-dev libjpeg8-dev liblzma-dev libxml2-dev libsqlite3-dev zlib1g-dev
else
	sudo apt-get install git subversion g++ libgtkglext1-dev libjpeg8-dev liblzma-dev libxml2-dev sqlite-dev zlib1g-dev

fi

git clone git://git.vecxis.org/vradiant.git ~/vradiant/

cd ~/vradiant/

make

echo "The file to launch is called radiant.x86 in ~/vradiant/install/"


