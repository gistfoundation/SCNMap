<%@ page import="org.codehaus.groovy.grails.web.servlet.GrailsApplicationAttributes" %><!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title><g:layoutTitle default="${meta(name: 'app.name')}"/></title>
    <meta name="description" content="">
    <meta name="author" content="">

    <meta name="viewport" content="initial-scale = 1.0">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <r:require modules="scaffolding, popover, application"/>

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="72x72" href="${resource(dir: 'images', file: 'apple-touch-icon-72x72.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-114x114.png')}">
    <link rel="stylesheet" href="${resource(dir:'css',file:'twitter-auth.css')}" />

    <g:layoutHead/>
    <r:layoutResources/>
  </head>

  <body>

    <nav class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          
          <a class="brand" href="${createLink(uri: '/')}">GIST Cultural and Digital Activity Map</a>

          <div class="nav-collapse">
            <ul class="nav">              
              <li<%= request.forwardURI == "${createLink(uri: '/')}" ? ' class="active"' : '' %>><a href="${createLink(uri: '/')}">Home</a></li>

              <sec:ifLoggedIn> 
                <sec:ifAllGranted roles="ROLE_USER">
                  <!--
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Actions <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                      <li><g:link controller="Home" action="index">My Dashboard</g:link></li>
                    </ul>
                  </li>
                  <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">Your Organisations<b class="caret"></b></a>
                    <ul class="dropdown-menu">
                      <li><g:link controller="Home" action="memberships">Request and Manage Memberships</g:link></li>
                    </ul>
                  </li>
                  -->
                </sec:ifAllGranted>
              </sec:ifLoggedIn> 
            </ul>

            <ul class="nav pull-right">
              <sec:ifLoggedIn> 
                <li><p class="navbar-text">Logged in as ${user?.username}</p></li>
                <li><g:link controller="logout">logout</g:link></li>
              </sec:ifLoggedIn> 
              <sec:ifNotLoggedIn> 
                <li>
                  <twitterAuth:button/>
                </li>
              </sec:ifNotLoggedIn> 
            </ul>
          </div>

        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <g:layoutBody/>

      <hr>

      <footer>
        <p>&copy; <a href=http://thegisthub.net"">The GIST Foundation</a> 2012</p>
      </footer>
    </div>

    <r:layoutResources/>

  </body>
</html>
