#!/bin/bash

containers='elasticsearch logstash kibana logstash-forwarder'
echo 'Tearing containers down'
for container in $containers
do
  docker stop $container
  docker rm $container
done
