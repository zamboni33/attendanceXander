
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="attendance.entity.Professor" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link type="text/css" rel="stylesheet" href="main.css">

</head>
<body>

	<form action="/Init" method="post">

		<h4>Email:</h4>
		<div>
			<input name="email" rows="1" cols="60" value="c.julien@mail.utexas.edu" readonly></input>
		</div>

<br>
		<div>
			<button type="submit" class="btn btn-primary" name="initButton">Create professor account</button>
		</div>
	</form>
	
	
</body>
</html>
