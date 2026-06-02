#! /bin/bash

# Removing this file will speed up tinyproxy installation
sudo rm /var/lib/man-db/auto-update

sudo apt-get update
sudo apt-get install tinyproxy -y

echo 'Allow localhost' | sudo tee -a /etc/tinyproxy/tinyproxy.conf

sudo service tinyproxy restart