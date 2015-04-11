#!/bin/bash
sudo docker build --tag adsabs/elasticsearch Dockerfiles/elasticsearch/
sudo docker build --tag adsabs/logstash Dockerfiles/logstash/
sudo docker build --tag adsabs/kibana Dockerfiles/kibana/
sudo docker build --tag adsabs/logstash-forwarder Dockerfiles/logstash-forwarder/
