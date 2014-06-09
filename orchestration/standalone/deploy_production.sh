# Retrieve docker files artifact to /opt/jpetstore/$build_id/docker
# Retrieve jpetstore.war to /opt/jpetstore/$build_id/docker

# Set target_port to a port internal to the docker host
docker ps|grep '$target_port->8080'|awk '{ print "docker rm -f "$1"" }'|sh
cd /opt/jpetstore/$build_id/docker
docker build -t nikhilv/jpetstore-$target_port .
docker run -p $target_port:8080 nikhilv/jpetstore-$target_port &
sleep 2
wget -t 10 localhost:$target_port/jpetstore/actions/Catalog.action
etcdctl set ecdemo/upstream $target_port
confd -node 'http://127.0.0.1:4001' -onetime -confdir /etc/confd
