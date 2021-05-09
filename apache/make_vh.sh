#!/usr/bin/bash

read -p "Enter a HostName: " hostname;

#create log dir if doesn't exist yet
if [ ! -d /var/www/${hostname}/logs ]; then
  read -p "Enter a OwnerName: " ownername;
  sudo mkdir -p -m 755 /var/www/${hostname}/logs
  sudo chown -R ${ownername}:${ownername} /var/www/${hostname}/logs
  sudo chown -R apache:apache /var/www/${hostname}/logs
fi


sudo mkdir -p -m 755 /etc/httpd/conf.d/vh/
# back up if file already exists
if [ -f /etc/httpd/conf.d/vh/virtual_host.conf ]; then
  sudo cp -p /etc/httpd/conf.d/vh/virtual_host.conf /etc/httpd/conf.d/vh/virtual_host.conf.`date +%Y%m%d`
fi
# create config file and set up
sudo cp virtual_host.conf /etc/httpd/conf.d/vh/
sudo sed -i -e "s@{{ host_name }}@${hostname}@g" /etc/httpd/conf.d/vh/virtual_host.conf

sudo systemctl restart httpd