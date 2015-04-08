# Dockerizing Logstash:
# Dockerfile for building logstash on an ubuntu machine
# Logstash will listen for Logstash-forwarder on port:

# OS to use
FROM ubuntu:latest

MAINTAINER Jonny Eliott <jonathan.elliott@cfa.havard.edu>
RUN echo 'foo'
# Provisioning
## Get the elasticsearch PGP key
RUN apt-key adv --keyserver hkp://pgp.mit.edu --recv D88E42B4

## Add Logstash to the apt-get source list
RUN add-apt-repository 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main'

## Update the apt-get source list
RUN apt-get update
RUN apt-get dist-upgrade -y
## Install dependencies
RUN apt-get install -y software-properties-common
RUN apt-get install -y logstash
# Define the entry point for docker<->logstash
## Elasticsearch HTTP
EXPOSE 9200

## Elasticsearch communication
EXPOSE 9300
