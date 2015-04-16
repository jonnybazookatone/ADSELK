#!/bin/bash
# root is easier
sudo su

# Install docker and git
yum install docker git -y

# Clone the repository that contains the relevant docker files
git clone https://github.com/jonnybazookatone/ADSELK.git

# Start docker
service docker start

# Build Logstash container
pushd ADSELK/
docker build --tag adsabs/logstash-forwarder Dockerfiles/logstash-forwarder/

# Copy the recent logstash configuration file
mkdir -p /etc/logstash/conf.d/
pushd /etc/logstash/conf.d/
aws s3 cp s3://adsabs-elk-etc/logstash-forwader.conf logstash-forwarder.conf
popd

# Copy the recent cert/key for SSL to succeed
mkdir -p /etc/pki/tls/private/logstash-forwarder/
pushd /etc/pki/tls/private/logstash-forwarder/
aws s3 cp s3://adsabs-elk-etc/logstash-forwarder.key logstash-forwarder.key
popd

mkdir -p /etc/pki/tls/certs/logstash-forwarder/
pushd /etc/pki/tls/certs/logstash-forwarder/
aws s3 cp s3://adsabs-elk-etc/logstash-forwarder.crt logstash-forwarder.crt
popd

# Run the container
docker run -d --hostname logstash-forwarder --name logstash-forwarder -v /etc/logstash/conf.d/logstash-forwarder.conf:/etc/logstash/conf.d/logstash-forwarder.conf -v /tmp/logs/:/tmp/logs/ -v /etc/pki/tls/certs/logstash-forwarder/:/etc/pki/tls/certs/logstash-forwarder/ -v /etc/pki/tls/private/logstash-forwarder/:/etc/pki/tls/private/logstash-forwarder/ adsabs/logstash-forwarder
popd
