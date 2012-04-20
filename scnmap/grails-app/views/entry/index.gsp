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

      <section id="main" class="span12">
        <div class="well">
          <g:if test="${entry}">
            <h1>${entry.title}</h1>
            <g:if test="${entry.desc}">
              <p>${entry.desc}</p>
            </g:if>
          </g:if>
          <g:else>
            <h1>Unable to locate entry with shortcode ${params.id}</h1>
          </g:else>
        </div>
      </section>

    </div>

  </body>
</html>
