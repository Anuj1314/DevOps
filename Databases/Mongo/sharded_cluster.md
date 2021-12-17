##### Mongo Shards Components
- **mongos** - A query router, it's an interface to a mongo sharding cluster. users/app  uses this as a gateway to communicate with the shards
- **config-server**: store metadata about cluster and config of shards
- **shards**: Basically a collections ReplicaSets that we can scale horizontally

<p align="center">
  <img src="https://github.com/Anuj1314/MyDevOpsJourney/tree/main/Databases/Mongo/MongoShards.png">
</p>

**mongos** can communicate with the config server to understand how the data is distributed in sharded cluster<br/>
It's recommended to have multiple mongos, and load balance them, they are lightweight and don't persist any data.

As **config-server** stores all metadata about shards.
Config-server could be the single point of failure so best practice is to deploy that as a replicaset.

#### sharding characteristics
* We can horizontally scale the cluster
* Read/Write performance would be efficient load is being distributed among multiple shards
* Depending on the cluster, we can keep adding shards
* Recommended way to deploy a shards is to deploy it as a replicaset, so there will be very less chance of whole shard going down
* If a shard goes down, it will spread the data across the available shards so still data will be accessible.
* Manually we can remove the shard. When we remove a shard, any unsharded databases in that shard are moved to a remaining shard using the movePrimary command.
* Sharding needs to be enabled on the database, post that we can shard the collections. 
* Sharded collection and non-sharded collection can coexist in a database on which sharding has enabled. 
* While enabling sharding for the database, there will be one primary shard assigned to that DB, so all the collection that are not sharded or will not be sharded, it will by default go to that primary shard.
* we can shard the collection which has some data already, but for that we have to create an index for the existing data, otherwise it will result in error.

##### Basic Queries
* create DB and create collection

```use shardDemo
db.movies.createCollection("movies")
db.movies.createCollection("movie2")
```
- enable sharding on the db and shard the collection
```
sh.enableSharding("shardDemo")
sh.shardCollection("shardDemo.movies2", {"title":"hashed"})
sh.getShardDistributionForCollection("movies1")  // verify the query
```
- creating an index for the existing collection, so we can shard the collection
```
db.movies.createIndex({"title": "hashed"})
sh.shardCollection("shardDemo.movies1", {"title":"hashed"})
```
 - Hashed indexes use a hashing function to compute the hash of the value of the index field.
 - The hashing function collapses embedded documents and computes the hash for the entire value but does not support multi-key (i.e. arrays) indexes. Specifically, creating a hashed index on a field that contains an array or attempting to insert an array into a hashed indexed field returns an error.
 
The shard key has to be an indexed field. MongoDB also supports compound shard keys on indexed compound fields.
#### Types of sharding keys
- Range based key
- Hashed Key

Starting with **MongoDB 4.4**, MongoDB supports creating compound indexes that include a single hashed field. To create a compound hashed index, specify hashed as the value of any single index key when creating the index:

```
db.collection.createIndex( { "fieldA" : 1, "fieldB" : "hashed", "fieldC" : -1 } )
```

MongoDB hashed indexes truncate floating point numbers to 64-bit integers before hashing. For example, a hashed index would store the same value for a field that held a value of 2.3, 2.2, and 2.9. To prevent collisions, do not use a hashed index for floating point numbers that cannot be reliably converted to 64-bit integers (and then back to floating point). MongoDB hashed indexes do not support floating point values larger than 2 53.

To see what the hashed value would be for a key, see convertShardKeyToHashed().

### Tasks:
create a DB: myDB

create collections: myCollectionOne, myCollection2

1. If sharding is not enabled, where data is being stored?<br>
2. Enable sharding on the DB,  shard the empty collection myCollectionOne, push 100 data and check the data
3. Shard an existing collection having 100 data , need to create index and then shard the collection - verify if data is being distributed.
4. If we have enabled sharding for the db and collection is sharded having 1000 documents, add another shard, would that shard get a data from another shards to balance the load?