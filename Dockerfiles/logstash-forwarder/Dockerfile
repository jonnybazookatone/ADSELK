# Dockerizing Logstash-forwarder:
# Dockerfile for building logstash-forwarder on an ubuntu machine

# OS to use
FROM ubuntu:latest
MAINTAINER Jonny Eliott <jonathan.elliott@cfa.havard.edu>


# Provisioning
## Install Go from the tar download
RUN apt-get install git curl -y

## Download and build Go
RUN curl -L https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz | tar xvz -C /tmp && mv /tmp/go /usr/local/go

## Clone the Logstash-forwarder repo and build with Go
RUN git clone git://github.com/elasticsearch/logstash-forwarder.git /opt/logstash-forwarder
WORKDIR /opt/logstash-forwarder/
RUN /usr/local/go/bin/go build -o logstash-forwarder


# Configuration files
## logstash config
#COPY resources/logstash-apache.conf /etc/logstash/conf.d/
#COPY resources/logstash-forwarder.key /etc/pki/tls/private/logstash-forwarder/
#COPY resources/logstash-forwarder.crt /etc/pki/tls/certs/logstash-forwarder/


# How the docker container is interacted with
##
ENTRYPOINT ["/opt/logstash-forwarder/logstash-forwarder"]
CMD ["-config", "/etc/logstash/conf.d/logstash-forwarder.conf", ">> /var/log/logstash-forwarder.log", "2>> /var/log/logstash-forwarder.log"]
