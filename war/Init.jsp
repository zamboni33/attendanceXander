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
