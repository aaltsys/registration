#! /usr/bin/env bash

# Place copy of this script in repository doc-server3/install/_downloads

wget https://raw.github.com/aaltsys/registration/master/aaltsys-vpn -O /etc/init.d/aaltsys-vpn
update-rc.d -f aaltsys-vpn defaults 
