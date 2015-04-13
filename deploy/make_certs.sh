#!/bin/bash

openssl req -x509 -batch -subj '/CN=*' -nodes -newkey rsa:2048 -keyout lumberjack.key -out lumberjack.crt -days 1000

cp lumberjack.crt Dockerfiles/logstash/resources/logstash-forwarder.crt
cp lumberjack.crt Dockerfiles/logstash-forwarder/resources/logstash-forwarder.crt

cp lumberjack.key Dockerfiles/logstash/resources/logstash-forwarder.key
cp lumberjack.key Dockerfiles/logstash-forwarder/resources/logstash-forwarder.key
