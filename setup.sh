#!/bin/sh

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

apt-get --yes update

for X in patch libapache2-mod-php5 php5-mysql php5-gd mysql-server; do
	apt-get --yes install $X
done

cat <<MYSEEQUAL | mysql -u root
CREATE DATABASE drupal;
GRANT ALL ON drupal.* TO drupal@localhost IDENTIFIED BY '';
MYSEEQUAL

ownerid=`stat -c%u /vagrant`

adduser --no-create-home \
    --uid $ownerid \
    --ingroup www-data \
    --disabled-password \
    --disabled-login \
    --gecos "LAMP user" \
    lamp

echo "export APACHE_RUN_USER=lamp" >> /etc/apache2/envvars

a2enmod rewrite

cat > /etc/apache2/conf.d/drupal <<YUKKS
<Directory /var/www>
    AllowOverride all
    Include /var/www/.htaccess
</Directory>
YUKKS

drupal=drupal-6.24

cd /vagrant && \
wget --timestamping \
    http://ftp.drupal.org/files/projects/$drupal.tar.gz && \
sudo -u\#$ownerid tar zvxf $drupal.tar.gz

rm -v /var/www/index.html
rmdir /var/www
ln -s /vagrant/$drupal /var/www

cd /var/www/sites/default && \
cp -v default.settings.php settings.php && \
patch < /vagrant/settings.patch
chmod 0444 settings.php

/etc/init.d/apache2 restart
