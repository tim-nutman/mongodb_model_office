var MongoClient = require('mongodb').MongoClient;
var kafka = require('kafka-node');
var assert = require('assert');

var mdbConnectionString = 'mongodb://localhost';

Consumer = kafka.Consumer;
kafka_client = new kafka.Client();
var offset = new kafka.Offset(kafka_client);
offset.fetch([{ topic: 'dbserver1.inventory.customers', partition: 0, time: -1 }], function (err, data) {
    var latestOffset = data['dbserver1.inventory.customers']['0'][0];
    console.log("Consumer current offset: " + latestOffset);
});
consumer = new Consumer(
    kafka_client,
    [
        { topic: 'dbserver1.inventory.customers', partition: 0, fromOffset: true }
    ],
    {
        autoCommit: false
    }
);

MongoClient.connect(mdbConnectionString, consumer, function (err, client) {
    'use strict'
    assert.equal(null, err);
    var db = client.db('modp');



    
     consumer.on('message', function (message) 
     {
         console.log(message);
         db.collection('customers').insert(JSON.parse(message.value));
    
     });
    
     consumer.on('error', function (err) 
    {
        console.log('ERROR: ' + err.toString());
    });

})

