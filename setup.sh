#!/bin/sh

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

apt-get --yes update

for X in patch libapache2-mod-php5 php5-mysql mysql-server; do
	apt-get --yes install $X
done

cat <<MYSEEQUAL | mysql -u root
CREATE DATABASE wordpress;
GRANT ALL ON wordpress.* TO wordpress@localhost IDENTIFIED BY '';
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

cat > /etc/apache2/conf.d/wordpress <<YUKKS
<Directory /var/www>
    AllowOverride all
</Directory>
YUKKS

cd /vagrant && \
wget --timestamping \
    http://wordpress.org/wordpress-3.2.1.tar.gz && \
sudo -u\#$ownerid tar zvxf wordpress-3.2.1.tar.gz

rm -v /var/www/index.html
rmdir /var/www
ln -s /vagrant/wordpress /var/www

kns=`wget -q -O - --no-check-certificate \
    https://api.wordpress.org/secret-key/1.1/salt/`

cd /var/www/ && \
echo "<?php $kns ?>" > keys-n-salts.php && \
cp -v wp-config-sample.php wp-config.php && \
patch < /vagrant/wp-config.patch

/etc/init.d/apache2 restart
