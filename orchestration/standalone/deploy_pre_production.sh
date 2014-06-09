# Retrieve docker files artifact to /opt/jpetstore/$build_id/docker
# Retrieve jpetstore.war to /opt/jpetstore/$build_id/docker

# Docker stop
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)

# Docker build
docker build -t ecdemo/jpetstore$build_id .

# Docker run
docker run -p 8080:8080 ecdemo/jpetstore$build_id &
