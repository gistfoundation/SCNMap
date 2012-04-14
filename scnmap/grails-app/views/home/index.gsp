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
    
        var marker = new google.maps.Marker({
          position: myLatlng, 
          title:"A title String"
        });   

        marker.setMap(global_map);  
      }

      function showMarkers() {
        var bounds = global_map.getBounds();
        alert("Show markers "+bounds);

        var pl = $.ajax({
          url:"http://localhost:8080/scnmap/home/poi?a=b&b=2",
          jsonp:"update"
        });

        if( activity_entry_map['one'] == null ) {
          alert("add");
          // activity_entry_map['one'] = 'bleh'
          var new_point =  new google.maps.LatLng(53.383,-1.466);
          activity_entry_map['one'] = new google.maps.Marker({
            position: new_point,
            title:"New doodah"
          });   
          activity_entry_map['one'].setMap(global_map);
        }
        else {
          // Already present
        }
      }

      function update() {
        alert("Update");
      }

      google.maps.event.addDomListener(window, 'load', map2);

      

      //]]>

    </script>

  </body>
</html>
