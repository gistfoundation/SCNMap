#!/usr/bin/groovy

@Grapes([
  @Grab(group='net.sf.opencsv', module='opencsv', version='2.0'),
  @Grab(group='com.gmongo', module='gmongo', version='0.9.2')
])

import org.apache.log4j.*
import au.com.bytecode.opencsv.CSVReader

def starttime = System.currentTimeMillis();

// Setup mongo
def options = new com.mongodb.MongoOptions()
options.socketKeepAlive = true
options.autoConnectRetry = true
options.slaveOk = true
def mongo = new com.gmongo.GMongo('127.0.0.1', options);
def db = mongo.getDB('comnet')

if ( db == null ) {
  println("Failed to configure db.. abort");
  system.exit(1);
}


// To clear down the gaz: curl -XDELETE 'http://localhost:9200/gaz'
// CSVReader r = new CSVReader( new InputStreamReader(getClass().classLoader.getResourceAsStream("./IEEE_IEEEIEL_2012_2012.csv")))
println("Processing ${args[0]}");
CSVReader r = new CSVReader( new InputStreamReader(new FileInputStream(args[0])))

String[] nl

while ((nl = r.readNext()) != null) {
  println("Processing ${nl}");
}
