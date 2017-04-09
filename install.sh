#!/bin/bash
#
# Adapted from https://gist.github.com/danielpataki/0861bf91430bf2be73da#file-way-sh
#

sudo apt-get update

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

sudo apt-get install -y vim curl python-software-properties
#sudo add-apt-repository -y ppa:ondrej/php5
sudo apt-get update

#sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt php5-readline mysql-server-5.5 php5-mysql git-core php5-xdebug
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-curl php5-gd php5-mcrypt mysql-server-5.5 php5-mysql git-core php5-xdebug git

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

sudo a2enmod rewrite

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini
sed -i "s/disable_functions = .*/disable_functions = /" /etc/php5/cli/php.ini

sudo service apache2 restart

# Install composer
if [[ ! -x /usr/local/bin/composer ]]; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

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
mysqladmin create wordpress --password='root'

# Configure wp
WP_CONFIG=/var/www/wordpress/wp-config.php
cp /var/www/wordpress/wp-config-sample.php $WP_CONFIG
cd /var/www/wordpress
patch < ../wp-config.php.patch
