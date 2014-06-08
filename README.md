Dockercon Hackathon 2014 -- Team "Electric Cloud"

Team members:
* Nikhil Vaze `@therealnikhil`
* Siddhartha Gupta `@Siddhartha_90`
* Tanay Nagjee `@tanayciousd`

Layout:
* docker - Contains the base Jetty Docker container to which web applications are published.
* install - Installation scripts to set up Docker, Jenkins, ElectricCommander, Nginx.
* jpetstore - Demo web application, cloned from https://github.com/mybatis/jpetstore-6.
* orchestration - Scripts and exports used to orchestrate the preflight & CD pipelines.

Helpful references:
* Install latest stable Nginx on ubuntu: https://www.digitalocean.com/community/articles/how-to-install-the-latest-version-of-nginx-on-ubuntu-12-10
* Configure Nginx to be a reverse proxy w/ etcd + confd: http://brianketelsen.com/2014/02/25/using-nginx-confd-and-docker-for-zero-downtime-web-updates/
* Overview of how Nginx processes requests: http://nginx.org/en/docs/http/request_processing.html
* Nginx doc for load balancing: http://nginx.org/en/docs/http/load_balancing.html
* confd configuration: https://github.com/kelseyhightower/confd/wiki/Configuration-Guide
* Docker images cleanup: http://jimhoskins.com/2013/07/27/remove-untagged-docker-images.html
