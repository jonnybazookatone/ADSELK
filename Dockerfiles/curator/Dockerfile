# Dockerizing Elasticsearch:
# Dockerfile for building elasticsearch on an ubuntu machine
# Elasticsearch will listen on port 9200 for web traffic:

# OS to use
FROM phusion/baseimage
MAINTAINER Jonny Eliott <jonathan.elliott@cfa.havard.edu>

## Install dependencies
RUN apt-get install -y python python-pip

## Install curator
RUN pip install elasticsearch-curator

# How the docker container is interacted with
##
ENTRYPOINT ["curator.py"]

