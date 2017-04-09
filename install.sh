#!/bin/bash
#
# Adapted from https://gist.github.com/danielpataki/0861bf91430bf2be73da#file-way-sh
# and https://premium.wpmudev.org/blog/vagrant-wordpress-test-environment/
#
# Which was adapted from https://gist.github.com/JeffreyWay/9244714/
# See: https://gist.github.com/JeffreyWay/af0ee7311abfde3e3b73
#

sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install -y vim curl python-software-properties
sudo apt-get update

sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core php5-xdebug

sudo a2enmod rewrite

#sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
#sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
#sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

sudo service apache2 restart

# Install ljdump
if [[ ! -d /var/www/ljdump ]]; then
    git clone https://github.com/ghewgill/ljdump.git /var/www/ljdump
fi

WPVERSION=2.7.1
# Install wordpress
if [[ ! -d /var/www/wordpress ]]; then
    curl "https://wordpress.org/wordpress-$WPVERSION.tar.gz" \
        | (cd /var/www/ && tar -xvzf - )
fi

# Create wordpress database
if ! mysql -u root --password=root <<<"show databases;" | grep '^wordpress$'; then
    mysqladmin create wordpress --password='root'
fi

# Configure wp
WP_CONFIG=/var/www/wordpress/wp-config.php
cp /var/www/wordpress/wp-config-sample.php $WP_CONFIG
cd /var/www/wordpress
patch < ../wp-config.php.patch
