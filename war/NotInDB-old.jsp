<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
%>

<form action="/sendEmail" method="post">

		<h3>Sorry, there is an error in your request. Please fill the form below to report your error: </h3><br>
		<h4>First Name:</h4>
		<div>
			<input name="first" rows="1" cols="60"></input>
		</div>
		<h4>Last Name:</h4>
		<div>
			<input name="last" rows="1" cols="60"></input>
		</div>
		<h4>Email:</h4>
		<div>
			<input name="email" rows="1" cols="60"></input>
		</div>
		<h4>Describe the problem:<h4>
		<div>
			<input name="description" rows="5" cols="60"></input>
		</div>
		
<br>
		<div>
			<button type="submit" class="btn btn-primary" name="postButton">Send email</button>
		</div>
</form>
<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>
</html>