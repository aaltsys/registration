#! /usr/bin/env bash

apt-get -y install aptitude
aptitude -y install links lynx ruby-full unzip openvpn screen dialog python-software-properties byobu gdebi autofs ntfsprogs curl smbclient
#add-apt-repository ppa:hplip-isv/ppa
aptitude -y update
aptitude -y install hpijs hpijs-ppds hplip hplip-cups hplip-data
wget http://www.webmin.com/download/deb/webmin-current.deb -O /tmp/webmin.deb
dpkg -i /tmp/webmin.deb
apt-get -y -f install
rm /tmp/webmin.deb

wget https://raw.github.com/aaltsys/registration/master/registration.rb -O /tmp/reg.rb
/usr/bin/ruby /tmp/reg.rb
rm /tmp/reg.rb
rm /tmp/i
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



aptitude -y upgrade