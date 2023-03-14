#!/bin/bash

# create necessary directories
mkdir -p ~/steam
mkdir -p ~/steam/tmp
cd ~/steam/tmp

# download latest deb and unpack
wget https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb
ar x steam.deb
tar xf data.tar.xz

# remove deb archives, not needed anymore
rm ./*.tar.xz ./steam.deb

# move deb contents to steam folder
mv ./usr/* ../
cd ../ && rm -rf ./tmp/

# create run script
echo "#!/bin/bash
export STEAMOS=1
export STEAM_RUNTIME=1
export DBUS_FATAL_WARNINGS=0
~/steam/bin/steam -noreactlogin steam://open/minigameslist $@" > steam

# make script executable and move
chmod +x steam
sudo mv steam /usr/local/bin/

# detect if we're running on 64 bit Debian 
MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'aarch64' ] && [ -f '/etc/debian_version' ]; then
 echo "Detected 64 bit ARM Debian. Installing 32 bit libraries"
 sudo dpkg --add-architecture armhf # enable installation of armhf libraries
 sudo apt update # update package lists with the newly added arch
 # install the libraries that Steam requires
 sudo apt install libc6:armhf libncurses5:armhf libsdl2-2.0-0:armhf libsdl2-image-2.0-0:armhf libsdl2-mixer-2.0-0:armhf libsdl2-ttf-2.0-0:armhf libopenal1:armhf libpng16-16:armhf libfontconfig1:armhf libxcomposite1:armhf libbz2-1.0:armhf libxtst6:armhf libcairo2:armhf libxdamage1:armhf
 echo "Don't forget to compile/install Box64!"
fi

echo "Script complete."
