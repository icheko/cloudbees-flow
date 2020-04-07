#!/bin/bash

echo
echo Starting up DB
echo ----------------------------------------
docker-compose up -d mariadb
docker-compose logs -f mariadb &
sleep 60

echo
echo Starting up Server and Web
echo ----------------------------------------
docker-compose up -d flow-server flow-web
docker-compose logs -f flow-server flow-web &
sleep 900

echo
echo Starting up Repository
echo ----------------------------------------
docker-compose up -d flow-repository
docker-compose logs -f flow-repository &
sleep 300

echo
echo Starting up DevopsInsight
echo ----------------------------------------
docker-compose up -d flow-devopsinsight
docker-compose logs -f flow-devopsinsight &
sleep 300

echo
echo Shutting down
echo ----------------------------------------
docker-compose down

echo
echo Cloubees Flow has been initialized. Use \"docker-compose up\" to start up.
echo