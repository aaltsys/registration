#! /usr/bin/env bash

aptitude -y install ruby-full unzip openvpn screen dialog python-software-properties byobu gdebi autofs ntfsprogs curl smbclient
add-apt-repository ppa:hplip-isv/ppa
aptitude -y update
aptitude -y install hpijs hpijs-ppds hplip hplip-cups hplip-data
wget http://www.webmin.com/download/deb/webmin-current.deb -O /tmp/webmin.deb
dpkg -i /tmp/webmin.deb
apt-get -y -f install
rm /tmp/webmin.deb

wget https://raw.github.com/aaltsys/registration/master/registration.rb -O /tmp/reg.rb
/usr/bin/ruby /tmp/reg.rb
rm /tmp/reg.rb
echo "Press enter to continue..."
read

chmod +w /etc/rc.local
sed -i 's%exit 0%/etc/init.d/openvpn start client%' /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod -w /etc/rc.local
invoke-rc.d openvpn restart client
mkdir -p /home/mnt/backup/source_config



aptitude -y upgrade