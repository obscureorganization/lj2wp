#!/bin/bash
#
# Adapted from https://gist.github.com/danielpataki/0861bf91430bf2be73da#file-way-sh
# and https://premium.wpmudev.org/blog/vagrant-wordpress-test-environment/
#
# Which was adapted from https://gist.github.com/JeffreyWay/9244714/
# See: https://gist.github.com/JeffreyWay/af0ee7311abfde3e3b73
#
set -euo pipefail

# Set Bash unofficial strict mode http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

apt-get -qq update

debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

apt-get -q -y install vim curl python-software-properties php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core php5-xdebug

a2enmod rewrite
service apache2 restart

# Install ljdump
if [[ ! -d /var/www/ljdump ]]; then
    git clone https://github.com/ghewgill/ljdump.git /var/www/ljdump
fi

# Install wordpress
WPVERSION=2.7.1
if [[ ! -d /var/www/wordpress ]]; then
    curl "https://wordpress.org/wordpress-$WPVERSION.tar.gz" \
        | (cd /var/www/ && tar -xvzf - )
fi

# Create wordpress database
if ! mysql -u root --password=root <<<"show databases;" \
    | grep '^wordpress$' > /dev/null; then
    mysqladmin create wordpress --password='root'
fi

# Configure wp
WP_CONFIG=/var/www/wordpress/wp-config.php
cp /var/www/wordpress/wp-config-sample.php $WP_CONFIG
cd /var/www/wordpress
patch < ../wp-config.php.patch
