#! /usr/bin/env bash

# webmin
if [ ! -d '/etc/webmin' ] ; then
   wget http://www.webmin.com/download/deb/webmin-current.deb -O /tmp/webmin.deb
   dpkg -i /tmp/webmin.deb
   apt-get -y -f install
   rm /tmp/webmin.deb
fi

# ruby-full
if [ ! -d '/usr/bin/ruby' ] ; then
   apt-get -y install ruby-full
fi

# openvpn
apt-get -y install openvpn

#add-apt-repository ppa:hplip-isv/ppa
# hplip and other utilities
apt-get -y install hpijs hpijs-ppds hplip hplip-cups hplip-data
apt-get -y install autofs byobu screen links lynx unzip dialog gdebi
apt-get -y install python-software-properties ntfsprogs curl smbclient

apt-get -y -f install
apt-get -y update

wget https://raw.github.com/aaltsys/registration/master/registration.rb -O /tmp/reg.rb
/usr/bin/ruby /tmp/reg.rb
rm /tmp/reg.rb
echo "Press enter to continue..."
read

# create default script variables for aaltsysvpn
sudo bash < <(echo 'echo "AUTOSTART=\"aaltsys\"" > /etc/default/aaltsysvpn')
# create boot init script for aaltsysvpn (copied from openvpn script)
sudo cp /etc/init.d/openvpn /etc/init.d/aaltsysvpn
# edit script to point to aaltsysvpn default script variables
sudo sed -i s/"default\/openvpn"/"default\/aaltsysvpn"/ /etc/init.d/aaltsysvpn
# create run-level pointers to the aaltsysvpn script
sudo update-rc.d aaltsysvpn defaults
# change vpn configuration "client" to "aaltsys"
sudo mv /etc/openvpn/client.conf /etc/openvpn/aaltsys.conf

sudo invoke-rc.d aaltsysvpn start

mkdir -p /home/mnt/backup/source_config

apt-get -y upgrade
