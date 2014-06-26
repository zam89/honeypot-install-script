#!/bin/bash
# Written by Mohd Khairulazam
# Honeypot Auto-Install Script
# Bug reports welcome
# email = m.khairulazam@gmail.com

echo "Type your mysql root password, followed by [ENTER]:"
read -s mysql

{
  
  # Update repo
  apt-get update --fix-missing
  apt-get upgrade

  # Move SSH server from Port 22 to Port 66534
  sed -i 's:Port 22:Port 65534:g' /etc/ssh/sshd_config
  service ssh reload

  # Install required packages from repo
  apt-get install ssh subversion mysql-server python-dev openssl python-openssl python-pyasn1 python-twisted python-mysqldb python-pip python-software-properties iptables gcc -y

  # Create /opt/kippo directory
  mkdir /opt/kippo/

  # Download Kippo source code to your server
  svn checkout http://kippo.googlecode.com/svn/trunk/ /opt/kippo/
  # git clone https://github.com/zam89/kippo.git

  # Add kippo user that can't login
  useradd -r -s /bin/false kippo

  # Create database named kippo & set permission
  mysql --user="root" --password="$mysql" --execute="create database kippo; create user 'kippouser'@'localhost' identified by 'kippos3ns0r'; grant all privileges on kippo.* to 'kippouser'@'localhost'; flush privileges;"

  # Import mysql structure to database
  cd /opt/kippo/doc/sql
  mysql -u kippouser -p'$mysql' kippo < mysql.sql

  # Copy kippo config file
  cd /opt/kippo/
  wget https://github.com/zam89/maduu/raw/master/conf/kippo.cfg

  # Set iptables
  iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222

  # Create log dir 
  mkdir -p /var/kippo/dl
  mkdir -p /var/kippo/log/tty
  mkdir -p /var/run/kippo

  # Delete old dirs to prevent confusion
  rm -rf /opt/kippo/dl
  rm -rf /opt/kippo/log

  # Set up permissions
  chown -R kippo:kippo /opt/kippo/
  chown -R kippo:kippo /var/kippo/
  chown -R kippo:kippo /var/run/kippo/

  # set up hpfeeds
  cd /opt/kippo/kippo/dblog/
  wget https://github.com/zam89/maduu/raw/master/hpfeeds/kippo/hpfeeds.py

  # Install iptables-persistent
  apt-get install iptables-persistent -y

  # Start kippo
  wget https://github.com/zam89/maduu/raw/master/init/kippo -O /etc/init.d/kippo
  chmod 755 /etc/init.d/kippo
  chmod +x /etc/init.d/kippo

  mkdir /var/run/kippo
  chown -R kippo:kippo /var/run/kippo
  /etc/init.d/kippo start

  # Set proper permission
  chown kippo /opt/kippo/
  chgrp kippo /opt/kippo/
  chown kippo /opt/kippo/data/
  chgrp kippo /opt/kippo/data/
  chown kippo /var/kippo/log/
  chgrp kippo /var/kippo/log/
  chown kippo /var/kippo/log/tty/
  chgrp kippo /var/kippo/log/tty/

} 2>&1 | tee hornet.log

