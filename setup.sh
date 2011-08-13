#!/bin/sh

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

apt-get --yes update

for X in libapache2-mod-php5 php5-mysql mysql-server; do
	apt-get --yes install $X
done

mkdir /vagrant/log && chmod 0775 /vagrant/log
groupid=`stat -c#%g /vagrant/log`
echo "export APACHE_RUN_GROUP=$groupid" >> /etc/apache2/envvars

cat > /etc/apache2/sites-available/vagrant <<YUKKS
<VirtualHost *:80>

    DocumentRoot /var/www
    <Directory />
        Options FollowSymLinks
        AllowOverride None
    </Directory>

    <Directory /var/www>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride all
        Order allow,deny
        allow from all
    </Directory>

    ErrorLog /vagrant/log/error.log
    LogLevel info

    CustomLog /vagrant/log/access.log combined

</VirtualHost>
YUKKS

a2enmod rewrite
a2dissite default
a2ensite vagrant

echo '<?php phpinfo(); ?>' > /var/www/index.php
rm -v /var/www/index.html

/etc/init.d/apache2 restart
