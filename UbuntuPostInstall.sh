echo "Yami's typical post-installation stuff"

gsettings set com.canonical.Unity.Lenses disabled-scopes "['more_suggestions-amazon.scope', 'more_suggestions-u1ms.scope', 'more_suggestions-populartracks.scope', 'music-musicstore.scope', 'more_suggestions-ebay.scope', 'more_suggestions-ubuntushop.scope', 'more_suggestions-skimlinks.scope']"

sudo apt-get install vlc gimp libdvdread4 ubuntu-restricted-extras eclipse xchat socat netbeans
sudo /usr/share/doc/libdvdread4/install-css.sh

sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java7-installer
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install tlp tlp-rdw
sudo tlp start

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*; sudo apt-get -f install

sudo apt-get install synaptic
sudo apt-get install ssh
sudo apt-get install android-tools-fastboot
sudo apt-get install android-tools-adb


sudo apt-get update
sudo apt-get dist-upgrade
