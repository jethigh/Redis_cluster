#!/bin/bash

INIT='redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1'
CONTAINER=$(docker ps|grep redis1|awk '{print $1}')

echo -e "\nInitialazing cluster\n"
docker exec -it $CONTAINER $INIT
