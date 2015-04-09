# ADS Elasticsearch/Logstash/Kibana stack for centralised logging

###### Table of content

  <!-- TOC depth:6 withLinks:1 updateOnSave:1 -->

  - [ADS Elasticsearch/Logstash/Kibana stack for centralised logging](#ads-elasticsearchlogstashkibana-stack-for-centralised-logging)
  - [Docker](#docker)
  	- [Building the docker containers](#building-the-docker-containers)
  	- [Interactive mode](#interactive-mode)

  <!-- /TOC -->

# Docker

## Building the docker containers

```
sudo docker --tag logstash build Dockerfiles/logstash/
```

## Interactive mode
```
sudo docker run -i -t logstash /bin/bash
```
