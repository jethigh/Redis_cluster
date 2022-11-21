# Description
This project uses docker and docker compose to run 6 containers with docker in cluster mode.  
Cluster is composed of 3 master nodes and 3 replicas. One for each master node.  
Since Redis cluster don't support NAT'ed environments host network is used.  
  
Subsequent servers are assigned a port starting at 7000 and ending at 7005.  
The port numbers correspond to the directories in which the data dir and the configuration for subsequent servers are located.  

Cluster is initialized using script which execute initialization command inside first Redis container.  
The initialized cluster is available on ports 7000 - 7005 of the localhost.  
  
# Requierements
This project require:  
- docker
- docker-compose-plugin
  
# Instruction
Run containers by invoking docker compose in cloned repository folder.  
`docker compose up -d`

To initialize cluster run change execution permissions of *initialize-cluster.sh* script and run it:  
`./initialize-cluster.sh`  
  
You can also use *initialize-clister.sh* script to bring container up answering provided questions.