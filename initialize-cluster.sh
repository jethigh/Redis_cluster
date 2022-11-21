#!/bin/bash

INIT='redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1'
CONTAINER=$(docker ps|grep redis1|awk '{print $1}')
CLUSTER_STATE=$(docker exec -it $CONTAINER redis-cli -p 7000 cluster info 2>/dev/null|grep cluster_state|cut -d: -f2)
OLD_FILES=$(ls -l 700*/data/nodes.conf 2>/dev/null|wc -l)

initialize () {
	echo -e "\nInitializing new cluster"
	if [ $CONTAINER -gt 0
	docker exec -it $CONTAINER $INIT
}	

if [ $OLD_FILES -gt 0 ] || [ $CLUSTER_STATE -e "ok" ]; then
#if [ $OLD_FILES -gt 0 ]; then
	echo -e "Found previous cluster data"
	echo -e "Proceed with initialization and delete od clusted data?"
	echo -e "\nSelect number:"
	select yn in "Yes" "No"; do
        	case $yn in
    			Yes)
				if [ $CLUSTER_STATE -e "ok" ]; then
					echo -e "Stopping running containers"
				fi
				echo "Removing old cluster data"
				sudo rm -rf ./700*/data/*
				echo -e "\nInitializing new cluster"
				docker exec -it $CONTAINER $INIT
				exit;;
    			No)
			       	echo "Not initializing"
				exit;;
  		esac
	done
else
	initialize
fi
