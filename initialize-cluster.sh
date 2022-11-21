#!/bin/bash

INIT='redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 --cluster-replicas 1'
CONTAINER=$(docker ps|grep redis1|awk '{print $1}')
CLUSTER_STATE=$(docker exec -it $CONTAINER redis-cli -p 7000 cluster info 2>/dev/null|grep cluster_state|cut -d: -f2|tr -d '\r')
OLD_FILES=$(ls -l 700*/data/nodes.conf 2>/dev/null|wc -l)

initialize () {
	echo -e "\nInitializing new cluster"
	if [ $(docker ps|grep redis1|wc -l) -gt 0 ]; then
		docker exec -it $CONTAINER $INIT
	else
		echo -e "\nWARNING !!! No containers found!\n"
		echo -e "Start Redis containers ?"
		select yn in "Yes" "No"; do
			case $yn in
				Yes)
					echo -e "\nStarting containers"
					docker compose up -d
					CONTAINER=$(docker ps|grep redis1|awk '{print $1}')
					docker exec -it $CONTAINER $INIT
					exit
					;;
				No)
					echo -e "\nStart containers using: 'docker compose up -d'"
			        exit
			        ;;
			esac
		done
	fi
}	


if [ $OLD_FILES -gt 0 ] || [ "$CLUSTER_STATE" == "ok" ]; then
	echo -e "Found previous cluster data"
	echo -e "Proceed with initialization and delete od clusted data?"
	echo -e "\nSelect number:"
	select yn in "Yes" "No"; do
        case $yn in
    		Yes)
				echo -e "\nRemoving old cluster data"
				sudo rm -rf ./700*/data/*
				if [ $(docker ps|grep redis1|wc -l) -gt 0 ]; then
					if [ $CLUSTER_STATE = "ok" ]; then
						echo -e "\nContainers with initialized cluster are running."
						echo -e "\nRestart running containers ?"
						select yn in "Yes" "No"; do
        					case $yn in
								Yes)
									echo -e "\nRestarting containers"
									docker compose restart
									break
									;;
								No)
									echo -e "\nRestart containers using: 'docker compose restart'"
									echo -e "\nAlternatively you can stop or remove them using:"
									echo -e "'docker compose stop' or 'docker compose down'"
									echo -e "and then start them again using 'docker compose up -d'\n"
									exit
									;;
							esac
						done
					fi
				fi
				initialize
				exit
				;;
    		No)
			       	echo -e "\nNot initializing\n"
					exit;;
  		esac
	done
else
	initialize
fi
