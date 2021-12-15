Cassandra equirements: <br/> 
* java 8
* data,log,cache directory should be owned by cassandra user
#### cassandra utilities #### 
		
* nodetool- A command line interface for managing a cluster
* cassandra utility
* cassandra-stress tool- The cassandra-stress tool is a Java-based stress testing utility for basic benchmarking and load testing a Cassandra cluster
* SSTable utilities- SSTables are the immutable data files that Cassandra uses for persisting data on disk.
	
##### ports for communication ##### 
`7199 - JMX
7000 - Internode communication (not used if TLS enabled)
9042 - CQL native transport port`


Reference for production deployment: https://docs.datastax.com/en/dse-planning/doc/

Cassandra DB is based on Query First Approach and not on relational model appoach.
Meaning, A single table should reflect the queries we are tyring to make. OR desing a data model in a way so query needs data to be fetched from single table.
Limitations of Cassandra: 
	Its not possible to perform join query becasue it will result in very poor performance as tables would be distributed across the nodes
	We can only search by primary key in the table, otherwise we have to sepcify 'ALLOW FILTERING' at the end of query, that will result in poor performance.
	It is possible to search with other key, for that we have to create a SECONDARY index for that column, but its not recommendec as it will result  in poor performace, create secondary index only if there is no other way out.

Gossip is a peer-to-peer communication protocol in which nodes periodically exchange state information about themselves and about other nodes they know about

A seed node is used to bootstrap the gossip process for new nodes joining a cluster. To learn the topology of the ring, a joining node contacts one of the nodes in the seeds list in cassandra. yaml

#Rack and Datacentre -- update
Rack is a cluster of connected machines

we can assign a new node to particular dc and to a particular rack

keyspace  =  database
every keyspace will have a replication factor(will be among nodes)


#partitions, rings(cluster), tokens
Partitions, Rings and Tokens:
	Every raw should have its partition key, a key that will decide on which node the raw should be allocated.
	Partition key will be passed to the hash function, which will return a unique id for each partition key.
	every single data with the same partition key will be stored on  the same node in the cluster
	partition key does not need to be unique
####
    partition key will be passed to hash function(which will return a uniq ID - will be known as tokens(64 bit integers (-2^63 to 2^63)) in cassandra)

    each node will be assigned a token, stores the data having token value less than that token

each node will be having token range (from -2^63 to 2^63)


for better optimization, cassandra doesnt give one big range to a node but give multiple small ranges to the node(virtual node - each range)

we can manually assign no of virtual nodes to a particular node, this is configurable inside cassandra
default every node has 256 virtual nodes

# for data replication, there are two topologies
Simple Strategy(mostly used with single dc and single rack):
	every keyspace(db), we can design a replication factor
	it will check the token for the data/raw, the replica of that data would be present at very next nodes of that node.

Network Topology strategy: little complicated(can allow us to set replication for each data centre)
	within a DC, it allocates replicas to different racks in order to maximize the availability


## every raw has a primary key which should be speicified for data access
## orimary key is also known as a composite key which is made up of partition key which decides on which node our data will be stored and number of clustering columns  
## clustering columns are used for sorting th data and the order on whihch data is stord on the disk

# TIMESTAMP, TTL, SECONDARY index 
we can have timestamp for the column which can show at what time the column has been updated
we can set TTL for for a data, column, row etc in Cassandra, i assume it will allow to set the ttl for a table too.
we can input the collection of data as a value in the cassandra table


we cannot query the data in cassandra by the key which is not the primary key
htough we can make wuery by adding 'ALLOW FILTERING' keyorkd at the end but its not recommended as it will result in poor performance


There is a way we can use this query without ALLOW FILTERING, that is secondary index. But it will have a similar effect and is not recommended, but it is useful if we designed data model incorrectly and need to specify using something that is not part of primary key

#QUERIES
key_space in cassandra is similar to the db in mysql, each keyspace can have tables and table can have data/raws.
EXAMPLE QUERIES:

DESCRIBE KEYSPACES;
USE test_keyspace;
DROP KEYSPACE test_keyspace;

#we can define replication for each key_space, by default durability comes as true.
CREATE KEYSPACE test_keyspace WITH replication = {'class':'SimpleStrategy', 'replication_factor':'1'} AND durable_writes = 'true';

CREATE TABLE employee_by_id (id int PRIMARY KEY, name text, position text);

DESCRIBE TABLES;

DESCRIBE TABLE employee_by_id;

DROP TABLE employee_by_id;

CRATEA INDEX ON employee_by_id(name); this will create a secondary index

#
PENDING: SNITCH/GOSSPI PROTOCOL / WRITEPATH / READPATH/ 

QUESTION:
1) HOW NODE/CLUSTER DISCOVERY HAPPENS IN CASSANDRA?

