# ADS Elasticsearch/Logstash/Kibana stack for centralised logging

###### Table of content

- [ADS Elasticsearch/Logstash/Kibana stack for centralised logging](#ads-elasticsearchlogstashkibana-stack-for-centralised-logging)
- [Setup](#setup)
	- [ELK Stack](#elk-stack)
- [Development](#development)
	- [Working on a VM](#working-on-a-vm)
	- [Debugging FAQ](#debugging-faq)
- [AWS Deployment](#aws-deployment)
	- [Elastickibana](#elastickibana)
	- [Logstash](#logstash)
	- [Caveats to the deployment](#caveats-to-the-deployment)
- [OpenSSL](#openssl)
	- [Current implementation of openSSL signatures (MUST  be changed when/if Logstash is opened to the internet)](#current-implementation-of-openssl-signatures-must-be-changed-whenif-logstash-is-opened-to-the-internet)
- [Elasticsearch](#elasticsearch)
	- [Debugging](#debugging)

# Setup

## ELK Stack

The following centralised logging stack is being used:

  1. Logstash-forwarder: sits on the server with the relevant log files or log stream, and forwards it to a Logstash instance that sits on another machine.

  1. Logstash: receives logs from logstash-forwarder, parses the logs (*grok*-ing) and outputs to the search engine elasticsearch.

  1. Elasticsearch: receives time-stamped and meta-data rich logs from logstash and indexes them.

  1. Kibana: a web interfrace that can be used to search and make visualisations of the logs that are sent to logstash.

# Development

## Working on a VM

The following describes how to set up the ELK stack, and assumes that each service can be running on a separate machine (i.e, IP address)

  1. Make the SSL certs and keys for logstash/logstash-forwarder

  `deploy/make_certs.sh`

  1. Build the docker containers

  `deploy/build.sh`

  1. Run the docker containers

  `deploy/run.sh`

  1. Set up the localhosts DNS
  `deploy/set_hosts.sh`

This sets up the following:

  1. An elasticsearch docker container that has its web services on port 9200, and its communication with other services on 9300.

  1. A kibana docker container that has its web services on port 5601. It communicates with the host 'elasticsearch', which should be defined by the DNS setup on localhost.

  1. A logstash docker container that forwards its traffic to 'elasticsearch', which should be defined by the DNS setup on localhost.

  1. A logstash-forwarder container that forwards logs to 'logstash' on port 6767. Again, the DNS for 'logstash' should be setup correctly.

## Debugging FAQ

  1. Logstash and logstash-forwarder cannot make an SSL handshake, this will crash logstash-forwarder.
    * You can remake the certs `deploy/make_certs.sh`, restart the containers, and setup the DNS service again, `deploy/set_hosts.sh`

  1. Kibana does not load
    * restart the container, this is because it timed out while trying to access elasticsearch

  1. You made an incorrect logstash config.
    * Check that you config passes the config test, by: `docker run -t logstash --configtest`

  1. Unknown problem:
    * Look inside the container if its running and check the relevant log files `docker exec -i -t logstash /bin/bash`
    * Run the container interactively: `docker run -i ...`, look inside `deploy/run.sh` for the relevant kwargs.

# AWS Deployment

## Elastickibana

Currently, elasticsearch and kibana (**elasticsearch**) will sit inside the same EC2 instance.

The elasticsearch instances are managed by an Auto Scale Group, adselk_elasticsearch_asg, and is configured by adselk_elasticsearch.

*TBD: a load balancer is required for elasticsearch, that ensures we know the IP of the instance. However, at a later stage we should implement service discovery.*

## Logstash

Logstash will sit on its own EC2 instance. It is foreseeable that Logstash will have the brunt of the processing, and is planned to sit behind a load balancer. It will be managed by an Auto Scale Group, adselk_logstash_adsg, and is configured by adselk_logstash.

## Caveats to the deployment

Given that logstash needs to correctly communicate with elasticsearch, the following will be done: a config file for logstash will sit on S3 storage, which will be grabbed by each new instance that is spun up by the ASG. The user will manually have to put the load balancer IP inside the config file.

# OpenSSL

## Current implementation of openSSL signatures (MUST  be changed when/if Logstash is opened to the internet)

As written on the logstash-forwarder repository:

`openssl req -x509 -subj '/CN=*' -batch -nodes -newkey rsa:2048 -keyout lumberjack.key -out lumberjack.crt -subj /CN=logstash.example.com`

with the addition of '/CN=*'. These are self-signed and insecure, and only intended to be used inside a private network.

# Elasticsearch

## Debugging

There are three web interfaces that can be used to debug issues within elasticsearch, and can be accessed at the following:

  * http://localhost:9200/_plugin/kopf
  * http://localhost:9200/_plugin/head
