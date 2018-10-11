var MongoClient = require('mongodb').MongoClient;
const mongodbhelper = require('mongodb');
var kafka = require('kafka-node');
var assert = require('assert');
const math = require('mathjs');
var Consumer = kafka.Consumer;
var mdbConnectionString = '';
//var mongodb;
//var internal_external = "INTERNAL";
var internal_external = "EXTERNAL";

if (internal_external == "EXTERNAL") {
    mdbConnectionString = 'mongodb+srv://demo_user:nDgKvMSBMd0WoB2q@demozone-uzy0g.mongodb.net/modp?retryWrites=true';
    //mdbConnectionString = 'mongodb://mongodb';
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
            { topic: 'dbserver1.bullwork_core_accs.customer_details', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.addresses', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.branches', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.products_held', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.product_catalog', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.prod_sub_type', partition: 0 },
            { topic: 'dbserver1.bullwork_core_accs.prod_type', partition: 0 },
            { topic: 'dbserver1.bullwork_trx.transactions', partition: 0 }
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
            'customer_details.cust_id' : json_doc.customer_details.cust_id,
            'customer_details.cdc_update_ts_ms' : {$lt:json_doc.customer_details.cdc_update_ts_ms}
        };
    
        var newValues = {$set : json_doc };
    
        db.collection(collection).update(customerQuery, newValues, {upsert: true}, function (err, result) {
            if (err) {
                console.log("**** Upsert Customer Record Failed - likely duplicate key - err msg to follow ****");
                console.log(err.toString());
            }
            else {
                console.log("**** Upsert Customer Record Success")
                //console.log("Upsert on: " + JSON.stringify(json_doc));
                console.log("   Upserted Customer: " + json_doc.customer_details.cust_id);
                console.log("   Upserted Result " + result.toString());
            }
            callback();
        });
    }; //updateMessage
        
        
    consumer.on('message', function (message) {

        // shape the Debezium message to ensure correct data types for MongoDB
        var json_doc = JSON.parse(message.value);
        
            if (json_doc.payload.source.table == "customer_details") {
                // need to set the data_of_birth field to an ISODate String for correct data typing
                var date = new Date(json_doc.payload.after.date_of_birth);
                json_doc.payload.after.date_of_birth = date;
            }
            if (json_doc.payload.source.table == "products_held") {
                // need to set the opened field to an ISODate String for correct data typing
                var date = new Date(json_doc.payload.after.opened);
                json_doc.payload.after.opened = date;
                json_doc.payload.after.available_balance = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.available_balance,2).toString());
                json_doc.payload.after.total_balance = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.total_balance,2).toString());
                json_doc.payload.after.acc_limit = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.acc_limit,2).toString());
    
            }
            if (json_doc.payload.source.table == "transactions") {
                // need to set the trx_date_rec and trx_date_pro fields to an ISODate String for correct data typing
                var date1 = new Date(json_doc.payload.after.trx_date_rec);
                var date2 = new Date(json_doc.payload.after.trx_date_pro);
                json_doc.payload.after.trx_date_rec = date1;
                json_doc.payload.after.trx_date_pro = date2;
                // need to set the trx_value to a Decimal128 value
                json_doc.payload.after.trx_value = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.trx_value,2).toString());
            }
            if (json_doc.payload.source.table == "product_catalog") {
                // need to ensure Decimal types are being used correctly
                // data comes from Debezium in as FLOAT - need to take the first 2 decimal points
                // and then specify as a decimal
                json_doc.payload.after.cr_int_rate = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.cr_int_rate,2).toString());
                json_doc.payload.after.db_int_rate = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.db_int_rate,2).toString());
                json_doc.payload.after.fee = mongodbhelper.Decimal128.fromString(math.round(json_doc.payload.after.fee,2).toString());
            }
            
            // insert the Debezium Message into MongoDB
            mongodb.collection("debezium").insert(json_doc);
            console.log("**** Debezium Msg inserted into MongoDB: DB: " + json_doc.payload.source.db + " : Table: " + json_doc.payload.source.table + " : Operation: " + json_doc.payload.op, " ****");
            
            //insertMessage(mongodb, "debezium", json_doc, function () {
            //})
    
            // what mode are we running in? External processing (e.g. Stitch) or use built-in (below)


        
    
        if (internal_external == "EXTERNAL") {
            // do nothing 
        }
        else {
            // message in correct format in json_doc

            if (json_doc.payload.source.table == "customer_details") {
                console.log("**** Process Msg: Customer Details ****")
                var customer_doc = { customer_details : json_doc.payload.after};
                customer_doc.customer_details.cdc_update_ts_ms = json_doc.payload.ts_ms;
                upsertMessage(mongodb, "customers", customer_doc, function () {
                });
                } 
            else if (json_doc.payload.source.table == "addresses") {
                console.log("**** Process Msg: Address Details ****")
                // process the address message
                mongodb.collection("customers").find({'customer_details.cust_id' : json_doc.payload.after.cust_id}).toArray(function (err, result) {
                    assert.equal(null, err);
                    
                    if (result.length == 0) {
                        console.log("Address linked to customer record not present in MongoDB - creating stub record");
                        // customer record does not currently exist - need to add stub with address
                        customer_doc = { customer_details : {cust_id : json_doc.payload.after.cust_id, cdc_update_ts_ms: 0 }, address_details : [json_doc.payload.after]};
                        mongodb.collection("customers").insert(customer_doc);
                    }
                    else {
                        // customer doc exists - are we overwritting the object entry with a newer one, or inserting it
                        console.log("Address linked to a customer record present in MongoDB - performing update/insert");
                        mongodb.collection("customers").update(
                            {
                                'customer_details.cust_id' : json_doc.payload.after.cust_id,
                                'address_details.address_id' : { $ne : json_doc.payload.after.address_id}
                            },{
                                $push: {
                                    address_details: {
                                            address_id : json_doc.payload.after.address_id,
                                            addressline_1 : json_doc.payload.after.addressline_1,
                                            addressline_2 : json_doc.payload.after.addressline_2,
                                            city : json_doc.payload.after.city,
                                            state : json_doc.payload.after.state,
                                            postcode : json_doc.payload.after.postcode,
                                            address_type : json_doc.payload.after.address_type,
                                            cdc_update_ts_ms : json_doc.payload.ts_ms
                                    }
                                }
                            },
                            function (err, result) {
                                assert.equal(null, err);
                                console.log("$Push Result " + result.toString());
                                if (JSON.parse(result).n == 0) {
                                    mongodb.collection("customers").update(
                                        {
                                            'customer_details.cust_id' : json_doc.payload.after.cust_id,
                                            address_details : { $elemMatch : {address_id : json_doc.payload.after.address_id, cdc_update_ts_ms : {$lt : json_doc.payload.ts_ms}}}    
                                        },{
                                            $set : {
                                                'address_details.$.addressline_1' : json_doc.payload.after.addressline_1,
                                                'address_details.$.addressline_2' : json_doc.payload.after.addressline_2,
                                                'address_details.$.city' : json_doc.payload.after.city,
                                                'address_details.$.state' : json_doc.payload.after.state,
                                                'address_details.$.postcode' : json_doc.payload.after.postcode,
                                                'address_details.$.address_type' : json_doc.payload.after.address_type,
                                                'address_details.$.cdc_update_ts_ms' : json_doc.payload.ts_ms
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
            else if (json_doc.payload.source.table == "branches") {

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


        

    
 
    
    
