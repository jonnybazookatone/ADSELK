# ADS Elasticsearch/Logstash/Kibana stack for project Bumblebee

## Logging service for ADS

  ##### Table of contents

<!-- TOC depth:4 withLinks:1 updateOnSave:0 -->

- [ADS Elasticsearch/Logstash/Kibana stack for project Bumblebee](#ads-elasticsearchlogstashkibana-stack-for-project-bumblebee)
	- [Logging service for ADS](#logging-service-for-ads)
	- [Elasticsearch/Logstash/Kibana (ELK)](#elasticsearchlogstashkibana-elk)
	- [Logging system of ADS 2.0](#logging-system-of-ads-20)
	- [Specification](#specification)
	- [Overview of forwarders](#overview-of-forwarders)
	- [Overview of brokers](#overview-of-brokers)
	- [Possible stacks](#possible-stacks)
	- [Conclusions](#conclusions)
	- [Alternatives](#alternatives)
		- [CloudWatch](#cloudwatch)
		- [FluentD](#fluentd)
		- [AmazonKinesis](#amazonkinesis)

<!-- /TOC -->

## Elasticsearch/Logstash/Kibana (ELK)

An ELK stack refers to the following services being implemented for a logging system: Elasticsearch/Logstash/Kibana

  * Elasticsearch: search engine that indexes content it is given. For example, the logs it receives from logstash.

  * Logstash: this service receives and parses logs and can forward the parsed content to any other follow-up service. For example, elasticsearch.

  * Kibana: Front-end interface to elastichsearch which allows easy searching of logs.

There are several other key pieces required in an ELK setup, depending on the goals of the logging service. The following naming convention is used in the ELK stack:

  * Log shipper: This takes the logs from the log files of interest and sends them either to the log broker or log handler, or any other service the user intends (e.g. STDOUT).
  * Log broker: This caches the delivery of logs from the log shipper to the log handler. This is meant to ensure that the log handler does not get overloaded with messages. It also adds a layer of redundancy if the log handler goes offline for a certain amount of time.
  * Log handler: This parses (logstash refers to this step as 'grok'-ing) the incoming log files and outputs to other services for indexing or metrics.
  * Searcher: This indexes the content given to it.
  * Front-end: This allows users an easy way to view and search elasticsearch's index.

## Logging system of ADS 2.0

ADS 2.0 also implemented an ELK stack for its logging. However, given updates to some of the tools available, the following document looks at possible modifications that could be implemented in the replacement logging system.

ADS 2.0 had the following key pieces:

  Log shipper: Beaver
  Log broker: Redis
  Log handler: Logstash
  Searcher: Elasticsearch
  Front-end: Kibana

## Specification

The logging system needs the following requirements:
  1. Simple infrastructure to ensure little management
  1. Light-weight for deployment
  1. Reliable and robust
  1. Easy to setup new log shippers

## Overview of forwarders

  1. Logstash-forwarder

  **"Pros"**
    * Written in Go
    * Light-weight service, can run on an EC2 micro instance
    * Secure (openSSL), compressed, internal queueing system
    * Does not require Redis as it has its own internal acknowledging/requesting system
    * Removes the need for a log broker, reduces complexity

  **"Cons"**
    * Cannot turn off openSSL

  2. Beaver

  **"Pros"**
    * Written in Python
    * Light-weight service
  **"Cons"**
    * Does not have internal caching or acknowledge/request
    * Requires a log broker and increases the complexity of the system


## Overview of brokers

  1. RabbitMQ
  **"Pros"**
    * Guarantees robust delivery
    * More advanced routing requirements
  **"Cons"**
    * Heavier application, requires maintenance, and can over complicate things a lot

  1. Redis
  **"Pros"**
    * Light-weight and fast
  **"Cons"**
    * No guarantee messages are delivered

## Possible stacks

  1. ELK + Logstash-forwarder (LF)
  1. ELK + Redis + Beaver (RB)
  1. ELK + RabbitMQ + Beaver (MQB)

## Conclusions

| Rank | Simple | Light | Reliable | Easy |
| ---- | ------ | ----- | -------- | ---- |
| #1   | LF     | LF    | LF       | LF   |
| #1   | -      | RB    | MQB      | -    |
| #2   | RB     | MQB   | RB       | RB   |
| #3   | MQB    | -     | -        | MQB  |

## Alternatives

  1. AmazonCloudWatch
  1. FluentD
  1. AmazonKinesis


### CloudWatch

This service is given freely by AWS. It is also simple to setup, requiring there to be an AmazonAgent installed on the service you are running (e.g., an EC2 instance). The AmazonAgent will then forward the relevant logs to CloudWatch. You can then place free metrics on the logs you define. However, these metrics are fairly simple, allowing only simple counters to be implemented, e.g., "How many 200 responses have occurred", etc. For this reason, CloudWatch is too simple for our purposes.

### FluentD

FluentD can be used instead of logstash. However, given a few comments made in this post, it does not make a huge difference between the two. One *major* reason to pick logstash is that it was designed to parse log files rather than FluentD which was designed for easy movement of log files. I refer the reader to look at this blog post, and for now will not delve further into the details of FluentD: http://jasonwilder.com/blog/2013/11/19/fluentd-vs-logstash/

### AmazonKinesis

Amazon Kinesis is a service that allows you to send input *streams* of data, that are then forwarded to other services, e.g., S3, EC2 instances, RDBs, etc. They charge per PUT request. Currently, I do not foresee a big use case in our situation (as of yet), but it may be used in our stack at a later stage. This would be one way to ensure some sort of queuing system like RabbitMQ, that would also scale nicely, without us having to roll our own. However, it is possible we do not even reach the level of data throughput to justify using this service. https://aws.amazon.com/kinesis
