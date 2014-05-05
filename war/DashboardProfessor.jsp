<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="com.googlecode.objectify.cmd.Query" %>
<%@ page import="attendance.entity.Professor" %>
<%@ page import="attendance.entity.Course" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>





<html>
	<head>
	    
		    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
		    <script type="text/javascript">
		      google.load("visualization", "1", {packages:["corechart"]});
		      google.setOnLoadCallback(drawChart);
		      function drawChart() {
		        var data = google.visualization.arrayToDataTable([
		          ['Class', 'Attendance'],
		          ['01/03/2014',  34	],
		          ['01/06/2014',  23	],
		          ['01/08/2014',  40],
		          ['01/15/2014',  31]
		        ]);

		        var options = {
		          title: 'Attendance'
		        };

		        var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
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
	</head>
	<body style=""><meta charset="utf-8">
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
						<li><a href="DashboardStudent.jsp?class=${fn:escapeXml(course_unique_menu)}">${fn:escapeXml(course_name_menu)}</a></li>
					<% } %>
					</ul> <!-- /.nav-second-level --></li>
			</ul>
			<!-- /#side-menu -->
		</div>
		<!-- /.sidebar-collapse -->
	</div>
	<!-- /.navbar-static-side -->                    
                
                
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
                    <h1 class="page-header">Professor dashboard</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
		  	<% 
		  	
		  	Professor actualProfessor = null;
		  	if (professors==null)
			{
				%>
				
				<script type="text/javascript">
					window.location.href= 'SignIn';
				</script>
					
				<%
			} else {
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
		    	<%} %>
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
    <script src="js/demo/dashboard-demo.js"></script>
    
    
    
    
</body></html>