#!/bin/bash
dns=`ip addr show eth0 | grep inet | grep eth0 | awk '{print $2}' | cut -d "/" -f -1`
# Run docker containers
sudo docker run -d --hostname elasticsearch --dns $dns --name elasticsearch -p 9200:9200 -p 9300:9300 adsabs/elasticsearch
sudo docker run -d --hostname logstash --dns $dns --name logstash -v /vagrant/conf/logstash.conf:/etc/logstash.conf -p 6767:6767 adsabs/logstash
sudo docker run -d --hostname kibana --dns $dns --name kibana -p 5601:5601 adsabs/kibana
sudo docker run -d --hostname logstash-forwarder --dns $dns --name logstash-forwarder -v /vagrant/conf/logstash-forwarder.conf:/etc/logstash-forwarder.conf -v /vagrant/logs/apache/access_log:/vagrant/logs/apache/access_log adsabs/logstash-forwarder
