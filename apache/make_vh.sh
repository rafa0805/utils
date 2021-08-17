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
if [ -f /etc/httpd/conf.d/vh/${hostname}.conf ]; then
  sudo cp -p /etc/httpd/conf.d/vh/${hostname}.conf /etc/httpd/conf.d/vh/${hostname}.conf.`date +%Y%m%d`
fi
# create config file and set up
sudo cp vh_ssl_prod.conf /etc/httpd/conf.d/vh/${hostname}.conf
sudo sed -i -e "s@{{ host_name }}@${hostname}@g" /etc/httpd/conf.d/vh/${hostname}.conf

sudo systemctl restart httpd