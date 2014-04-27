<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="attendance.entity.Professor" %>
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
    
    ObjectifyService.register(Professor.class);
	List<Professor> professors = ObjectifyService.ofy().load().type(Professor.class).list();
	%> 
  </head>
  <body>
  	<div class="container">
  	<% 
  	Professor actualProfessor = null;
  	for (Professor p : professors)
  	{
  		if(p.getEmail().equals(user.getEmail()))
  		{
  			actualProfessor = p;
  			break;
  		}
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
    	<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>
  	</div>
  </body>
</html>