<!DOCTYPE html>
<html>
<head>
        <title>Sami and Ryan's Grocery Main Page</title>
		<style>
			body {
				font-family: Arial, sans-serif;
				background: rgba(0, 0, 0, 0.5) url('img/background.gif') no-repeat center center fixed;
				background-size: cover;
				background-color: #f4f4f4;
				margin: 0;
				padding: 0;
				text-align: center;
			}
	
			h2, h4, h5 {
				margin: 30px 0;
				font-size: 24px;
			}
	
			b {
    			text-decoration: none;
    			color: white;
    			background-color: transparent; 
    			padding: 10px 20px;
    			border-radius: 5px;
    			transition: background-color 0.3s;
			}
	
			a:hover {
				background-color: #5d635e;
			}
	
		</style>
</head>
<body>
<%@ include file="header.jsp" %>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

</body>
</head>


