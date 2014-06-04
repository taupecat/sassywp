#!/usr/bin/env bash

echo "Install Node and npm"
apt-get update
apt-get install -y software-properties-common python-software-properties
apt-get install -y python g++ make
add-apt-repository -y ppa:chris-lea/node.js
apt-get update
apt-get install -y nodejs

echo "Installing gulp globally"
npm install gulp -g

echo "Installing Local Packages"
cd /vagrant
npm install

echo "Installing Ruby"
apt-get install -y ruby-full build-essential
apt-get install -y rubygems

echo "Installing Sass"
gem install sass

# echo "Running gulp for build compilation"
# cd /vagrant
# gulp

echo "Installing apache2..."
apt-get update
apt-get install -y apache2 libapache2-mod-php5 php5-gd php5-curl >/dev/null 2>&1
rm -rf /var/www
ln -fs /vagrant /var/www
a2enmod rewrite
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/sites-enabled/000-default

echo "Installing php5..."
apt-get install -y php5 >/dev/null 2>&1

echo "Installing curl..."
apt-get install -y curl >/dev/null 2>&1

echo "Installing Subversion"
apt-get install -y subversion >/dev/null 2>&1

echo "Installing composer"
curl -sS https://getcomposer.org/installer | php

echo "Installing packages from composer"
cd /var/www
php composer.phar install
mv composer.phar /usr/local/bin/composer

echo "Installing mysql..."
MYSQL_PASS="password"
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_PASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_PASS"
apt-get install -y mysql-server mysql-client >/dev/null 2>&1
mysql -uroot -p$MYSQL_PASS -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '"$MYSQL_PASS"'; FLUSH PRIVILEGES;"
service mysql restart
mysql -uroot -p$MYSQL_PASS -e "CREATE DATABASE wordpress;"
mysql -uroot -p$MYSQL_PASS wordpress < /vagrant/db/wordpress-migrate-20140602015756.sql


echo "Getting php5 & mysql to talk to each other..."
apt-get install -y php5-mysql >/dev/null 2>&1

echo "Installing vim..."
apt-get install -y vim >/dev/null 2>&1

echo "Restarting Apache"
service apache2 restart

echo "Installing wp-cli..."
curl -L https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp