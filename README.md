# ADS Elasticsearch/Logstash/Kibana stack for centralised logging

###### Table of content
- [ADS Elasticsearch/Logstash/Kibana stack for centralised logging](#ads-elasticsearchlogstashkibana-stack-for-centralised-logging)
  - [Docker](#docker)
    - [Building the docker containers](#building-the-docker-containers)
    - [Interactive mode when docker container is running](#interactive-mode-when-docker-container-is-running)

# Docker

## Building the docker containers

```
sudo docker build --tag adsabs/elasticsearch Dockerfiles/elasticsearch/
sudo docker build --tag adsabs/logstash Dockerfiles/logstash/
sudo docker build --tag adsabs/kibana Dockerfiles/kibana/
sudo docker build --tag adsabs/logstash-forwarder Dockerfiles/logstash-forwarder/
```

## Running the docker containers

  * Elasticsearch
```
sudo docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 adsabs/elasticsearch
```

  * Logstash
```
sudo docker run -d --name logstash --link elasticsearch:elasticsearch -v /vagrant/conf/logstash.conf:/etc/logstash.conf -p 6767:6767 adsabs/logstash
```

  * Kibana
```
sudo docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 adsabs/kibana
```

  * Logstash-forwarder
```
sudo docker run -d --name logstash-forwarder --link logstash:logstash  -v /vagrant/conf/logstash-forwarder.conf:/etc/logstash-forwarder.conf adsabs/logstash-forwarder
```


## Checking the logstash config
```
sudo docker run -i --name logstash -v /vagrant/Dockerfiles/logstash/resources/logstash.conf:/etc/logstash.conf -p 6767:6767 adsabs/logstash --configtest

sudo docker run -t logstash --configtest
```

## Interactive mode when docker container is running
```
sudo docker exec -i -t logstash /bin/bash
```
