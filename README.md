# mongodb_model_office
Model Office Demo for MongoDB SAs - Base platform to enable demonstrations of RDBMS Systems of Record data being offloaded to MongoDB for downstream consumption

## H2
*Currently work in progress moving toward MVP*

---

The majority of *Operational Data Layer* projects have a common pattern at their heart. One or more relational/tabular data sources (performing a System of Record role) with a form of either (near) real-time or batch copy of data changes (*Change Data Capture*) with a transform and load into a more flexible, scalable and highly available data layer which is easier to consume for downstream applications - typically digital in nature such as web/mobile applications that leverage microservices.

Current MVP development encompasses the following technologies and use cases.

1. Docker-based deployment for all required components
2. Single MySQL instance with multiple schemas (to simulate multiple sources - other instances and vendors can be added)
3. Debezium CDC (Debezium Connect) - provides CDC On MySQL
4. Kafka - Debezium Connect publishes CDC events into topics for consumption
5. Zookeeper - part of the Kafka deployment used by the Debezium tutorial (Debezium v0.7)
6. Node Consumer - bespoke node.js application to consume CDC messages in Kafka
⋅⋅* Runs in two modes - writing to a local instance of MongoDB or writing to an Atlas provision MongoDB Cluster
⋅⋅* Where Atlas is used, a Stitch Application with associated triggers and functions is used to process the CDC messages (not currently included in this project - will be released later)
7. MongoDB instance for local CDC message persistence
8. BackOffice Web Application to provide a UI for perform CRUD operations on the MySQL dataset

As part of the MVP a banking themed set of schemas have been created to simlaute cutomers records, product definitions, products held, balances and transactions.

---
