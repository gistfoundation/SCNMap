package scnmap

import grails.converters.*

class HomeController {

  def index() {
    log.debug("Index...");
  }


  // https://developers.google.com/maps/articles/toomanymarkers#viewportmarkermanagement

  def poi() {
    log.debug("Get poi...");
    def result = [:]
    
    if ( params.callback )
      render "${params.callback}(${result as JSON})"
    else 
      render result as JSON
  }
}
