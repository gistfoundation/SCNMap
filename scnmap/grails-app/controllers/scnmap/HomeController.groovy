package scnmap

import grails.converters.*
import com.k_int.vfis.*
import com.k_int.vfis.auth.*
import net.thegistgub.scnmap.*

import grails.plugins.springsecurity.Secured


class HomeController {

  def mongoService
  def springSecurityService


  def index() {
    log.debug("Index... p=${springSecurityService.principal}");
    def result = [:]
    if ( springSecurityService.principal instanceof String ) {
    }
    else {
      result.user = Person.get(springSecurityService.principal.id)
    }
    result;
  }


  // https://developers.google.com/maps/articles/toomanymarkers#viewportmarkermanagement

  def poi() {
    def result = []
    try {
      def mdb = mongoService.getMongo().getDB('comnet')
      // log.debug("Get poi...${params}");

      def entries = null;
      if ( params.lat1 && params.lat2 && params.lng1 && params.lng2 ) {
        def box = [[Double.parseDouble(params.lat1), Double.parseDouble(params.lng1)], [Double.parseDouble(params.lat2),  Double.parseDouble(params.lng2)]]
        entries = mdb.entries.find(["loc" : ['$within' : ['$box' : box]]])
      }
      else {
        entries = mdb.entries.findAll();
      }

      entries.each { e ->
        // log.debug("adding ${e}");
        result.add(e);
      }
    }
    catch ( Exception e ) {
      log.error("Problem with spatial query, params: ${params}",e);
    }

    if ( params.callback )
      render "${params.callback}(${result as JSON})"
    else 
      render result as JSON
  }
}
