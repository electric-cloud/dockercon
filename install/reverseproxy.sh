# Installing gvm

sudo apt-get install curl -y
sudo apt-get install git -y
sudo apt-get install mercurial make binutils bison gcc build-essential -y
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)

source /home/vagrant/.gvm/scripts/gvm


# Install GO
gvm install go1.2
gvm use go1.2


# Install newer nginx
sudo apt-get install python-software-properties -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:nginx/stable -y
sudo apt-get update -y
sudo apt-get install nginx -y

# Install confd

wget -O confd_0.3.0_linux_amd64.tar.gz https://github.com/kelseyhightower/confd/releases/download/v0.3.0/confd_0.3.0_linux_amd64.tar.gz
tar -zxvf confd_0.3.0_linux_amd64.tar.gz
sudo mv confd /usr/local/bin/confd

# Install etcdtl

git clone https://github.com/coreos/etcdctl.git
cd etcdctl
./build 
sudo cp bin/etcdctl /usr/local/bin/etcdctl

# Start the etcd server as a docker container
docker run -d -p 4001:4001 -p 7001:7001 coreos/etcd
