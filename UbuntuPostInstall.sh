echo "Yami's typical post-installation stuff"

gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

sudo apt-get -y install vlc gimp libdvdread4 eclipse xchat socat netbeans android-tools-adb android-tools-fastboot ssh synaptic
#sudo /usr/share/doc/libdvdread4/install-css.sh testing not having to use this part of the script

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
sudo apt-get -y install ubuntu-restricted-extras


sudo add-apt-repository -y ppa:webupd8team/java
sudo apt-get update
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y install oracle-java7-installer

sudo add-apt-repository -y ppa:linrunner/tlp #not required for desktop
sudo apt-get update #again not required for desktop
sudo apt-get -y install tlp tlp-rdw #desktop computers don't need this
sudo tlp start #again desktop computers don't need this

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*; sudo apt-get -f -y install


sudo apt-get update 
sudo apt-get -y dist-upgrade 
