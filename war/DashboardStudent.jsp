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
 						<%
 							} 
				    
 						    else {
 							%>
 								<li><a href="<%= userService.createLoginURL("/SignIn") %>"><i class="fa fa-sign-in fa-fw"></i> Sign In</a></li>
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
												%><p>Course name:<%	
													
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
															        	pageContext.setAttribute("course_name", pulledCourse.getClassTitle());
															        	pageContext.setAttribute("course_unique", pulledCourse.getClassUnique());
// 															        	pageContext.setAttribute("course_lat", pulledCourse.getLatitude());
// 															        	pageContext.setAttribute("course_lon", pulledCourse.getLongitude());
																%>
																        	<option value="${fn:escapeXml(course_unique)}"> 
																        					${fn:escapeXml(course_name)}: ${fn:escapeXml(course_unique)}
																            		</option>
																 <%
															        }

													    	}  // End of the else
														}
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

									function haversine(){
										var selectedanswer=document.getElementById("courseDropDown").selectedIndex;
										var lat2 =  42.806911
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
					         	 "2014-03-30": {"absentPresent": 1},
					             "2014-03-26": {"absentPresent": 0}, 
					             "2014-03-03":{"number": 1, "absentPresent": 1, "url": "http://w3widgets.com"}, 
					             "2014-03-12": {"absentPresent": 0},
					             "2014-04-01": {"absentPresent": 1},
					             "2014-04-03": {"absentPresent": 0},
					             "2014-04-08": {"absentPresent": 1},
					             "2014-04-10": {"absentPresent": 0}

					           }
					         });
					       });
					     </script>

					</section>	










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