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
int i=0;

// Skip header
r.readNext()

while ((nl = r.readNext()) != null) {
  println("Processing [${i++}]");
  //  Organiser,Detail,Building,Road/ Street,City,County,Postcode,Activity type (keywords),Activity,Contact tel,Contact email,Website,Open to public/ Call in advance,Lat/ Lang converter cell 1,Lat/ Lang converter cell 2 ,Latitude,Longitude,LatLng,Picture
  // 1. Only process entries with an organiser, Detail, lat/long
  def org = nl[0]
  def dets = nl[1]
  def lat = nl[15]
  def lon = nl[16]
  def loc = nl[17]
  def pic = nl[18]

  if ( ( lat && ( lat.trim().length() > 0 ) ) &&
       ( lon && ( lon.trim().length() > 0 ) ) &&
       ( org && ( org.trim().length() > 0 ) ) ) {
    def new_shortcode = org.replaceAll(" ","_");

    if ( db.entries.findOne([shortcode:new_shortcode]) ) {
      println("Existing entry for ${new_shortcode}");
    }
    else {
      println("Create new entry for ${new_shortcode}");
      def new_entry = [
        _id:new org.bson.types.ObjectId(),
        shortcode:new_shortcode,
        type: 'type',
        title:org,
        desc: dets,
        url: nl[11],
        addedBy:'IMPORT',
        contact: nl[10],
        loc:[ lat:Double.parseDouble(lat), lon:Double.parseDouble(lon) ],
        provenance:[
            description:"Digital Inclusion Locations South Yorkshire",
            url:"http://www.google.com/fusiontables/DataSource?snapid=S250316U_WU",
            license:"UNKNOWN"
        ],
        address:[
            building:nl[2],
            street:nl[3],
            city:nl[5],
            county:nl[5],
            postcode:nl[6]
        ]
      ]
      println("Adding new entry: ${new_entry}");
    }

  }
  else {
    println("Skipping resource : [${i}] ${org} - missing details");
  }

}
