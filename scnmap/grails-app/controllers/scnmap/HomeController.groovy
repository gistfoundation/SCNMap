package scnmap

import grails.converters.*

class HomeController {

 def mongoService

  def index() {
    log.debug("Index...");
  }


  // https://developers.google.com/maps/articles/toomanymarkers#viewportmarkermanagement

  def poi() {
    def mdb = mongoService.getMongo().getDB('comnet')
    log.debug("Get poi...${params}");

    def entries = null;
    if ( params.lat1 && params.lat2 && params.lng1 && params.lng2 ) {
      def box = [[Double.parseDouble(params.lat1), Double.parseDouble(params.lng1)], [Double.parseDouble(params.lat2),  Double.parseDouble(params.lng2)]]
      entries = mdb.entries.find(["loc" : ['$within' : ['$box' : box]]])
    }
    else {
      entries = mdb.entries.findAll();
    }

    def result = []
    entries.each { e ->
      log.debug("adding ${e}");
      result.add(e);
    }

    //   [
    //     id:'p1',
    //     name:'This is point 1',
    //     lat:53.383,
    //     lng:-1.466
    //   ],
    //   [
    //     id:'p2',
    //     name:'This is point 2',
    //     lat:53.385,
    //     lng:-1.468
    //   ]
    // ]

    if ( params.callback )
      render "${params.callback}(${result as JSON})"
    else 
      render result as JSON
  }
}
