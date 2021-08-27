#!/usr/bin/bash

if type "composer" > /dev/null 2>&1; then
    current_path=`which composer`
    echo "INFO: You already have ${current_path}"
    exit;
fi

if  ! type "php" > /dev/null 2>&1; then
    echo "ERROR: You need PHP for this installatiion..."
    echo "INFO: Installation terminated."
    exit;
fi

php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer
sudo chown root:root /usr/local/bin/composer

if type "composer" > /dev/null 2>&1; then
    echo "INFO: Installation concluded successfully!!"
else
    echo "ERROR: Sorry, something went wrong..."
fi