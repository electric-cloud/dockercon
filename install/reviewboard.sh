#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "You must run this script as root." 1>&2
   exit 100
fi

# Update
apt-get -y update

# Install MySQL
dpkg-reconfigure --frontend noninteractive tzdata
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password reviewboard'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password reviewboard'
apt-get -y install mysql-server

mysqladmin -uroot -previewboard create reviewboard
mysql -u root -previewboard -e \
  "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'reviewboard' WITH GRANT OPTION;"
sed -i.bak -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
restart mysql

# Install Apache
apt-get -y install apache2 libapache2-mod-wsgi

# Install dependencies
apt-get -y install python-setuptools python-dev memcached patch python-mysqldb python-subvertpy python-svn

# Install ReviewBoard
easy_install ReviewBoard
rb-site install /var/www/rb
# Responses for prompts:
#   HOSTNAME_OR_IP
#   <default>
#   mysql
#   <default>
#   <default>
#   root
#   reviewboard
#   reviewboard
#   <default>
#   <default>
#   reviewboard
#   reviewboard
#   test@example.com

# Install CLI tools
apt-get -y install python-rbtools

# Configure Apache
chown -R www-data /var/www/rb/htdocs/media/uploaded
chown -R www-data /var/www/rb/data
chown -R www-data /var/www/rb/htdocs/media/ext
cp /var/www/rb/conf/apache-wsgi.conf /etc/apache2/sites-available/rb.conf
ln -s /etc/apache2/sites-available/rb.conf /etc/apache2/sites-enabled/rb.conf
service apache2 restart
