<!doctype html>
<html>
  <head>
    <meta name="layout" content="bootstrap"/>
    <title>The Cultural and Digital Activity Map</title>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script> 
  </head>

  <body>
    <div class="row-fluid">

      <section id="main" class="span9">

        <div class="well">
          <h1>Sheffield Creative / Digital Network Activity Map</h1>
          <div id="map" style="width: 100%; height: 600px">
          </div>

        </div>
          
      </section>

      <section id="nav" class="span3">
        <div class="well">

          <div id="message">
            <sec:ifNotLoggedIn>
              <div class="alert alert-information">Log in using the twitter login button above to add/edit the map</div>
            </sec:ifNotLoggedIn>
            <sec:ifLoggedIn>
              <div class="alert alert-success">Left Click on the map to add a new entry.</div>
            </sec:ifLoggedIn>
          </div>

          <div id="infopanel">
            <sec:ifNotLoggedIn>
            Click the login with twitter button above to log in to this app. After logging in, you will be able to add items to the
            map.
            </sec:ifNotLoggedIn>
          </div>

        <form id="newentryform" style="display:none;" onSubmit="postNewEntry()">
          <fieldset>
            <legend>New Map Entry</legend>

            <div class="control-group">
              <label class="control-label" for="input01">
                <a href="#" rel="popover" title="Entry Short Code" data-content="A short code for this entry. This will be used to create a friendly URL for the item. Short codes should represent the item. for example, the GIST Lab has a shortcode of GISTLAB. Short codes should contain only numbers and letters, and no spaces or other punctuation">Short Code*</a>
              </label>
              <div class="controls">
                <input type="text" class="input-xlarge" id="shortcode">
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="entryTypeSelect">
                <a href="#" rel="popover" title="Entry Type" data-content="The Entry Type tells this directory what kind of information you want to list. If you are interested in being part of a project, or are about to start a project and are looking for collaborators, use an Intrest entry. For existing established centres use Existig Centre. For an existing activity, use Activity">Entry Type*</a>
              </label>
              <div class="controls">
                <select id="entryTypeSelect">
                  <option>Interest</option>
                  <option>Existing Centre</option>
                  <option>Activity </option>
                </select>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="title">
                <a href="#" rel="popover" title="Title" data-content="A short descriptive title for this entry. This will be displayed on the Map. This can be organisation or activity names, or some other short dext that briefly explains what the entry is about">Title*</a>
              </label>
              <div class="controls">
                <input type="text" class="input-xlarge" id="title">
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="url">
                <a href="#" rel="popover" title="URL" data-content="An optional URL">URL</a>
              </label>
              <div class="controls">
                <input type="text" class="input-xlarge" id="url">
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="contactemail">
                <a href="#" rel="popover" title="Contact Email" data-content="An optional Contact Email">Contact Email</a>
              </label>
              <div class="controls">
                <input type="text" class="input-xlarge" id="contactemail">
              </div>
            </div>


            <div class="control-group">
              <label class="control-label" for="description">
                <a href="#" rel="popover" title="Description" data-content="The full description for this item">Description</a>
              </label>
              <div class="controls">
                <textarea class="input-xlarge" id="description" rows="3"></textarea>
              </div>
            </div>

            <div class="form-actions">
              <button type="submit" class="btn disabled">Save!</button>
              <button class="btn">Cancel</button>
            </div>



          </fieldset>

          <div class="alert alert-information">After completing this basic information, more details can be added on the listing page</div>

          <input type="hidden" name="newlat" value=""/>
          <input type="hidden" name="newlon" value=""/>

        </form>
        </div>

      </section>
    </div>

    <script type="text/javascript">
    //<![CDATA[

      var global_map;
      var activity_entry_map = new Array();
      var global_new_pin;
      var bright_red_pin;
      var shadow_pin;

      function map2() {
        var myLatlng = new google.maps.LatLng(53.383611,-1.466944);

        var myOptions = {
          zoom: 15,
          mapTypeControl: true,
          mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
          navigationControl: true,
          center: myLatlng,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        }

        shadow_pin=createShadow();
        bright_red_pin=createPin("FE0000");

        global_map = new google.maps.Map(document.getElementById("map"), myOptions);

        google.maps.event.addDomListener(global_map, 'idle', showMarkers);
        google.maps.event.addListener(global_map, 'click', singleClick);

        $("#newentryform").hide();
        $("a[rel=popover]").popover({animation:true, placement:'left'})
      }

      function showMarkers() {
        var bounds = global_map.getBounds();
        var pl = $.ajax({
          url:"http://localhost:8080/scnmap/home/poi"+
            "?lat1="+bounds.getNorthEast().lat()+
            "&lng1="+bounds.getNorthEast().lng()+
            "&lat2="+bounds.getSouthWest().lat()+
            "&lng2="+bounds.getSouthWest().lng(),
          dataType:"jsonp",
        }).done(
          function fetchComplete(data) {
            for ( i in data ) {
              if ( activity_entry_map[data[i].id] == null ) {
                var new_point = new google.maps.LatLng(data[i].lat,data[i].lng);
                activity_entry_map[data[i].id] = new google.maps.Marker({
                  position: new_point,
                  title: data[i].name,
                  map: global_map
                  /*
                  icon: bright_red_pin,
                  shadow: shadow_pin, */
                });   
                /* activity_entry_map[data[i].id].setMap(global_map); */
              }
            }
          }
        );
      }

      function createPin(col) {
        var pinColor = col;
        var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + col,
        new google.maps.Size(21, 34),
        new google.maps.Point(0,0),
        new google.maps.Point(10, 34));
        return pinImage;
      }

      function createShadow() {
        var pinShadow = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_shadow",
        new google.maps.Size(40, 37),
        new google.maps.Point(0, 0),
        new google.maps.Point(12, 35));
        return pinShadow;
      }
 

      function singleClick(event) {
        
        <sec:ifNotLoggedIn>
          $("#message").html("<div class='alert alert-error'><b>You must log in to add items to the map</b></div>");
        </sec:ifNotLoggedIn>

        <sec:ifLoggedIn>
          $("#message").html("<div class='alert alert-success'><b>You can refine the location of the pin for this entry on the map opposite before clicking save</b></div>");
          $("#newentryform").show();
          var location = event.latLng;
          var marker = new google.maps.Marker({
                position: location, 
                title: "New Title",
                map: global_map,
                icon: bright_red_pin,
                draggable: true,
                map: global_map
          });
          // global_map.setCenter(location);
          global_new_pin = marker;
        </sec:ifLoggedIn>
      }

      function postNewEntry() {
        alert("New entry for "+global_new_pin.position);
      }

      google.maps.event.addDomListener(window, 'load', map2);
      //]]>

    </script>

  </body>
</html>
