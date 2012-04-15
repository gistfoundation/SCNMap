package scnmap

import com.k_int.vfis.*
import com.k_int.vfis.auth.*
import net.thegistgub.scnmap.*

import grails.plugins.springsecurity.Secured

class NewentryController {

  def mongoService
  def springSecurityService

  @Secured(['ROLE_USER', 'IS_AUTHENTICATED_FULLY'])
  def add() { 
    log.debug("add::${params}");
    def mdb = mongoService.getMongo().getDB('comnet')

    // def user = VfisPerson.get(springSecurityService.principal.id)
    println("User id is ${springSecurityService.principal.id}");
    def user = Person.get(springSecurityService.principal.id)
    println("Username is ${user.username}");


    if ( params.shortcode && ( params.shortcode.trim().length() > 0 ) && user ) {
      // Ensure no duplicate shortcode
      if ( mdb.entries.findOne(shortcode:params.shortcode) ) {
      }
      else {
        log.debug("${params.shortcode} is unique.. creating");
        def new_entry = [
          _id:new org.bson.types.ObjectId(),
          shortcode:params.shortcode,
          type: params.infotype,
          title:params.title,
          desc:params.description,
          url:params.url,
          addedBy:user.username,
          contact:params.contactemail,
          loc:[ lat:Double.parseDouble(params.lat), lon:Double.parseDouble(params.lng) ]
        ]
  
        log.debug("Attempting to save new entry");
        mdb.entries.save(new_entry);
        log.debug("Created");
      }
    }

    redirect(controller:"home");
  }
}
