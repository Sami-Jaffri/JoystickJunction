<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            color: #f5f5f5;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 2.5em;
            color: #f5f5f5;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        table {
            width: 70%;
            margin: 0 auto;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            overflow: hidden;
            backdrop-filter: blur(8px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
        }

        th, td {
            padding: 15px;
            text-align: left;
            color: #f5f5f5;
        }

        th {
            background: rgba(255, 255, 255, 0.2);
            font-weight: bold;
            text-align: center;
            text-transform: uppercase;
        }

        td {
            background: rgba(255, 255, 255, 0.1);
        }

        tr:nth-child(even) td {
            background: rgba(255, 255, 255, 0.05);
        }

        tr:hover td {
            background: rgba(255, 255, 255, 0.2);
        }

        .message {
            color: #e57373;
            text-align: center;
            font-size: 1.2em;
        }

        .back-btn {
            display: block;
            width: 150px;
            margin: 30px auto;
            padding: 10px;
            text-align: center;
            background-color: rgba(255, 255, 255, 0.2);
            color: #f5f5f5;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1em;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .back-btn:hover {
            background-color: rgba(255, 255, 255, 0.4);
            transform: scale(1.05);
        }

        input[type="text"], input[type="email"] {
            width: 90%;
            padding: 10px;
            font-size: 1em;
            color: #f5f5f5;
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 5px;
            box-shadow: inset 0 1px 4px rgba(0, 0, 0, 0.3);
            transition: background 0.3s, box-shadow 0.3s;
        }

    input[type="text"]:focus, input[type="email"]:focus {
            background: rgba(255, 255, 255, 0.2);
            box-shadow: 0 0 8px rgba(255, 255, 255, 0.5), inset 0 1px 6px rgba(0, 0, 0, 0.4);
            outline: none;
        }

    .action-btn {
    display: inline-block;
    width: auto;
    padding: 10px 20px;
    text-align: center;
    background-color: rgba(255, 255, 255, 0.2);
    color: #f5f5f5;
    text-decoration: none;
    border-radius: 5px;
    font-size: 1em;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
    transition: background-color 0.3s ease, transform 0.2s ease;
    border: none;
    cursor: pointer;
    }

    .action-btn:hover {
    background-color: rgba(255, 255, 255, 0.4);
    transform: scale(1.05);
    }

    </style>
</head>
<body>
    <%@ include file="auth.jsp"%>
    <%@ page import="java.text.NumberFormat" %>
    <%@ include file="jdbc.jsp" %>
    <%@ include file="header.jsp" %>
    <%@ include file="background.html" %>

    <%
        String userNamee = (String) session.getAttribute("authenticatedUser");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid FROM customer WHERE userid = ?";

        try {
            con = DriverManager.getConnection(url, uid, pw);
            ps = con.prepareStatement(sql);
            ps.setString(1, userNamee);
            rs = ps.executeQuery();

            if (rs.next()) {
    %>

    <h2>Customer Information</h2>
    <form method="post" action="updateCustomer.jsp">
        <table>
            <tr><th>Customer ID</th><td><input type="text" name="customerId" value="<%= rs.getInt("customerId") %>" readonly></td></tr>
            <tr><th>First Name</th><td><input type="text" name="firstName" value="<%= rs.getString("firstName") %>"></td></tr>
            <tr><th>Last Name</th><td><input type="text" name="lastName" value="<%= rs.getString("lastName") %>"></td></tr>
            <tr><th>Email</th><td><input type="email" name="email" value="<%= rs.getString("email") %>"></td></tr>
            <tr><th>Phone Number</th><td><input type="text" name="phonenum" value="<%= rs.getString("phonenum") %>"></td></tr>
            <tr><th>Address</th><td><input type="text" name="address" value="<%= rs.getString("address") %>"></td></tr>
            <tr><th>City</th><td><input type="text" name="city" value="<%= rs.getString("city") %>"></td></tr>
            <tr><th>State</th><td><input type="text" name="state" value="<%= rs.getString("state") %>"></td></tr>
            <tr><th>Postal Code</th><td><input type="text" name="postalCode" value="<%= rs.getString("postalCode") %>"></td></tr>
            <tr><th>Country</th><td><input type="text" name="country" value="<%= rs.getString("country") %>"></td></tr>
            <tr><th>Username</th><td><input type="text" name="userid" value="<%= rs.getString("userid") %>" readonly></td></tr>
        </table>
        <div style="text-align: center; margin-top: 20px;">
            <button type="submit" class = "action-btn">Update Information</button>
        </div>
    </form>

    <%
            } else {
                out.println("<p class='message'>Customer information not found.</p>");
            }
        } catch (Exception e) {
            out.println("<p class='message'>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("<p class='message'>Error closing connection: " + e.getMessage() + "</p>");
            }
        }
    %>

    <a href="listprod.jsp" class="back-btn">Back to Home</a>
</body>
</html>
