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

<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.googlecode.objectify.cmd.Query" %>

<%@ page import="attendance.entity.Professor" %>
<%@ page import="attendance.entity.Course" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>






<html>
	<head>
	
		<meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
            
            <title>Professor Dashboard - attendance.utexas.edu</title>
            
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
	    
		    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		      google.load("visualization", "1", {packages:["corechart"]});
		      google.setOnLoadCallback(drawChart);
		      function drawChart() {
		    	  var data = new google.visualization.DataTable();
		    	  data.addColumn('string', 'Date');
		    	  data.addColumn('number', 'Attendant');
		    	  for(i = 0; i < Dates.length; i++){
		    		  if(Dates[i] != "0000-00-00"){
		    		 	 data.addRow([Dates[i], StudentsPresent[i]]);
		    	  	}
		    	  }
		    	  data.sort([{column: 0, asc:true}, {column: 1}]);	  
		        var options = {
		          title: 'Attendance'
		        };

		        var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
		        chart.draw(data, options);
		      }
		    </script>
		<%
	    	UserService userService = UserServiceFactory.getUserService();
	    	User user = userService.getCurrentUser(); 
	    	Query<Professor> professors = null;
	    	if (user==null)
	    	{
	    %>
			
			<script type="text/javascript">
				window.location.href= 'SignIn';
			</script>
				
		<%
	    	} else {
					professors = ObjectifyService.ofy().load().type(Professor.class)
										.filter("email", Professor.normalize(user.getEmail()) );
	    	}
		%> 
		
		<script src="http://code.jquery.com/jquery-latest.min.js"></script>
		<script>
		var Dates = [];
		var StudentsPresent = [];
		$(document).ready(function() {
			var url=document.URL;
			var email = "<%= Professor.normalize(user.getEmail()) %>";
// 				alert(email);
 			var classParam=parseURLParams(url);
 			if(classParam == null){
//	 				alert("Nothing to report.");
 			    $.get( "/GrabData", 
 			   			{classParam: classParam, email: email}, function (data) {
 			   		// Do something with data
 			   		for (var key in data) {
 			   			if (data.hasOwnProperty(key)) {
 			   				Dates.push(key);
 			   				StudentsPresent.push(data[key]);
 			   				$(".result").append(key + ": " + data[key] + "<br/>");
 			   			}
 			   		}
 			   		drawChart();
 			   	}, "json");
 			}
 			else{
 			    $.get( "/GrabData", 
 			   			{classParam: classParam, email: email}, function (data) {
 			   		// Do something with data
 			   		for (var key in data) {
 			   			if (data.hasOwnProperty(key)) {
			   				Dates.push(key);
 			   				StudentsPresent.push(data[key]);
 			   				$(".result").append(key + ": " + data[key] + "<br/>");
 			   			}
 			   		}
 			   	drawChart();
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
			    	
// 			    var course[];
			    
			    if (query === url || query === "") {
			        return;
			    }
			
			    for (i = 0; i < pairs.length; i++) {
			        nv = pairs[i].split("=");
			        n = decodeURIComponent(nv[0]);
			        v = decodeURIComponent(nv[1]);
			        
// 			        course.push(v);
			
// 			        if (!parms.hasOwnProperty(n)) {
// 			            parms[n] = [];
// 			        }
			
// 			        parms[n].push(nv.length === 2 ? v : null);
			    }
			    return v;
			}
			</script>     
		
		
		
	</head>                      


	<body style="">
    
    <div id="wrapper">
        
        <div class="navbar-default navbar-static-side" data-role="navigation">
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
					
				  	Professor thisProfessor = null;
					
					for (Professor p : professors)
				  	{
						thisProfessor = p;
				  	}
					
				  	pageContext.setAttribute("stud_email",
				  			thisProfessor.getFirst());
					
					ArrayList<String> coursesMenu = thisProfessor.getCourses();
					
					
					for (String course : coursesMenu) 
					{
				    	Query<Course> queryCourse = ObjectifyService.ofy().load().type(Course.class)
								.filter("classUnique", course);
						for(Course thisCourseMenu : queryCourse){
							pageContext.setAttribute("course_name_menu", thisCourseMenu.getClassTitle());
							pageContext.setAttribute("course_unique_menu", thisCourseMenu.getClassUnique());
						}
					%>
						<li><a href="DashboardProfessor.jsp?class=${fn:escapeXml(course_unique_menu)}">${fn:escapeXml(course_name_menu)}</a></li>
					<% } %>
					
	  				<li><a href="/Register.jsp">Register Another Course</a></li>
					
					</ul> <!-- /.nav-second-level --></li>
			</ul>
			<!-- /#side-menu -->
		</div>
		<!-- /.sidebar-collapse -->
	</div>
	<!-- /.navbar-static-side -->    
        
        <nav class="navbar navbar-default navbar-fixed-top" data-role="navigation" style="margin-bottom: 0">
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
						    	System.out.println(user);
						%>
								<li><a href="<%= userService.createLogoutURL("/") %>"><i class="fa fa-sign-out fa-fw"></i> Sign Out</a></li>
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
                    <h1 class="page-header">Professor dashboard</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
		  	<% 
		  	
		  	Professor actualProfessor = null;

		  	for (Professor p : professors)
			  	{
			  			actualProfessor = p;
			  	}
			
		  	pageContext.setAttribute("prof_first",
					actualProfessor.getFirst());
		  	pageContext.setAttribute("prof_last",
					actualProfessor.getLast());
		  	pageContext.setAttribute("prof_email",
						actualProfessor.getEmail());
		  	%>
		  		<blockquote>Hello, ${fn:escapeXml(prof_first)} ${fn:escapeXml(prof_last)}!</blockquote>
		  		
		    	<div id="chart_div" style="width: 900px; height: 500px;"></div>
		    	

            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->
        
    </div>
    <!-- /#wrapper -->
    
    <!-- Core Scripts - Include with every page -->
    <script src="js/jquery-1.10.2.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
    
    <!-- Page-Level Plugin Scripts - Dashboard -->
    <script src="js/plugins/morris/raphael-2.1.0.min.js"></script>
    <script src="js/plugins/morris/morris.js"></script>
    
    <!-- SB Admin Scripts - Include with every page -->
    <script src="js/sb-admin.js"></script>
    
    <!-- Page-Level Demo Scripts - Dashboard - Use for reference -->
<!--     <script src="js/demo/dashboard-demo.js"></script> -->
    
    
    
    
</body></html>