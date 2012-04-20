package scnmap

import grails.converters.*
import com.k_int.vfis.*
import com.k_int.vfis.auth.*
import net.thegistgub.scnmap.*

import grails.plugins.springsecurity.Secured


class EntryController {

  def mongoService
  def springSecurityService

  def index() { 
    def result = [:]

    def mdb = mongoService.getMongo().getDB('comnet')
    def entry = mdb.entries.findOne(shortcode:params.id)
    if ( entry ) {
      log.debug("Got entry ${entry}");
      result.entry = entry;
    }

    result
  }
}
