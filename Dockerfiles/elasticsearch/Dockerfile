# Dockerizing Elasticsearch:
# Dockerfile for building elasticsearch on an ubuntu machine
# Elasticsearch will listen on port 9200 for web traffic:

# OS to use
FROM ubuntu:latest
MAINTAINER Jonny Eliott <jonathan.elliott@cfa.havard.edu>


# Provisioning
## Get the elasticsearch PGP key
RUN apt-key adv --keyserver hkp://pgp.mit.edu --recv D88E42B4

## Add Logstash to the apt-get source list
RUN echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' > /etc/apt/sources.list.d/elasticsearch.list

## Update the apt-get source list
RUN apt-get update

## Install dependencies
RUN apt-get install -y elasticsearch openjdk-7-jdk

# Plugins for elasticsearch
#WORKDIR /usr/share/elasticsearch
RUN /usr/share/elasticsearch/bin/plugin -i lmenezes/elasticsearch-kopf
RUN /usr/share/elasticsearch/bin/plugin -i mobz/elasticsearch-head
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest

# Define the entry point for docker<->logstash
## Elasticsearch HTTP and communication
EXPOSE 9200 9300


# How the docker container is interacted with
##
ENTRYPOINT ["usr/share/elasticsearch/bin/elasticsearch", "--default.path.data=/var/lib/elasticsearch", "--default.path.conf=/etc/elasticsearch", "--default.path.logs=/var/log/elasticsearch"]
