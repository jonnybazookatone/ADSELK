#!/bin/bash
sudo docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 adsabs/elasticsearch
sudo docker run -d --name logstash --link elasticsearch:elasticsearch -v /vagrant/conf/logstash.conf:/etc/logstash.conf -p 6767:6767 adsabs/logstash
sudo docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 adsabs/kibana
sudo docker run -d --name logstash-forwarder --link logstash:logstash  -v /vagrant/conf/logstash-forwarder.conf:/etc/logstash-forwarder.conf adsabs/logstash-forwarder
