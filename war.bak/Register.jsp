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
		    
			Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
							.filter("email", Student.normalize(user.getEmail()) );
			
			for(Student student : queryStudent ) {
				if(student.getAttendance() == true){
					student.setLatitude((double) pageContext.getAttribute("userLatitude"));
					student.setLatitude((double) pageContext.getAttribute("userLatitude"));
				}
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
			
				    Register a Class

				    <form action="/Register" method="post" onsubmit="return validateForm()" name="registerForm">
						<div>
							<p>Professor | Register</p>
							
							<p>First Name:
									<input 	id="first"	
											name="first">
							</p>
								
							<p>Last Name:
	
									<input 	id="last"
											name="last">
							</p>
							
							<p>Course name:
	
								<%
								ObjectifyService.register(Course.class);
								ObjectifyService.register(Professor.class);
								ObjectifyService.register(Student.class);
								
								List<Course> courses = ObjectifyService.ofy().load().type(Course.class).list();
								List<Professor> professors = ObjectifyService.ofy().load().type(Professor.class).list();
								
							    if (courses.isEmpty()) {
														%>
								        <p>Courses are empty. Shouldn't ever happen. WTF!</p>
								<%
								} 
							    else {
								%>
							        <select class="form-control" 
							        		id="courseDropDown" 
							        		name="courseDropDown" 
							        		style="width: 500px">
									<%
									    for(Course course : courses) {
									        if(course.getProfessor() == null){
									    				pageContext.setAttribute("course_name", 
									            		course.getClassTitle());
									    				pageContext.setAttribute("course_unique", 
											            		course.getClassUnique());
									    				
									%>
									        	<option value="${fn:escapeXml(course_unique)}"> 
									        					${fn:escapeXml(course_name)}: ${fn:escapeXml(course_unique)}
									            		</option>
									 <%
									        }
										}
								}				
												 %>	
								    	</select>	
								</p>
								
								<p>Students:
									<%
										Professor thisProfessor = null;
										for(Professor professor : professors){
											if (professor.getEmail().equals (user.getEmail().toLowerCase()) ){
												thisProfessor = professor;
												break;
											}
										}
									List<String> students = thisProfessor.getStudents();
									
									%>
								
								<SELECT NAME="studentList" SIZE="10" MULTIPLE >
								
									<%
													for (String student : students) {
												            		pageContext.setAttribute("student_name", 
												            		student);
												 %>
												        	<option value="${fn:escapeXml(student_name)}"> 
												        					${fn:escapeXml(student_name)}
												            		</option>
												 <%
												        
												    }				
												 %>	
								</SELECT>
								</p>
								
								<p>Course Location:
								
	
									<input 	id="latitude"
											name="latitude"
											type="number"
											readonly>
											
									<input 	id="longitude"
											name="longitude"
											type="number"
											readonly>
								</p>
									
									<div 	id="map_canvas" 
											style="height:300px; 
											width:500px">
											</div>
	
							
	
								<input 	type="submit" 
										name="registerClass" 
										value="Submit">
						</div>				    
				    
				    </form>
					
					<script>
					function validateForm()
					{
						var firstName=document.forms["registerForm"]["first"].value;
						var lastName=document.forms["registerForm"]["last"].value;
						var latitude=document.forms["registerForm"]["latitude"].value;
						var longitude=document.forms["registerForm"]["longitude"].value;
						if (firstName==null || firstName=="" 
								|| lastName==null || lastName==""
								|| latitude==null || latitude==""
								|| longitude==null || longitude==""	)
					 	{
						  	alert("There are required fields that are not filled in.");
						  	return false;
					  	}
					}
					</script>
					
			</div>
			
			<input 		id="mapButton" 
						name="mapButton" 
						type="button" 
						onclick="displayMap()" 
						value = "Show Map">
			
			<input 		id="locationButton" 
						type="button" 
						onclick="initializePosition()" 
						value="Use Current Location">
						
			<form action="/SaveClassroom" method="post" name="classroomForm">
					<input 	id="classroomName"
							name="classroomName">
					
					<input 	id="classroomLat"
							name="classroomLat"
							type="number"
							readonly>
							
					<input 	id="classroomLon"
							name="classroomLon"
							type="number"
							readonly>
							
			<input		id="SubmitClassroom"
						type="submit"
						value="Submit Classroom">
			</form>
			
			<script type="text/javascript">
			var map;
			var austin = new google.maps.LatLng(30.286142,-97.739343);
			
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
			    zoom: 10,
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
			      document.getElementById('classroomLat').value = position.coords.latitude;
			      document.getElementById('classroomLon').value = position.coords.longitude;
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

			

				
				</script>	
				
<!-- Context Menu Stuff (Deprecated)				 -->
				<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
				<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.2.min.js"></script>
				
				<script type="text/javascript">
/*				
				function getCanvasXY(caurrentLatLng){
				      var scale = Math.pow(2, map.getZoom());
				     var nw = new google.maps.LatLng(
				         map.getBounds().getNorthEast().lat(),
				         map.getBounds().getSouthWest().lng()
				     );
				     var worldCoordinateNW = map.getProjection().fromLatLngToPoint(nw);
				     var worldCoordinate = map.getProjection().fromLatLngToPoint(caurrentLatLng);
				     var caurrentLatLngOffset = new google.maps.Point(
				         Math.floor((worldCoordinate.x - worldCoordinateNW.x) * scale),
				         Math.floor((worldCoordinate.y - worldCoordinateNW.y) * scale)
				     );
				     return caurrentLatLngOffset;
				  }
				  function setMenuXY(caurrentLatLng){
				    var mapWidth = $('#map_canvas').width();
				    var mapHeight = $('#map_canvas').height();
				    var menuWidth = $('.contextmenu').width();
				    var menuHeight = $('.contextmenu').height();
				    var clickedPosition = getCanvasXY(caurrentLatLng);
				    var x = clickedPosition.x ;
				    var y = clickedPosition.y ;

				     if((mapWidth - x ) < menuWidth)
				         x = x - menuWidth;
				    if((mapHeight - y ) < menuHeight)
				        y = y - menuHeight;

				    $('.contextmenu').css('left',x  );
				    $('.contextmenu').css('top',y );
				    };
				  function showContextMenu(caurrentLatLng  ) {
				        var projection;
				        var contextmenuDir;
				        projection = map.getProjection() ;
				        $('.contextmenu').remove();
				            contextmenuDir = document.createElement("div");
				          contextmenuDir.className  = 'contextmenu';
				          contextmenuDir.innerHTML = "<a id='menu1' href='javascript:void(0);' onclick='fillLocation(\''+caurrentLatLng+'\')'><div class=context>Use This Location<\/div><\/a>";
				        $(map.getDiv()).append(contextmenuDir);
				        
				        setMenuXY(caurrentLatLng);

				        contextmenuDir.style.visibility = "visible";
				       }
				
				function fillLocation(caurrentLatLng){
					alert("clicked");
// 				      document.getElementById('latitude').value = caurrentLatLng.lat();
// 				      document.getElementById('longitude').value = caurrentLatLng.lng();
				      $('.contextmenu').remove();
				}
				  
				$(document).ready(function(){
					initialize();
				});
*/				
				</script>
<!-- Context Menu Stuff (Deprecated)				 -->			
	
		</div>
			
			
	</div>
</div>

<div class="footer">
	Software Development 461L
</div>


  </body>
</html>
