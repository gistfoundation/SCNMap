<!doctype html>
<html>
  <head>
    <meta name="layout" content="bootstrap"/>
    <title>Grails Twitter Bootstrap Scaffolding</title>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script> 
  </head>

  <body>
    <div class="row-fluid">

      <section id="main" class="span9">

        <div class="well">
          <h1>Sheffield Creative / Digital Network Activity Map</h1>
          <div id="map" style="width: 100%; height: 600px">
        </div>
          
      </section>

      <section id="nav" class="span3">
        <div class="well">
          Settings...
        </div>
      </section>
    </div>

    <script type="text/javascript">
    //<![CDATA[

      var global_map;
      var activity_entry_map = new Array();

      function map2() {
        var myLatlng = new google.maps.LatLng(53.383611,-1.466944);

        var myOptions = {
          zoom: 15,
          center: myLatlng,
          mapTypeId: google.maps.MapTypeId.ROADMAP
        }

        global_map = new google.maps.Map(document.getElementById("map"), myOptions);

        google.maps.event.addDomListener(global_map, 'idle', showMarkers);
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
                alert("adding");
                var new_point = new google.maps.LatLng(data[i].lat,data[i].lng);
                activity_entry_map[data[i].id] = new google.maps.Marker({
                  position: new_point,
                  title:data[i].name
                });   
                activity_entry_map[data[i].id].setMap(global_map);
              }
            }
          }
        );
      }

      google.maps.event.addDomListener(window, 'load', map2);

      

      //]]>

    </script>

  </body>
</html>
