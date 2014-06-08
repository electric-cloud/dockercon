#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "You must run this script as root." 1>&2
    exit 1
fi

if [[ ! -f /opt/ElectricCommander-5.0.1.73229 ]]; then
    echo "/opt/ElectricCommander-5.0.1.73229 not found!"
    exit 1
fi

if [[ ! -f /opt/apache-ant-1.9.3-bin.tar.gz ]]; then
    echo "/opt/apache-ant-1.9.3-bin.tar.gz not found!"
    exit 1
fi

if [[ ! -f /opt/apache-maven-3.2.1-bin.tar.gz ]]; then
    echo "/opt/apache-maven-3.2.1-bin.tar.gz not found!"
    exit 1
fi

if [[ ! -f /opt/jdk-7u55-linux-x64.gz ]]; then
    echo "/opt/jdk-7u55-linux-x64.gz not found!"
    exit 1
fi

# Update
apt-get -y update

# Install 32-bit compatibility libraries
apt-get -y install ia32-libs

# Install Jenkins
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
apt-get -y update
apt-get -y install jenkins

# Install git
apt-get -y install git

# Install ElectricCommander agent
/opt/ElectricCommander-* --mode silent \
--installAgent \
--unixAgentUser jenkins \
--unixAgentGroup jenkins

# Unpack everything
cd /usr/local
tar zxvf /opt/apache-ant-1.9.3-bin.tar.gz 
tar zxvf /opt/apache-maven-3.2.1-bin.tar.gz 
tar zxvf /opt/jdk-7u55-linux-x64.gz 

# Create symlinks
ln -s /usr/local/apache-ant-1.9.3 /usr/ant
ln -s /usr/local/apache-maven-3.2.1 /usr/mvn
ln -s /usr/local/apache-maven-3.2.1 /usr/share/maven
ln -s /usr/local/jdk1.7.0_55 /usr/jdk
