<!doctype html>
<html>
  <head>
    <meta name="layout" content="bootstrap"/>
    <title>The Cultural and Digital Activity Map</title>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCvPz19It4H7sZIsLr-e4Zv-5sYcpiWtKA&sensor=false"></script> 
    <style type="text/css">
      #map img { max-width: none; }
    </style>
  </head>

  <body>
    <div class="row-fluid">

      <section id="main" class="span9">

        <div class="well">
          <h1>Sheffield Creative / Digital Network Activity Map</h1>
          <div id="map" style="width: auto; height: 600px;"/>
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

        <g:form name="newentryform" style="display:none;" onSubmit="return postNewEntry();" method="post" controller="newentry" action="add">
          <fieldset>
            <legend>New Map Entry</legend>

            <div class="control-group">
              <label class="control-label" for="input01">
                <a href="#" rel="popover" title="Entry Short Code" data-content="A short code for this entry. This will be used to create a friendly URL for the item. Short codes should represent the item. for example, the GIST Lab has a shortcode of GISTLAB. Short codes should contain only numbers and letters, and no spaces or other punctuation">Short Code*</a>
              </label>
              <div class="controls">
                <input name="shortcode" type="text" class="input-xlarge" id="shortcode" onKeyUp="javascript:checkUnique('shortcode','shortcode');">
                <span class="help-inline"/>
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="entryTypeSelect">
                <a href="#" rel="popover" title="Entry Type" data-content="The Entry Type tells this directory what kind of information you want to list. If you are interested in being part of a project, or are about to start a project and are looking for collaborators, use an Intrest entry. For existing established centres use Existig Centre. For an existing activity, use Activity">Entry Type*</a>
              </label>
              <div class="controls">
                <select name="infotype" id="entryTypeSelect">
                  <option>Adding My Interest</option>
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
                <input name="title" type="text" class="input-xlarge" id="title">
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="url">
                <a href="#" rel="popover" title="URL" data-content="An optional URL">URL</a>
              </label>
              <div class="controls">
                <input name="url" type="text" class="input-xlarge" id="url">
              </div>
            </div>

            <div class="control-group">
              <label class="control-label" for="contactemail">
                <a href="#" rel="popover" title="Contact Email" data-content="An optional Contact Email">Contact Email</a>
              </label>
              <div class="controls">
                <input name="contactemail" type="text" class="input-xlarge" id="contactemail">
              </div>
            </div>


            <div class="control-group">
              <label class="control-label" for="description">
                <a href="#" rel="popover" title="Description" data-content="The full description for this item">Description</a>
              </label>
              <div class="controls">
                <textarea name="description" class="input-xlarge" id="description" rows="3"></textarea>
              </div>
            </div>

            <div class="form-actions">
              <!--btn disabled-->
              <button id="addSubmitButton" type="submit" class="btn disabled">Save!</button>
              <button class="btn">Cancel</button>
            </div>



          </fieldset>

          <div class="alert alert-information">After completing this basic information, more details can be added on the listing page</div>

          <input id="latelem" type="hidden" name="lat"/>
          <input id="lonelem" type="hidden" name="lng"/>

        </g:form>
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
      var valid = false;

      function map2() {
        var myLatlng = new google.maps.LatLng(53.383611,-1.466944);

        var myOptions = {
          mapTypeControl: true,
          mapTypeControlOptions: {style: google.maps.MapTypeControlStyle.DROPDOWN_MENU},
          navigationControl: true,
          center: myLatlng,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          panControl: true,
          zoomControl: true,
          scaleControl: true,
          streetViewControl: false,
          overviewMapControl: false,
          zoom: 15,
          zoomControlOptions: {
            style: google.maps.ZoomControlStyle.MEDIUM
          }
        }

        shadow_pin=createShadow();
        bright_red_pin=createPin("FE0000");

        global_map = new google.maps.Map(document.getElementById("map"), myOptions);

        google.maps.event.addDomListener(global_map, 'idle', showMarkers);
        google.maps.event.addListener(global_map, 'click', singleClick);

        $("#newentryform").hide();
        $("a[rel=popover]").popover({animation:true, placement:'left'})
      }

      var infowindow = new google.maps.InfoWindow({
          content: "empty"
      });

      function showMarkers() {
        var bounds = global_map.getBounds();
        var pl = $.ajax({
          url:"${grailsApplication.config.serverbaseurl}/home/poi"+
            "?lat1="+bounds.getNorthEast().lat()+
            "&lng1="+bounds.getNorthEast().lng()+
            "&lat2="+bounds.getSouthWest().lat()+
            "&lng2="+bounds.getSouthWest().lng(),
          dataType:"jsonp",
        }).done(
          function fetchComplete(data) {
            for ( i in data ) {
              if ( activity_entry_map[data[i]._id.inc] == null ) {
                var new_point = new google.maps.LatLng(data[i].loc.lat,data[i].loc.lon);
                var marker = new google.maps.Marker({
                  _id: data[i]._id.inc,
                  position: new_point,
                  title: data[i].title,
                  sourcedata: data[i],
                  map: global_map
                });   
  
                  // desc: data[i].desc,
                  // url: data[i].url,
                  // addedBy: data[i].addedBy,
                  // shortcode: data[i].shortcode,
                  // contact: data[i].contact,
                  // provenance: data[i].provean,
                  // address: data[i].contact,

                activity_entry_map[data[i]._id.inc] = marker;

                console.log("Adding listener for "+data[i].title+" - "+data[i].shortcode);

                google.maps.event.addListener(marker, 'click', function(event) {
                  infowindow.setContent("<h1>"+this.title+"</h1>"+
                                        "<div class=\"well\">"+
                                        this.sourcedata.desc+
                                        ( this.sourcedata.url ? '<br/>URL: <a href=\"'+this.sourcedata.url+'\">'+this.sourcedata.url+'</a>' : '' ) +
                                        ( this.sourcedata.contact ? '<br/>Contact Details: '+this.sourcedata.contact : '' ) +
                                        "<br/><a href='${grailsApplication.config.serverbaseurl}/entry/"+this.sourcedata.shortcode+"'>Entry for "+this.title+" on SCN network map</a>"+
                                        "<br/>Added By:"+this.sourcedata.addedBy+
                                        "</div>");
                  infowindow.setPosition(event.latLng);
                  infowindow.open(global_map);
                });

              }
              else {
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

      function checkUnique(fieldname, controlid) {
        var value=$('#'+controlid).val()
        var pl = $.ajax({
          url:"${grailsApplication.config.serverbaseurl}/validation/index?field="+fieldname+"&value="+value,
          dataType:"json"
        }).done (
          function fetchComplete(data) {
            if ( data.result === true ) {
              // var div = $("#"+controlid).parents("div.control-group");
              var div = $("#"+controlid).parent().parent();
              div.removeClass("error");
              div.addClass("success");
              div.find("span.help-inline").html("");
              updateFormStatus(true);
            }
            else {
              // var div = $("#"+controlid).parents("div.control-group");
              var div = $("#"+controlid).parent().parent();
              div.removeClass("success");
              div.addClass("error");
              div.find("span.help-inline").html("Your chosen shortcode is already used. Please choose a different one. Hover over the \"Short Code*\" label for help.");
              updateFormStatus(false);
            }
          }
        );

      }
 
      function updateFormStatus(isValid) {
        if ( isValid === true ) {
          if ( valid === true ) {
            // No change
          }
          else {
            // Form has become valid. Enable submit button
            $("#addSubmitButton").removeClass('disabled');
            $("#addSubmitButton").addClass('btn-primary');
            valid = true;
          }
        }
        else {
          if ( valid === true ) {
            // Form has become invalid. Disable submit button
            $("#addSubmitButton").removeClass('btn-primary');
            $("#addSubmitButton").addClass('disabled');
            valid = false;
          }
          else {
            // no change
          }
        }
      }

      function singleClick(event) {
        
        <sec:ifNotLoggedIn>
          $("#message").html("<div class='alert alert-error'><b>You must log in to add items to the map</b></div>");
        </sec:ifNotLoggedIn>

        <sec:ifLoggedIn>
          $("#message").html("<div class='alert alert-success'><b>You can refine the location of the pin for this entry on the map opposite before clicking save</b></div>");
          $("#newentryform").show();
          var location = event.latLng;
          if ( global_new_pin ) {
            // Already adding, so do nothing
          }
          else {
            global_new_pin = new google.maps.Marker({
                position: location, 
                title: "New Title",
                map: global_map,
                icon: bright_red_pin,
                draggable: true,
                map: global_map
            });
          }
        </sec:ifLoggedIn>
      }

      function postNewEntry() {
        if ( valid ) {
          $("#latelem").val(global_new_pin.position.lat());
          $("#lonelem").val(global_new_pin.position.lng());

          // Clear down the global pin so we can reuse it.
          global_new_pin = null;
        }
        return valid;
      }

      google.maps.event.addDomListener(window, 'load', map2);
      //]]>

    </script>

  </body>
</html>
