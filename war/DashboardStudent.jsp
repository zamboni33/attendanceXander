<!-- 	This program is free software: you can redistribute it and/or modify -->
<!--     it under the terms of the GNU General Public License as published by -->
<!--     the Free Software Foundation, either version 3 of the License, or -->
<!--     (at your option) any later version. -->

<!--     This program is distributed in the hope that it will be useful, -->
<!--     but WITHOUT ANY WARRANTY; without even the implied warranty of -->
<!--     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the -->
<!--     GNU General Public License for more details. -->

<!--     You should have received a copy of the GNU General Public License -->
<!--     along with this program.  If not, see <http://www.gnu.org/licenses/>. -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
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
 
		<%
	    	UserService userService = UserServiceFactory.getUserService();
	    	User user = userService.getCurrentUser();
	    	Query<Student> students = null;
	    	if (user==null)
	    	{
	    		%>
			
			<script type="text/javascript">
				window.location.href= 'SignIn';
			</script>
				
			<%
	    	} else {
			students = ObjectifyService.ofy().load().type(Student.class)
										.filter("email", Student.normalize(user.getEmail()) );
		}
	 
		%> 
 
		<style type="text/css">
			#map_canvas {display: none}
		</style>
 
		<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>

		<!--   Calendar Additions   -->
		<link rel="stylesheet" href="css/bootstrap.css">
		<script src="js/bootstrap.min.js"></script>
		<script src="js/jquery.js"></script>
		<script src="js/responsive-calendar.js"></script>

		<!--   Calendar Additions End   -->

		<body style=""><meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
            
		<title>Student Dashboard</title>
            
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
		
		<script src="http://code.jquery.com/jquery-latest.min.js"></script>
		<script>
		$(document).ready(function() {
			var returnData = [];
			var url=document.URL;
			var email = "<%= Professor.normalize(user.getEmail()) %>";
// 				alert(email);
 			var classParam=parseURLParams(url);
 			if(classParam == null){
 			}
//	 				alert("Nothing to report.");
 			else{
 			    $.get( "/GrabData", 
 			   			{classParam: classParam, email: email}, function (data) {
 			   		// Do something with data
 			   		for (var key in data) {
 			   			if (data.hasOwnProperty(key)) {
 			   				returnData.push(key + ":" + data[key]);
 			   				alert(returnData);
 			   				$(".result").append(key + ": " + data[key] + "<br/>");
//  			   				alert($(".result").html());
//  			   				alert($(".result").val());
 			   			}
 			   		}
 			   	}, "json");
 			}
		} );
		</script>
		
		<script type="text/javascript">
			function parseURLParams(url) {
			    var queryStart = url.indexOf("?") + 1,
			        queryEnd   = url.length + 1,
			        query = url.slice(queryStart, queryEnd - 1),
			        
			        pairs = query.replace(/\+/g, " ").split("&"),
			        parms = {}, i, n, v, nv;
			    
			    if (query === url || query === "") {
			        return;
			    }
			
			    for (i = 0; i < pairs.length; i++) {
			        nv = pairs[i].split("=");
			        n = decodeURIComponent(nv[0]);
			        v = decodeURIComponent(nv[1]);
			    }
			    return v;
			}
			</script>   

	</head>                                



    
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
            
	<div class="navbar-default navbar-static-side" role="navigation">
		<div class="sidebar-collapse">
			<ul class="nav" id="side-menu">
				<li class="sidebar-search">
					<div class="input-group custom-search-form">
						<input type="text" class="form-control" placeholder="Search...">
						<span class="input-group-btn">
							<button class="btn btn-default" type="button">
								<i class="fa fa-search"></i>
							</button>
						</span>
					</div> <!-- /input-group -->
				</li>
				<li><a href="#"><i class="fa fa-bar-chart-o fa-fw"></i>
						Courses<span class="fa arrow"></span></a>
					<ul class="nav nav-second-level">
					<% 
					
					ObjectifyService.register(Course.class);
					ObjectifyService.register(Professor.class);
					ObjectifyService.register(Student.class);
					
				  	Student thisStudent = null;
					
					for (Student s : students)
				  	{
						thisStudent = s;
				  	}
					
				  	pageContext.setAttribute("stud_email",
				  			thisStudent.getFirst());
					
					ArrayList<String> coursesMenu = thisStudent.getCourses();
					
					
					for (String course : coursesMenu) 
					{
				    	Query<Course> queryCourse = ObjectifyService.ofy().load().type(Course.class)
								.filter("classUnique", course);
						for(Course thisCourseMenu : queryCourse){
							pageContext.setAttribute("course_name_menu", thisCourseMenu.getClassTitle());
							pageContext.setAttribute("course_unique_menu", thisCourseMenu.getClassUnique());
						}
					%>
						<li><a href="DashboardStudent.jsp?class=${fn:escapeXml(course_unique_menu)}">${fn:escapeXml(course_name_menu)}</a></li>
					<% } %>
					</ul> <!-- /.nav-second-level --></li>
			</ul>
			<!-- /#side-menu -->
		</div>
		<!-- /.sidebar-collapse -->
	</div>
	<!-- /.navbar-static-side -->            
            
            
            
            
            <ul class="nav navbar-top-links navbar-right">
                         
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        
						<%
 						    if (user != null) {
 						%>
 								<li><a href="<%= userService.createLogoutURL("/") %>"><i class="fa fa-sign-out fa-fw"></i> Sign Out</a></li>
 						<%	} 
 						    else {	
 						 %>
 								<li><a href="<%= userService.createLoginURL("/SignIn") %>"><i class="fa fa-sign-in fa-fw"></i> Sign In</a></li>
 						<%  }	%>
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
            <!-- /.row -->
            
		<script type="text/javascript">
		window.onload = initializePosition();
		</script>
	  	<% 
	  	Student actualStudent = null;
	  	if (students==null)
		{
			%>
			<script type="text/javascript">
				window.location.href= 'SignIn';
			</script>
				
			<%
		} else {
	  	for (Student s : students)
	  	{
	  			actualStudent = s;
	  	}
		
	  	pageContext.setAttribute("stud_email",
					actualStudent.getFirst());
	  	%>
	  		<blockquote>Hello, ${fn:escapeXml(stud_email)}!</blockquote>
	    	
	    	<%} %>
	    	
	    	

	Student Dashboard


	<input id="locationButton" 
				type="button" 
				onclick="initializePosition()" 
				value="Establish Your Location">


	    <form action="/Locate" method="post" onsubmit="return validateForm()" name="locateForm">
			<div>
			<p>
			<% 		
				Query<Student> queryStudent = ObjectifyService.ofy().load().type(Student.class)
					.filter("email", Student.normalize(user.getEmail() )); 

					for(Student student : queryStudent ) {
						if(student.getAttendance()){
							%><p>Currently ${fn:escapeXml(course_name)} is live!<%	
								
								ObjectifyService.register(Course.class);
								ObjectifyService.register(Professor.class);
								ObjectifyService.register(Student.class);
								
								ArrayList<String> courses = student.getCourses();
								for(String course : courses){    
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
								        		onclick="haversine()" 
								        		style="width: 500px">
										<%
									    	Query<Course> queryCourse = ObjectifyService.ofy().load().type(Course.class)
																		.filter("classUnique", course);
									    	
										        for(Course pulledCourse : queryCourse){
										        	ArrayList<String> times = pulledCourse.getTimes();
										        	for(String time : times){
													String[] parts = time.split(":");
// 													if(Integer.parseInt(parts[0]) == hourOfDay && Integer.parseInt(parts[1]) == minuteOfDay){
											        	pageContext.setAttribute("course_name", pulledCourse.getClassTitle());
											        	pageContext.setAttribute("course_unique", pulledCourse.getClassUnique());
											        	pageContext.setAttribute("course_lat", pulledCourse.getLatitude());
											        	pageContext.setAttribute("course_lon", pulledCourse.getLongitude());
										%>
													        	<option value="${fn:escapeXml(course_unique)}"> 
													        					${fn:escapeXml(course_name)}: ${fn:escapeXml(course_unique)}
													            		</option>
													 <%
																			}
																		}
															        }

													    	}  // End of the else
// 														}
												}
											%>	
									    	</select>				    	
					</p>
								<%
								if(student.getLatitude() != 0.0 
										&& student.getLatitude() != 0.0){
									%>${fn:escapeXml("Your location is recorded!")}	<br><%
								}
								else{
									%>${fn:escapeXml("Your location is not currently recorded.")}<br><%
								}
							}

						%>

						<script>
									Number.prototype.toRad = function() {
									   return this * Math.PI / 180;
									}

									function haversine(lat1, lon1){
										var lat2 =  document.getElementById("course_lat");
										var lon2 = document.getElementById("course_lon");
// 										var lat1 = 42.806911; 
// 										var lon1 = -71.290611; 

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
										var d = R * c * 1000; 
										return d;
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

	<section>			    
					<head>
					<link href="css/responsive-calendar.css" rel="stylesheet" media="screen">
					</head>
					<!-- 	Responsive calendar - START -->
		<div class="responsive-calendar">
		  <div class="controls">
		      <a class="pull-left" data-go="prev"><div class="btn"> Previous </div></a>
		      <h4><span data-head-year></span> <span data-head-month></span></h4>
		      <a class="pull-right" data-go="next"><div class="btn"> Next </div></a>
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

	    // Get me the current date
	    var currentTime = new Date()
	    var day = currentTime.getDate()
	    if(day < 10) { day = '0'+ day } 
	    var month = currentTime.getMonth() + 1
	    if(month < 10) {month = '0'+ month} 
	    var year = currentTime.getFullYear()
	    var calendarStart = year + '-' + month
	    var today = year + '-' + month + '-' + day

	    
	    	$(document).ready(function () {
	         $(".responsive-calendar").responsiveCalendar({
	        	 time: calendarStart,

	        	 events: {
	    		 today : {"today": 1},
	    		 
// 	    		 for (var line in returnData){
// 	    			 var parts = line.split(":");
// 	    		 }
// // 	         	 "2014-03-30": {"absentPresent": 1},
// // 	             "2014-03-26": {"absentPresent": 0}, 
// // 	             "2014-03-03":{"number": 1, "absentPresent": 1, "url": "http://w3widgets.com"}, 
// // 	             "2014-03-12": {"absentPresent": 0},
// // 	             "2014-04-01": {"absentPresent": 1},
// // 	             "2014-04-03": {"absentPresent": 0},
// // 	             "2014-04-08": {"absentPresent": 1},
// // 	             "2014-04-30": {"absentPresent": 0}

	           }
	         });
	       });
	     </script>

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
						
						var distance = haversine(latitude, longitude)
						
						if (distance > 100){
							alert("Not close enough to class.");
						}
						
						else{
							alert("Worked");
						}
						
						// TODO Check distance here and alert "Not close Enough"
						
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

			</script>


            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->
        
    </div>
    <!-- /#wrapper -->
    
    <!-- Core Scripts - Include with every page -->
    <!-- <script src="js/jquery-1.10.2.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script> -->
    
    <!-- Page-Level Plugin Scripts - Dashboard -->
    <script src="js/plugins/morris/raphael-2.1.0.min.js"></script>
    <script src="js/plugins/morris/morris.js"></script>
    
    <!-- SB Admin Scripts - Include with every page -->
    <script src="js/sb-admin.js"></script>
    
    <!-- Page-Level Demo Scripts - Dashboard - Use for reference -->
    <script src="js/demo/dashboard-demo.js"></script>
    
    
    
  </body>
</html>