package scnmap

class NewentryController {

  def mongoService

  def add() { 
    log.debug("add::${params}");
    def mdb = mongoService.getMongo().getDB('comnet')

    if ( params.shortcode && ( params.shortcode.trim().length() > 0 ) ) {
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
