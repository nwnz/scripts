#!/bin/sh
sudo ifconfig eth0 192.168.0.2 netmask 255.255.255.0
sudo route add default gw 192.168.0.1
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf



