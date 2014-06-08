# Installing gvm

sudo apt-get install curl -y
sudo apt-get install git -y
bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
source /home/vagrant/.gvm/scripts/gvm
sudo apt-get install mercurial -y
sudo apt-get install bison -y
sudo apt-get install make -y

# Install GO
gvm install go1.2
gvm use go1.2
