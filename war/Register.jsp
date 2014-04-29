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
<!--  <link type="text/css" rel="stylesheet" href="main.css"> -->
 
<!--  <style type="text/css"> -->
<!-- #map_canvas {display: none} -->
<!-- </style> -->
 
	<script
    	src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false">
	</script>
    
    
    
    
			<script type="text/javascript">
			var map;
			var markers = [];
			var austin = new google.maps.LatLng(30.286142,-97.739343);
			
			window.onload=function(){
				initialize();
	 			window.onload=displayMap();
			}

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
				var UT = new google.maps.LatLng(30.28571574871247, -97.73536205291748);
			  var mapOptions = {
			    zoom: 15,
			    center: UT
			  };
			  map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
// 			  google.maps.event.addListener(map, "rightclick",function(event){showContextMenu(event.latLng);});
			google.maps.event.addListener(map, "rightclick", function(event) {
			    deleteMarkers();
				
				var lat = event.latLng.lat();
			    var lng = event.latLng.lng();
			    var myLatlng = new google.maps.LatLng(lat,lng);
			    var marker = new google.maps.Marker({
			        position: myLatlng,
			        map: map,
			        title: 'Your Position'
			    });
			    markers.push(marker);
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

			
			// Sets the map on all markers in the array.
			function setAllMap(map) {
			  for (var i = 0; i < markers.length; i++) {
			    markers[i].setMap(map);
			  }
			}

			// Removes the markers from the map, but keeps them in the array.
			function clearMarkers() {
// 			  alert("Deleting Markers.");
			  setAllMap(null);
			}

			// Shows any markers currently in the array.
			function showMarkers() {
			  setAllMap(map);
			}

			// Deletes all markers in the array by removing references to them.
			function deleteMarkers() {
			  clearMarkers();
			  markers = [];
			}
			</script>    
    

 </head>	
 <body style=""><meta charset="utf-8">
         <meta name="viewport" content="width=device-width, initial-scale=1.0">
            
             <title>Welcome - attendance.utexas.edu</title>
            
             <!-- Core CSS - Include with every page -->
             <link href="css/bootstrap.min.css" rel="stylesheet">
                 <link href="font-awesome/css/font-awesome.css" rel="stylesheet">
                    
                     <!-- Page-Level Plugin CSS - Dashboard -->
                     <link href="css/plugins/morris/morris-0.4.3.min.css" rel="stylesheet">
                         <link href="css/plugins/timeline/timeline.css" rel="stylesheet">
                            
                             <!-- SB Admin CSS - Include with every page -->
                             <link href="css/sb-admin.css" rel="stylesheet">
                            
                            
     <!-- Page-Level Plugin CSS - Buttons -->
     <link href="css/plugins/social-buttons/social-buttons.css" rel="stylesheet">
  <body>
      <div id="wrapper">
        
          <nav class="navbar navbar-default navbar-fixed-top" role="navigation" style="margin-bottom: 0">
              <div class="navbar-header">
                  <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".sidebar-collapse">
                      <span class="sr-only">Toggle navigation</span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                      <span class="icon-bar"></span>
                  </button>
                  <a class="navbar-brand" href="AttendanceXander.jsp">attendance.utexas.edu</a>
              </div>
              <!-- /.navbar-header -->
            
              <ul class="nav navbar-top-links navbar-right">
                
                
                
                
                
                
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        
  						<%
  						    UserService userService = UserServiceFactory.getUserService();
  						    User user = userService.getCurrentUser();

 						    if (user != null) {
 						%>
 								<li><a href="<%= userService.createLogoutURL("/") %>"><i class="fa fa-sign-out fa-fw"></i> Sign Out</a></li>
 						<%
 							} 
				    
 						    else {
 							%>
 								<script type="text/javascript">
 								window.location.href="/";
 								</script>
 						<%
 						    }
 						%>
                        
                        
                    </ul>
                    <!-- /.dropdown-user -->
                </li>
                <!-- /.dropdown -->
            </ul>
            <!-- /.navbar-top-links -->
            
            
            <!-- /.navbar-static-side -->
        </nav>
 
    <div id="page-wrapper">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">Welcome to attendance.utexas.edu</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>


		<script type="text/javascript">
		window.onload = initializePosition();
		</script>

		<%
		    if (user != null) {
		      pageContext.setAttribute("userEmail", user.getEmail());
		    }

			Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
												.filter("email", Student.normalize(user.getEmail()) );
			Query<Professor> queryProfessor = ObjectifyService.ofy().load().type(Professor.class)
												.filter("email", Professor.normalize(user.getEmail()) );

			if(queryStudent.count() > 0){
		%>
				<form action="/Register" method="post" onsubmit="return validateFormStudent()" name="registerForm">
						<div>
							<p>Student : Register</p>
							<p>First Name:
									<input 	id="first"	
											name="first">
							</p>

							<p>Last Name:

									<input 	id="last"
											name="last">
							</p>
							
								<input 	type="submit" 
										name="registerClass" 
										value="Submit">
						</div>	
				</form>
				
				<script>
					function validateFormStudent()
					{
						var firstName=document.forms["registerForm"]["first"].value;
						var lastName=document.forms["registerForm"]["last"].value;
						if (firstName==null || firstName=="" 
								|| lastName==null || lastName==""	)
					 	{
						  	alert("There are required fields that are not filled in.");
						  	return false;
					  	}
					}
					</script>
			
		<%	
			}
			else {
		%>	
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
	<% } // End of Professor Reg%> 
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
			
	</div>

</div>


			
			
			<script>
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

<div class="footer">
	Software Development 461L
</div>


  </body>
</html>