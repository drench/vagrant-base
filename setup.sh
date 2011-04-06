#!/bin/sh

apt-get --yes update

for X in build-essential g++ curl libssl-dev apache2-utils pkg-config; do
	apt-get --yes install $X
done

ownerid=`stat -c%u /vagrant`

cd /vagrant && \
wget --timestamping http://nodejs.org/dist/node-v0.4.5.tar.gz && \
sudo -u\#$ownerid tar zvxf node-v0.4.5.tar.gz && \
cd node-v0.4.5 && \
./configure && \
make && \
make install
