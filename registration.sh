#! /usr/bin/env bash

aptitude -y install ruby-full unzip openvpn screen dialog python-software-properties byobu
add-apt-repository ppa:hplip-isv/ppa
aptitude update
aptitude install hpijs hpijs-ppds hplip hplip-cups hplip-data

wget https://raw.github.com/aaltsys/registration/master/registration.rb -o /tmp/reg.rb

chmod +w /etc/rc.local
sed -i 's%exit 0%/etc/init.d/openvpn start client%' /etc/rc.local
echo "exit 0" >> /etc/rc.local
chmod -w /etc/rc.local

/usr/bin/ruby /tmp/reg.rb
rm /tmp/reg.rb