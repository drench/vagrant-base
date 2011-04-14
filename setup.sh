#!/bin/sh

DEBIAN_FRONTEND=noninteractive
export DEBIAN_FRONTEND

apt-get --yes update

for X in libapache2-mod-php5 php5-mysql mysql-server; do
	apt-get --yes install $X
done

echo '<?php phpinfo(); ?>' > /var/www/index.php
rm -v /var/www/index.html

/etc/init.d/apache2 restart
