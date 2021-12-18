### Cassandra Database
#### Characteristics:
- It's a semiSQL Database
- Cassandra DB is based on Query First Approach and not on relational model approach <br/>
  Meaning, A single table should reflect the queries we are tyring to make. OR desing a data model in a way so query needs data to be fetched from single table <br/>

#### Requirements: 
- java 8
- data,log,cache directory should be owned by cassandra user

#### Limitations of Cassandra
- It's not possible to perform join query because it will result in very poor performance as tables would be distributed across the nodes
- We can only search by primary key in the table, otherwise we have to specify 'ALLOW FILTERING' at the end of query, that will result in poor performance.
- It is possible to search with other key, for that we have to create a SECONDARY index for that column, but it's not recommended as it will result  in poor performance, create secondary index only if there is no other way out.

#### Some Fundamentals
- Gossip is a peer-to-peer communication protocol in which nodes periodically exchange state information about themselves and about other nodes they know about
- A seed node is used to bootstrap the gossip process for new nodes joining a cluster. To learn the topology of the ring, a joining node contacts one of the nodes in the seeds list in cassandra. yaml
- key_space in Cassandra is similar to DB in MySql on MongoDB.
- Every key_space can have replication factor
#### Cassandra Utilities  
- nodetool - A command line interface for managing a cluster
- cassandra utility
- cassandra - stress tool- The cassandra-stress tool is a Java-based stress testing utility for basic benchmarking and load testing a Cassandra cluster
- SSTable utilities - SSTables are the immutable data files that Cassandra uses for persisting data on disk.

#### Ports for Communication
```
7199 - JMX
7000 - Inter-node communication (not used if TLS enabled) 
9042 - CQL native transport port  
```
[Reference for production setup readiness](https://docs.datastax.com/en/dse-planning/doc/)

#### Rack and Data-center -- update all info
1. Rack is a cluster of connected machines
2. we can assign a new node to particular dc and to a particular rack

#### Partitions, Rings(Cluster), Tokens
1. Partition key is passed along with the data, based on hash of that partition key, cassandra will decide on which node a particular row of data will be saved.
2. Internally, Partition key will be passed to the hash function, which will return a unique id for each partition key.
3. Partition key does not need to be unique.
4. Every single data with the same partition key will be stored on the same node in the cluster.
5. Partition key is passed to the hash function, that will return 64-bit integer (ranging from -2^63 to 2^63 ) unique id, will be known as tokens.
6. On cassandra node, we can have multiple virtual nodes. Default 256 virtual nodes would be there on a single physical instance of Cassandra and that is configurable.
7. Each node will be having a token range (from -2^63 to 2^63)
8. For better optimization, cassandra doesn't give one big range to a node but give multiple small ranges to the node(small range per virtual node)

#### Data Replication Topologies
1. Simple Strategy (mostly used with single dc and single rack)
	- every keyspace(db), we can design a replication factor
	- it will check the token for the data/row, and the replica of that data would be present at very next nodes of that node.

2. Network Topology strategy: little complicated(can allow us to set replication for each data centre)
	- within a Data center, it allocates replicas to different racks in order to maximize the availability

#### Some Basics
- Every raw has a primary key which should be specified for data access
- Primary key is also known as a composite key which is made up of partition key which decides on which node our data will be stored and number of clustering columns 
- Clustering columns are used for sorting th data and the order on which data is stored on the disk
- key_space in cassandra is similar to the db in mysql, each keyspace can have tables and table can have data/raws.
- we can define replication for each key_space. Default durability is set as true and is configurable.

#### TIMESTAMP, TTL, SECONDARY index 
* we can have time-stamp for the column which shows, at what time the column has been updated. 
* we can set TTL for a data, column, row etc. I assume it will allow to set the TTL for a table too.
* we can input the **collection of data** as a value in the cassandra table
* we cannot query the data in cassandra by the key which is not the primary key. Though we can make a query by adding 'ALLOW FILTERING' keyword at the end, but it's not recommended as it will result in poor performance
* There is a way we can use this query without ALLOW FILTERING, that is secondary index. It will have a similar effect in performance and so is not recommended.
* We should use it if we have designed the data model incorrectly and there is no alternative.

#### Queries
 - DESCRIBE KEYSPACES;
 - USE test_keyspace;
 - DROP KEYSPACE test_keyspace;
 - CREATE KEYSPACE test_keyspace WITH replication = {'class':'SimpleStrategy', 'replication_factor':'1'} AND durable_writes = 'true';
 - CREATE TABLE employee_by_id (id int PRIMARY KEY, name text, position text);
 - DESCRIBE TABLES;
 - DESCRIBE TABLE employee_by_id;
 - DROP TABLE employee_by_id;
 - CREATE INDEX ON employee_by_id(name); # this will create a secondary index

**PENDING-TOPICS**: SNITCH/GOSSIP-PROTOCOL/WRITEPATH/READPATH/
###### QUESTION
1. HOW NODE/CLUSTER DISCOVERY HAPPENS IN CASSANDRA?<br/>
Cassandra works with peer to peer architecture, with each node connected to all other nodes. Each Cassandra node performs all database operations and can serve client requests without the need for a master node. ... Nodes in a cluster communicate with each other for various purposes.
