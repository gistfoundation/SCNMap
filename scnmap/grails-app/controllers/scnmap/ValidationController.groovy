package scnmap

import grails.converters.*

class ValidationController {

  def mongoService

  def index() { 
    def mdb = mongoService.getMongo().getDB('comnet')

    def result = [result:false];

    log.debug("validate ${params.field}, ${params.value}");
    if ( params.field ) {
      switch(params.field) {
        case 'shortcode':
          log.debug("shortcode");
          def ent = mdb.entries.find(shortcode:params.value)
          if ( ent )
            result.result = false
          else
            result.result = true
          break;
      }
    }

    log.debug("Result is ${result}");
    render result as JSON;
  }
}
