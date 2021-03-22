# mongodb_model_office
Model Office Demo for MongoDB SAs - Base platform to enable demonstrations of RDBMS Systems of Record data being offloaded to MongoDB for downstream consumption

## Current Status
*Currently work in progress moving toward MVP*

The majority of *Operational Data Layer* projects have a common pattern at their heart. One or more relational/tabular data sources (performing a System of Record role) with a form of either (near) real-time or batch copy of data changes (*Change Data Capture*) with a transform and load into a more flexible, scalable and highly available data layer which is easier to consume for downstream applications - typically digital in nature such as web/mobile applications that leverage microservices.

Current MVP development encompasses the following technologies and use cases.

1. Docker-based deployment for all required components
2. Single MySQL instance with multiple schemas (to simulate multiple sources - other instances and vendors can be added)
3. Debezium CDC (Debezium Connect) - provides CDC On MySQL
4. Kafka - Debezium Connect publishes CDC events into topics for consumption
5. Zookeeper - part of the Kafka deployment used by the Debezium tutorial (Debezium v0.7)
6. Node Consumer - bespoke node.js application to consume CDC messages in Kafka
  * Runs in two modes - writing to a local instance of MongoDB or writing to an Atlas provision MongoDB Cluster
  * Where Atlas is used, a Stitch Application with associated triggers and functions is used to process the CDC messages (not currently included in this project - will be released later)
7. MongoDB instance for local CDC message persistence
8. BackOffice Web Application (Tomcat running Java Web App) to provide a UI for perform CRUD operations on the MySQL dataset

As part of the MVP a banking themed set of schemas have been created to simlaute cutomers records, product definitions, products held, balances and transactions.

## Current Set-Up

### Pre-Requisites

Docker - everything runs in containers (with the exception of using Atlas provisioned MongoDB)
Development and "testing" performed on a MacBook Pro (15-inch, 2017) running macOS High Seirra 10.13.5 woth Docker for Mac Version 18.06.0-ce-mac70 (26399) Stable with docker-compose

For development purposes if working on the node.js consumer then node.js needs to be installed.

Set the DEBEZIUM_VERSION environment variable.
For Debezium Version 1.4, on a Mac this would be:

```
export DEBEZIUM_VERSION=1.4
```

To start the environment first navigate to the docker directory in the project:

```
cd mongodb_model_office/docker
```

Then run the following `docker-compose` command:

```
docker-compose -f docker-compose-modp.yml up
```

Monitor the output which currently goes to the terminal and you will see each of the container start.
Once complete then navigate to the `debezium` directory:

```
cd ../debezium
```

Then run the following command to set up an instance of Debzium Connect to monitor the MySQL instance:

```
curl -i -X POST -H "Accept:application/json" -H  "Content-Type:application/json" http://localhost:8083/connectors/ -d @register-mysql.json
```

===


