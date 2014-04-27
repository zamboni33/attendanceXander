<!DOCTYPE html>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.googlecode.objectify.cmd.Query"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="attendance.entity.Professor" %>
<%@ page import="attendance.entity.Student" %>
<%@ page import="attendance.entity.Course" %>
 
<html>
 
 <head>
 <!--   Calendar Additions   -->
<script src="js/jquery.js"></script>
<script src="js/responsive-calendar.js"></script>
<link href="css/responsive-calendar.css" rel="stylesheet" media="screen">

<!--   Calendar Additions End   -->
 
 <link type="text/css" rel="stylesheet" href="main.css">
 
 <style type="text/css">
#map_canvas {display: none}
</style>
 
<script
    src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>

 </head>	
 
  <body>
 
  	<div class="header">
		Attendance Application Take 2
	</div>
 
	<div class="main-wrap">	
	
		<div class="container">
		
		<script type="text/javascript">
		window.onload = initializePosition();
		</script>
		
		<%
		    UserService userService = UserServiceFactory.getUserService();
		    User user = userService.getCurrentUser();
		    if (user != null) {
		      pageContext.setAttribute("userEmail", user.getEmail());
		    }	
		%>
		
		   	<div class="menu">
				<p>Hello, ${fn:escapeXml(userEmail)}!</p> 
				<br>
				
				Not you?
				
				 		<input 	type="button" 
				 				onclick="SignOut();" 
				 				value="Sign Out">
				 				
						<script>
							function SignOut(){
								window.location.href=(" <%=userService.createLogoutURL("/")%> ")
							}
						</script>
			</div>
		
		
		
		
			
			<div class="content">
				
				Student Dashboard

			
				<input 		id="locationButton" 
							type="button" 
							onclick="initializePosition()" 
							value="Establish Your Location">
									

				    <form action="/Locate" method="post" onsubmit="return validateForm()" name="locateForm">
						<div>

								
								<p>
								
								<% 		Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
										.filter("email", Student.normalize(user.getEmail() )); 
										
										for(Student student : queryStudent ) {
											if(student.getLatitude() != 0.0 
													&& student.getLatitude() != 0.0){
												%>
												${fn:escapeXml("Your location is recorded!")}
												<br>
												<%
											}
											else{
												%>
												${fn:escapeXml("Your location is not currently recorded.")}
												<br>
												<%
											}
										}
	
										
									%>
									
									<script>
									Number.prototype.toRad = function() {
									   return this * Math.PI / 180;
									}
									
									function haversine(){
										var lat2 = 42.741; 
										var lon2 = -71.3161; 
										var lat1 = 42.806911; 
										var lon1 = -71.290611; 
										
										var R = 6371; // km 
										//has a problem with the .toRad() method below.
										var x1 = lat2-lat1;
										var dLat = x1.toRad();  
										var x2 = lon2-lon1;
										var dLon = x2.toRad();  
										var a = Math.sin(dLat/2) * Math.sin(dLat/2) + 
										                Math.cos(lat1.toRad()) * Math.cos(lat2.toRad()) * 
										                Math.sin(dLon/2) * Math.sin(dLon/2);  
										var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
										var d = R * c; 
									}
									</script>
									
									
									Your Location:
									
									<input 	id="latitude"
											name="latitude"
											type="number"
											readonly>
											
									<input 	id="longitude"
											name="longitude"
											type="number"
											readonly>
								</p>
	
								<input 	type="submit" 
										name="locateClass"
										value="Submit">
						</div>				    
				    
				    </form>
					
					<script>
					function validateForm()
					{
						var x = initializePosition();
						var latitude=document.forms["locateForm"]["latitude"].value;
						var longitude=document.forms["locateForm"]["longitude"].value;
						if (	latitude==null || latitude==""
								|| longitude==null || longitude==""	)
					 	{
						  	alert("There are required fields that are not filled in.");
						  	return false;
					  	}
					}
					</script>
					
			</div>	
			
			<script type="text/javascript">
			var map;
			var austin = new google.maps.LatLng(30.2500, -97.7500);
			
			function displayMap() {
				if (document.getElementById('map_canvas').style.display != "block"){
					document.getElementById('map_canvas').style.display="block";
					initialize();
					document.getElementById('mapButton').value = "Hide Map";
				} else {
					document.getElementById('map_canvas').style.display="none";
					document.getElementById('mapButton').value = "Show Map";
				}
			}
			
			function initialize() {
			  var mapOptions = {
			    zoom: 8,
			    center: new google.maps.LatLng(30.2500, -97.7500)
			  };
			  map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
// 			  google.maps.event.addListener(map, "rightclick",function(event){showContextMenu(event.latLng);});
			google.maps.event.addListener(map, "rightclick", function(event) {
			    var lat = event.latLng.lat();
			    var lng = event.latLng.lng();
			    // populate yor box/field with lat, lng
			      document.getElementById('latitude').value = lat;
			      document.getElementById('longitude').value = lng;
// 			      alert("Lat=" + lat + "; Lng=" + lng);
			});			  
// 			  alert("Map Created!");
				google.maps.event.addDomListener(window, 'load', initialize);
				google.maps.event.addDomListener(window, "resize", function() {
																	 var center = map.getCenter();
																	 google.maps.event.trigger(map, "resize");
																	 $('.contextmenu').remove(); 
																	});
			}

			

			var initialLocation;
			var austin = new google.maps.LatLng(30.2500, -97.7500);
			var browserSupportFlag =  new Boolean();
			
			function initializePosition() {
			  var myOptions = {
			    zoom: 6,
			    mapTypeId: google.maps.MapTypeId.ROADMAP
			  };
// 			  var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
			
			  // Try W3C Geolocation (Preferred)
			  if(navigator.geolocation) {
			    browserSupportFlag = true;
			    navigator.geolocation.getCurrentPosition(function(position) {
			      initialLocation = new google.maps.LatLng(position.coords.latitude,position.coords.longitude);
// 			      alert(position.coords.latitude);
			      document.getElementById('latitude').value = position.coords.latitude;
			      document.getElementById('longitude').value = position.coords.longitude;
// 			      map.setCenter(initialLocation);
			    }, function() {
			      handleNoGeolocation(browserSupportFlag);
			    });
			  }
			  // Browser doesn't support Geolocation
			  else {
			    browserSupportFlag = false;
			    handleNoGeolocation(browserSupportFlag);
			  }
			
			  function handleNoGeolocation(errorFlag) {
			    if (errorFlag == true) {
			      alert("Geolocation service failed. Placing you in Austin.");
			      initialLocation = austin;
			    } else {
			      alert("Your browser doesn't support geolocation. We've placed you in Austin.");
			      initialLocation = austin;
			    }
// 			    map.setCenter(initialLocation);
			  }
			}
			
			

			 <!-- 	Responsive calendar - START -->
					<div class="responsive-calendar">
					  <div class="controls">
					      <a class="pull-left" data-go="prev"><div class="btn"> Previous </div></a>
					      <h4><span data-head-year></span> <span data-head-month></span></h4>
					      <a class="pull-right" data-go="next"><div class="btn"> Next </i></div></a>
					  </div><hr/>
					  <div class="day-headers">
					    <div class="day header">Mon</div>
					    <div class="day header">Tue</div>
					    <div class="day header">Wed</div>
					    <div class="day header">Thu</div>
					    <div class="day header">Fri</div>
					    <div class="day header">Sat</div>
					    <div class="day header">Sun</div>
					  </div>
					  <div class="days" data-group="days">
					    the place where days will be generated
					  </div>
					</div>
			<!-- 	Responsive calendar - END -->
			<script src="../js/jquery.js"></script>
		    <script src="../js/bootstrap.min.js"></script>
		    <script src="../js/responsive-calendar.js"></script>
		    <script type="text/javascript">
		       $(document).ready(function () {
		         $(".responsive-calendar").responsiveCalendar({
		           time: '2014-03',
		           events: {"2014-03-30": {"number": 5, "url": "http://w3widgets.com/responsive-slider"},
		               "2014-03-26": {"number": 1, "url": "http://w3widgets.com"}, 
		               "2014-03-03":{"number": 1}, 
		               "2014-03-12": {}
		             
		             }
		           });
		         });
		       </script>

				
				</script>			
	
		</div>
			
			
	</div>
</div>

<div class="footer">
	Software Development 461L
</div>


  </body>
</html>
