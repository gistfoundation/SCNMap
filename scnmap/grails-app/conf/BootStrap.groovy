class BootStrap {

  def mongoService

  def init = { servletContext ->
    def mdb = mongoService.getMongo().getDB('comnet')

    // def gistlab = [ id:'GistLab', lat:1, lon:2, name:'testPointOne' ]

    // if ( mdb.entries.find(id:'one') != null ) 
    //   mdb.entries.save(p1)
  }

  def destroy = {
  }
}
