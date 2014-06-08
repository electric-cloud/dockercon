#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "You must run this script as root." 1>&2
    exit 1
fi

ret=true
getent passwd ec >/dev/null 2>&1 && ret=false
if $ret; then
    echo "The ec user does not exist."
    exit 1
fi

if [[ ! -f /opt/ElectricCommander-5.0.1.73229 ]]; then
    echo "/opt/ElectricCommander-5.0.1.73229 not found!"
    exit 1
fi

if [[ ! -f /opt/mysql-connector-java.jar ]]; then
    echo "/opt/mysql-connector-java.jar not found!"
    exit 1
fi

if [ -z "$1" ] ; then
	echo "Please pass in the IP address";
	exit 1
fi

IP_ADDRESS=$1

# Update
apt-get -y update

# Install 32-bit compatibility libraries
apt-get -y install ia32-libs

# Install git
apt-get -y install git

# Install Commander without the built-in database
/opt/ElectricCommander-* --mode silent \
--installServer \
--installWeb \
--installAgent \
--installRepository \
--unixServerUser ec \
--unixServerGroup ec \
--useSameServiceAccount
. /opt/electriccloud/electriccommander/bash.profile

# Install MySQL
dpkg-reconfigure --frontend noninteractive tzdata
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password commander'
debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password commander'
apt-get -y install mysql-server

# Configure MySQL
mysqladmin -uroot -pcommander create commander
mysql -u root -pcommander -e \
  "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'commander' WITH GRANT OPTION;"
sed -i.bak -e 's/127.0.0.1/0.0.0.0/' /etc/mysql/my.cnf
restart mysql

# Copy the MySQL connector JAR
cp /opt/mysql-connector-java.jar /opt/electriccloud/electriccommander/server/lib

# Configure Commander to talk to MySQL
ectool setDatabaseConfiguration \
  --databaseType mysql \
  --databaseName commander \
  --userName root \
  --password commander \
  --hostName localhost
/etc/init.d/commanderServer restart
ectool getServerStatus --block 1

# Login
ectool login admin changeme

# Set the IP address for the local resource
ectool modifyResource local --hostName $IP_ADDRESS
ectool pingResource local

# Make the default workspace local
ectool modifyWorkspace default --local 1

# Set the IP address for the repository server
ectool modifyRepository default --url "https://$IP_ADDRESS:8200"
