# Dockerizing Kibana:
# Dockerfile for building kibana on an ubuntu machine

# OS to use
FROM ubuntu:latest
MAINTAINER Jonny Eliott <jonathan.elliott@cfa.havard.edu>


# Provisioning
## Download the tarred file, untar, and place in the correct location
### Replace when github has Large File Storage activated
RUN apt-get install curl -y
RUN curl -L https://download.elasticsearch.org/kibana/kibana/kibana-4.0.0-linux-x64.tar.gz | tar xvz -C /opt/ && mv /opt/kibana-4.0.0-linux-x64/ /opt/kibana/


# Define the entry point for docker<->kibana
## GUI Interface for Kibana
EXPOSE 5601

RUN echo 'haha'
# How the docker container is interacted with
##
ENTRYPOINT ["/opt/kibana/bin/kibana"]
CMD ["-c", "/etc/kibana/config/kibana.yml"]
#CMD ["-e", "http://elasticsearch:9200"]
