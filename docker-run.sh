#!/bin/bash

echo "Removing all resources"
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images -q)
docker network prune -f 
docker builder prune -a -f
echo "Creating docker network '$NETWORK'"
docker network create $NETWORK

echo "Running '$DB_NAME'"
docker run --name $DB_NAME -e MYSQL_ROOT_PASSWORD=password -v db_data:/var/lib/mysql --network $NETWORK -d $DB_REPO
echo "Running '$FLASK_NAME'"
docker run --name $FLASK_NAME -p 5000:5000 --network $NETWORK -d $FLASK_REPO

