#! /usr/bin/env bash

echo "Register and configure AAltsys openVPN client"

if [[ $EUID -ne 0 ]] ; then echo -e "\e[1;31m try again using sudo \e[0m" ; exit 1 ; fi

# Install ruby-full and openvpn if missing
APT=0
PKGS="ruby-full openvpn"
for i in $PKGS
do
   dpkg -s $i > null
   if [ $? -ne 0 ] ; then
      APT=1
      echo "$i is missing, it will be installed"
      apt-get -y install $i
   fi
done

# wget https://raw.github.com/aaltsys/registration/master/registration.rb -O /tmp/reg.rb
wget https://raw.github.com/aaltsys/doc-servers/master/resources/_downloads/registration.rb -O /tmp/reg.rb
/usr/bin/ruby /tmp/reg.rb
rm /tmp/reg.rb
echo "Press enter to continue..."
read

# create default script variables for aaltsysvpn
# bash < <(echo 'echo "AUTOSTART=\"aaltsys\"" > /etc/default/aaltsysvpn')
echo "AUTOSTART=\"aaltsys\"" > /etc/default/aaltsysvpn
# create boot init script for aaltsysvpn (copied from openvpn script)
cp /etc/init.d/openvpn /etc/init.d/aaltsysvpn
# edit script to point to aaltsysvpn default script variables
sed -i s/"default\/openvpn"/"default\/aaltsysvpn"/ /etc/init.d/aaltsysvpn
# create run-level pointers to the aaltsysvpn script
update-rc.d aaltsysvpn defaults
# change vpn configuration "client" to "aaltsys"
mv /etc/openvpn/client.conf /etc/openvpn/aaltsys.conf

invoke-rc.d aaltsysvpn start

mkdir -p /home/mnt/backup/source_config

# webmin
if [ ! -d '/etc/webmin' ] ; then
   echo "Installing Webmin"
   wget http://www.webmin.com/download/deb/webmin-current.deb -O /tmp/webmin.deb
   dpkg -i /tmp/webmin.deb
   apt-get -y -f install
   rm /tmp/webmin.deb
fi

# add-apt-repository ppa:hplip-isv/ppa
# hplip and other utilities
echo "Installing additional packages"
PKGS="hpijs hpijs-ppds hplip hplip-cups hplip-data autofs screen links lynx unzip dialog python-software-properties ntfs-3g ntfsprogs curl smbclient"
for i in $PKGS
do
   dpkg -s $i > null
   if [ $? -ne 0 ] ; then
      APT=1
      echo "$i is missing, it will be installed"
      apt-get -y install $i
   fi
done

if [ $APT -ne 0 ] 
then
   echo -e  "\e[1;31m Updating system packages, this may take a while \e[0m"
   apt-get -y -f install
   apt-get -y update && apt-get -y dist-upgrade
fi

exit 0