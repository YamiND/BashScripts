#!/bin/bash 

#script to make vradiant work
#had to do some minor changes to make it actually compile

sudo apt-get install git subversion g++ libgtkglext1-dev libjpeg8-dev liblzma-dev libxml2-dev sqlite-dev zlib1g-dev;

git clone git://git.vecxis.org/vradiant.git ~/vradiant/;
cd ~/vradiant/;
make;

echo "The file to launch is called radiant.bin in ~/vradiant/install/";


