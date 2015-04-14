#!/bin/bash

# Install docker and git
yum install docker git -y

# Clone the repository that contains the relevant docker files
git clone https://github.com/jonnybazookatone/ADSELK.git

# Start docker
service docker start

# Build Logstash container
cd ADSELK/
docker build --tag adsabs/logstash Dockerfiles/logstash/

# Copy the correct logstash configuration file
cp conf/logstash.conf /etc/logstash.conf

# Run the container
docker run -d --hostname logstash --name logstash -v /vagrant/conf/logstash.conf:/etc/logstash.conf -p 6767:6767 adsabs/logstash
