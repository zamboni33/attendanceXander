<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>





<html><head></head><body style=""><meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
            
            <title>Start Bootstrap - SB Admin Version 2.0 Demo</title>
            
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
                
                
                
                
                
                
                <li class="dropdown">
                    <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                        <i class="fa fa-user fa-fw"></i>  <i class="fa fa-caret-down"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-user">
                        
						<%
						    UserService userService = UserServiceFactory.getUserService();
						    User user = userService.getCurrentUser();
						    if (user != null) {
						    	System.out.println(user);
						%>
								<script type="text/javascript">
									window.location.href= 'SignIn';
								</script>
						<%
							} 
				    
						    else {
							%>
								<li><a href="SignIn.jsp"><i class="fa fa-sign-in fa-fw"></i> Sign In</a></li>
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
                    <h1 class="page-header">Welcome to attendance.utexas.edu</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            
           <a href="SignIn.jsp" class="btn btn-primary btn-lg active" role="button">Sign in</a>

            
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