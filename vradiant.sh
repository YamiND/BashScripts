#script to make vradiant work might edit it in the future to actuall install on a Ubuntu system

sudo apt-get install git subversion g++ libgtkglext1-dev libjpeg8-dev libxml2-dev zlib1g-dev

cd ~

git clone git://git.vecxis.org/vradiant.git

cd vradiant

make

cd install

./radiant.x86
