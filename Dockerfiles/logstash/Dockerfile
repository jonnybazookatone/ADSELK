# Dockerizing Logstash:
# Dockerfile for building logstash on an ubuntu machine
# Logstash will listen for Logstash-forwarder on port:

# OS to use
FROM ubuntu:latest
MAINTAINER Jonny Eliott <jonathan.elliott@cfa.havard.edu>


# Provisioning
## Get the elasticsearch PGP key
RUN apt-key adv --keyserver hkp://pgp.mit.edu --recv D88E42B4

## Add Logstash to the apt-get source list
RUN echo 'deb http://packages.elasticsearch.org/logstash/1.4/debian stable main' > /etc/apt/sources.list.d/logstash.list

## Update the apt-get source list
RUN apt-get update

## Install dependencies
RUN apt-get install -y logstash


# Configuration files
## logstash config
## Should be sitting on S3 now
#COPY resources/logstash-apache.conf /etc/logstash/conf.d/
#COPY resources/logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder/
#COPY resources/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder/
RUN mkdir -p /etc/logstash/conf.d/

# Define the entry point for docker<->logstash
## Logstash-forwarder
EXPOSE 6767


# How the docker container is interacted with
##
ENTRYPOINT ["/opt/logstash/bin/logstash", "-l", "/var/log/logstash/logstash.log", "-f", "/etc/logstash/conf.d/logstash.conf"]
CMD []
