# cloudbees-flow

This project will spin up an evaluation cluster of [Cloudbees Flow](https://docs.cloudbees.com/docs/cloudbees-flow/latest/)

### Docker Requirements
- Disk: 25 GB
- CPU: 6 Cores
- RAM: 8GB

For more details see: [Cloudbees Non-Prod Requirements](https://docs.cloudbees.com/docs/cloudbees-flow/latest/install-k8s/#_non_production_environment)

## Initialize

Run this script to initialize the stack

````
source initialize.sh
````

If the initialize script fails, follow the manual steps.

### Manual Steps

1. Start up DB

   `docker-compose up -d mariadb`

2. Tail logs

   Open a new terminal window and tail the logs.
   
   `docker-compose logs -f`
   
   Wait for this log line before continuing:
   
   `Version: '10.3.20-MariaDB'  socket: '/opt/bitnami/mariadb/tmp/mysql.sock'  port: 3306`

3. Start up Flow Server and Web

   `docker-compose up -d flow-server flow-web`
   
   The database migrations and plugin downloads can take 10-15 minutes to complete. Be patient.
   
   Wait for login screen to appear: http://localhost before continuing.
   
4. Start up Repository
   
   `docker-compose up -d flow-repository`
   
5. Start up DevopsInsight

   `docker-compose up -d flow-devopsinsight`
   
   flow-devopsinsight will log:

   `Successfully started Logstash API endpoint {:port=>9600}`

   And flow-server will restart. Wait for login screen.
   
6. Shutdown

   `docker-compose down`
   
   Cloubees Flow has been initialized.

## Start Up

Make sure you run the initialize step first!

````
docker-compose up
````

## Login

Username: `admin`

Password: `cloudbees`
