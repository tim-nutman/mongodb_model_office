var MongoClient = require('mongodb').MongoClient;
var kafka = require('kafka-node');
var assert = require('assert');
var Consumer = kafka.Consumer;
var mdbConnectionString = '';
var mongodb;
var internal_external = "EXTERNAL";

if (internal_external == "EXTERNAL") {
    //mdbConnectionString = 'mongodb+srv://demo_user:nDgKvMSBMd0WoB2q@demozone-uzy0g.mongodb.net/modp?retryWrites=true';
    mdbConnectionString = 'mongodb://mongodb';
}
else {
    mdbConnectionString = 'mongodb://mongodb';
}

MongoClient.connect(mdbConnectionString, function(err, db) {
    assert.equal(null, err);
    console.log("Connected correctly to MongoDB server.");
    console.log("We are going....." + internal_external);
    mongodb = db.db('modp');
    var client = new kafka.KafkaClient({kafkaHost:'kafka:9092'});


    var consumer = new Consumer(
        client,
        [
            { topic: 'dbserver1.inventory.customers', partition: 0 },
            { topic: 'dbserver1.inventory.addresses', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.customer_details', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.addresses', partition: 0 }
        ],
        {
            autoCommit: true
        }
    ); //consumer definition

    var insertMessage = function(db, collection, json_doc, callback) {
        db.collection(collection).insert(json_doc, function (err, result) {
            assert.equal(null, err);
            //console.log(result.toString());
            callback();
        });
    }; //insertMessage

    var upsertMessage = function(db, collection, json_doc, callback) {
    
        var customerQuery = {
            'customer_details.id' : json_doc.customer_details.id,
            cust_ts_ms : {$lt:json_doc.cust_ts_ms}
        };
    
        var newValues = {$set : json_doc };
    
        db.collection(collection).update(customerQuery, newValues, {upsert: true}, function (err, result) {
            if (err) {
                console.log(err.toString());
            }
            else {
            console.log("Upsert on: " + JSON.stringify(json_doc));
            console.log("Upserted Customer: " + json_doc.customer_details.id);
            console.log("Upserted Result " + result.toString());
            console.log("******")
            }
            callback();
        });
    }; //updateMessage
        
        
    consumer.on('message', function (message) {
        // DEBUG to console console.log("Message acquired: " + message.toString());
    
        if (internal_external == "EXTERNAL") {
            var json_doc = JSON.parse(message.value);
            insertMessage(mongodb, "debezium", json_doc, function () {
            })
        }
        else {
            var json_doc = JSON.parse(message.value);
            insertMessage(mongodb, "RawMessages", json_doc, function () {
            })

            var source_details = JSON.parse(message.value);
            if (source_details.payload.source.table == "customers") {
                var customer_doc = { customer_details : json_doc.payload.after, cust_ts_ms: json_doc.payload.ts_ms};
                upsertMessage(mongodb, "customers", customer_doc, function () {
                });
                } 
            else if (source_details.payload.source.table == "addresses") {
                // process the address message
                mongodb.collection("customers").find({'customer_details.id' : source_details.payload.after.customer_id}).toArray(function (err, result) {
                    assert.equal(null, err);
                    console.log("Location customer record for address " + result[0]._id);
                    if (result.length == 0) {
                        // customer record does not currently exist - need to add stub with address
                        customer_doc = { customer_details : {id : source_details.payload.after.customer_id }, cust_ts_ms: 0, address_details : source_details.payload.after};
                            insertMessage(mongodb, "customers", customer_doc, function () {
                        });
                    }
                    else {
                        // customer doc exists - are we overwritting the object entry with a newer one, or inserting it
                        mongodb.collection("customers").update(
                            {
                                'customer_details.id' : source_details.payload.after.customer_id,
                                'address_details._id' : { $ne : source_details.payload.after.id}
                            },{
                                $push: {
                                    address_details: {
                                        _id : source_details.payload.after.id,
                                        street : source_details.payload.after.street,
                                        city : source_details.payload.after.city,
                                        state : source_details.payload.after.state,
                                        zip : source_details.payload.after.zip,
                                        type : source_details.payload.after.type,
                                        ts_ms : source_details.payload.ts_ms
                                    }
                                }
                            },
                            function (err, result) {
                                assert.equal(null, err);
                                console.log("$Push Result " + result.toString());
                                if (JSON.parse(result).n == 0) {
                                    mongodb.collection("customers").update(
                                        {
                                            'customer_details.id' : source_details.payload.after.customer_id,
                                            address_details : { $elemMatch : {_id : source_details.payload.after.id,ts_ms : {$lt : source_details.payload.ts_ms}}}    
                                        },{
                                            $set : {
                                                'address_details.$.street' : source_details.payload.after.street,
                                                'address_details.$.city' : source_details.payload.after.city,
                                                'address_details.$.state' : source_details.payload.after.state,
                                                'address_details.$.zip' : source_details.payload.after.zip,
                                                'address_details.$.type' : source_details.payload.after.typr,
                                                'address_details.$.ts_ms' : source_details.payload.ts_ms
                                            }
                                        },
                                        function (err, result) {
                                            assert.equal(null, err);
                                            console.log("$Set Result " + result.toString());
                                        }
                                    );
                                }   
                                
                            });
                    }
                });
                // locate the customer record and insert address into address array in customer record
                // if no customer record need to create a stub record to hold the ID and the address.
                // store an array of addresses (need to understand about updating, adding objects in an array)
            }
            else {
                console.log("Unknown Message Type")
            }
        }
    
        /*insertMessage(atlas, "RawMessages", json_doc, function () {
            console.log("inserting to Atlas");
        })
        */
    
        // need to see where the message originates (debezium config, table)

    
    });

    consumer.on('error', function (err) {
        console.log('ERROR: ' + err.toString());
    });

}); //connect to MongoDB




// take message.... possible conditions:
// upsert After data into document matching on ID
// but only if ts_ms is older in the db)


        

    
 
    
    
