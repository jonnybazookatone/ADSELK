#!/bin/bash

# Install docker
yum install docker -y

# Build Elasticsearch and Kibana containers
sudo docker build --tag adsabs/elasticsearch Dockerfiles/elasticsearch/
sudo docker build --tag adsabs/kibana Dockerfiles/kibana/

# Run the containers
sudo docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 adsabs/elasticsearch
sudo docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 adsabs/kibana
