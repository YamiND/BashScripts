#!/bin/bash
echo "This script will compile the Nexuiz DPRM engine from source and install it for you";
sudo apt-get install git;
git clone https://github.com/nexAkari/DarkPlacesRM.git ~/DarkplacesRM/;
cd DarkPlacesRM;
sudo apt-get install nexuiz-data libsdl-dev libjpeg62-dev nexuiz-textures nexuiz-music build-essential;
make sdl-nexuiz;
sudo make install;
cp ~/.nexuiz/data/config.cfg ~/.nexuiz/data/config.cfg.backup;

echo "Nexuiz with the DPRM engine is ready to use";

