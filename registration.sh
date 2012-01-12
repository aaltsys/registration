#! /usr/bin/env bash

aptitude -y install ruby-full unzip openvpn screen dialog python-software-properties
add-apt-repository ppa:hplip-isv/ppa
aptitude update
aptitude install hpijs hpijs-ppds hplip hplip-cups hplip-data

wget https://raw.github.com/aaltsys/registration/master/registration.rb -o /tmp/reg.rb

/usr/bin/ruby /tmp/reg.rb
rm /tmp/reg.rb