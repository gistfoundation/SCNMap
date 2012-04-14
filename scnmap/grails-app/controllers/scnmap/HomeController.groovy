package scnmap

import grails.converters.*

class HomeController {

  def index() {
    log.debug("Index...");
  }


  // https://developers.google.com/maps/articles/toomanymarkers#viewportmarkermanagement

  def poi() {
    log.debug("Get poi...${params}");

    def result = [
      [
        id:'p1',
        name:'This is point 1',
        lat:53.383,
        lng:-1.466
      ],
      [
        id:'p2',
        name:'This is point 2',
        lat:53.385,
        lng:-1.468
      ]
    ]

    if ( params.callback )
      render "${params.callback}(${result as JSON})"
    else 
      render result as JSON
  }
}
