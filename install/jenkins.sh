#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "You must run this script as root." 1>&2
   exit 100
fi

# Update
apt-get -y update

# Install Jenkins
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
apt-get -y update
apt-get -y install jenkins
