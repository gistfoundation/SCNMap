package scnmap

import grails.converters.*

class ValidationController {

  def index() { 
    def result = [result:false];
    if ( params.field ) {
      switch(params.field) {
        case 'shortcode':
          log.debug("shortcode");
          break;
      }
    }

    render result as JSON;
  }
}
