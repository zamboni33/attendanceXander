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
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ page import="attendance.entity.Course" %>

<%@ page import="com.googlecode.objectify.Objectify" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>





<html><head>

<%
ObjectifyService.register(Course.class);
%>

<meta charset="utf-8">

<%		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser(); %>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
            
            <title>Report a bug - attendance.utexas.edu</title>
            
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


<body style="">

    
    <div id="wrapper">
        
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
				    
						    else {
							%>
								<li><a href="<%= userService.createLoginURL(request.getRequestURI()) %>"><i class="fa fa-sign-in fa-fw"></i> Sign In</a></li>
								<li><a href="Init.jsp"><i class="fa fa-sign-in fa-fw"></i> Stock DataStore</a></li>
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
                    <h1 class="page-header">Signup</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <form action="/createUser" method="post">

					<h3>Is this your first time logging in?</h3><br>
					<div>
					<% pageContext.setAttribute("user_email",
							(user!=null?user.getEmail():"")); %>
						<input name="email" value="${fn:escapeXml(user_email)}" readonly></input>
						<br>
						<select class="form-control" 
				        		id="courseDropDown" 
				        		name="courseDropDown" 
				        		style="width: 500px">
						<%
						List<Course> courses = ObjectifyService.ofy().load().type(Course.class).list();
						    for(Course course : courses) {
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
						%>
						</select>
						
					</div>
		
			<br>
					<div>
						<button type="submit" class="btn btn-primary" name="postButton">Register</button>
					</div>
			</form>
			
<!-- 			TODO VALIDATE THIS FORM -->
			
			
			
			<form action="/SendEmail" method="post">

					<h3>If you already have an account, please report your problem in the form below: </h3><br>
					<h4>Email:</h4>
					<div>
						<input name="email" value="${fn:escapeXml(user_email)}"></input>
					</div>
					<h4>Describe the problem:</h4>
					<div>
						<textarea name="description" rows="15" cols="100"></textarea>
					</div>
		
			<br>
					<div>
						<button type="submit" class="btn btn-primary" name="postButton">Send email</button>
					</div>
			</form>

            
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