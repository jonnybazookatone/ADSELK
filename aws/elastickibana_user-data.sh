#!/bin/bash

# Install docker and git
yum install docker git -y

# Clone the repository that contains the relevant docker files
git clone https://github.com/jonnybazookatone/ADSELK.git

# Start docker
service docker start

# Build Elasticsearch and Kibana containers
pushd ADSELK/
docker build --tag adsabs/elasticsearch Dockerfiles/elasticsearch/
docker build --tag adsabs/kibana Dockerfiles/kibana/

# Copy the config file
mkdir -p /etc/elasticsearch/
pushd /etc/elasticsearch/
aws s3 cp s3://adsabs-elk-etc/elasticsearch.yml elasticsearch.yml
aws s3 cp s3://adsabs-elk-etc/logging.yml logging.yml
popd

# Run the containers
## First start elasticsearch
sudo docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -v /etc/elasticsearch/:/etc/elasticsearch/ adsabs/elasticsearch

## Second start kibana
## Kibana should wait for elasticsearch to be ready, otherwise it will crash
## But I do not want it to stay in an infinite loop, so after 60 seconds, there is
## clearly something wrong with elasticsearch that warrants users intervention

ELASTICSEARCH_HOST="http://localhost:9200"
time_out=60
for i in `seq "$time_out"`
do
  response=$(curl -sL -w "%{http_code}\\n" "$ELASTICSEARCH_HOST" -o /dev/null)

  if [ $response -ne 200 ]
  then
    echo "Elasticsearch service is offline ($ELASTICSEARCH_HOST), trying again..."
  else
    echo "Elasticsearch online"
    break
  fi

  if [ "$i" == "$time_out" ]
  then
    echo "Reached timeout limit of $time_out seconds. Kibana will probably not start correctly."
  fi

  sleep 1
done

docker run -d --name kibana --link elasticsearch:elasticsearch -p 5601:5601 adsabs/kibana

popd
