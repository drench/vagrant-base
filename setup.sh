#!/bin/sh

apt-get --yes update

for X in build-essential g++ curl libssl-dev apache2-utils pkg-config; do
	apt-get --yes install $X
done

ownerid=`stat -c%u /vagrant`

version=0.4.9

cd /vagrant && \
wget --timestamping http://nodejs.org/dist/node-v${version}.tar.gz && \
sudo -u\#$ownerid tar zvxf node-v${version}.tar.gz && \
cd node-v${version} && \
./configure && \
make && \
make install
