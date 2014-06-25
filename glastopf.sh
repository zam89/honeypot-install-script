#!/bin/bash
# Written by Mohd Khairulazam
# Honeypot Auto-Install Script
# Bug reports welcome
# email = m.khairulazam@gmail.com

echo "Type your mysql root password, followed by [ENTER]:"
read mysql

{
	
	apt-get update
	apt-get install python2.7 python-openssl python-gevent libevent-dev python2.7-dev build-essential make liblapack-dev libmysqlclient-dev python-chardet python-requests python-sqlalchemy python-lxml python-beautifulsoup mongodb python-pip python-dev python-numpy python-setuptools python-numpy-dev python-scipy libatlas-dev g++ git php5 php5-dev gfortran mysql-server python-mysqldb libxml2 libxslt-dev libffi-dev -y
	pip install --upgrade distribute
	pip install --upgrade gevent webob pyopenssl chardet lxml sqlalchemy jinja2 beautifulsoup requests cssselect pymongo MySQL-python hpfeeds pylibinjection libtaxii greenlet
	
	# Install hpfeeds
	cd /opt
	git clone https://github.com/rep/hpfeeds.git
	cd hpfeeds
	python setup.py build
	python setup.py install
	
	# Install BFR
	cd /opt
	git clone git://github.com/glastopf/BFR.git
	cd BFR
	sudo phpize
	sudo ./configure --enable-bfr
	sudo make
	sudo make install
	
	# Edit php.ini
	/etc/php5/apache2/php.ini
	/etc/php5/cli/php.ini
	zend_extension = /usr/lib/php5/20090626/bfr.so
	
	# Copy glastopf source code
	cd /opt
	sudo git clone https://github.com/glastopf/glastopf.git
	
	# Install Pylinjection
	git clone --recursive https://github.com/glastopf/pylibinjection.git
	rm /opt/pylibinjection/src/pylibinjection.c
	cd pylibinjection/
	python setup.py build
	python setup.py install
	
	# Install glastopf
	cd /opt/glastopf
	sudo python setup.py build
	sudo python setup.py install
	
	cd /opt
	sudo mkdir glaspot
	wget https://github.com/zam89/maduu/raw/master/conf/glastopf.cfg
	
	# Create database named glaspot & set permission
	mysql --user="root" --password="$mysql" --execute="create database glaspot; create user 'glaspot'@'localhost' identified by 'gl@sp0t'; grant all privileges on glaspot.* to 'glaspot'@'localhost'; flush privileges;"
	
	wget https://github.com/zam89/maduu/raw/master/init/glastopf -O /etc/init.d/glastopf
	chmod 755 /etc/init.d/glastopf
	chmod +x /etc/init.d/glastopf

} 2>&1 | tee hornet.log

