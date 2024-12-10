<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Joystick Junction</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            color: #f5f5f5;
        }

        h6 {
            text-align: center;
            font-size: 2.5em;
            margin: 20px 0;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        table {
            width: 100%;
            margin: 20px auto;
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
            text-transform: uppercase;
            text-align: center;
        }

        td {
            background: rgba(255, 255, 255, 0.1);
            text-align: center;
        }

        tr:nth-child(even) td {
            background: rgba(255, 255, 255, 0.05);
        }

        .order-summary {
            margin-bottom: 40px;
        }

        .product-details th, .product-details td {
            background: rgba(255, 255, 255, 0.15);
            color: #f5f5f5;
        }

        .product-details tr:nth-child(even) td {
            background: rgba(255, 255, 255, 0.08);
        }

        .footer {
            text-align: center;
            margin-top: 50px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="background.html" %>
    <h6>Order List</h6>
    <%
        String authenticatedUser = (String) session.getAttribute("authenticatedUser");

        if (authenticatedUser == null) {
            out.println("<p>You are not logged in. Please <a href='login.jsp'>login</a>.</p>");
            return;
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            out.println("<p>Database driver not found: " + e.getMessage() + "</p>");
            return;
        }

        NumberFormat currFormat = NumberFormat.getCurrencyInstance();

        Connection con = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            con = DriverManager.getConnection(url, uid, pw);

            // Query orders for the logged-in user
            String query = "SELECT orderId, orderDate, ordersummary.customerId, firstName, lastName, totalAmount " +
                           "FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId " +
                           "WHERE customer.userid = ?";
            stmt = con.prepareStatement(query);
            stmt.setString(1, authenticatedUser);
            rs = stmt.executeQuery();

            while (rs.next()) {
                out.println("<table class='order-summary'>");
                out.println("<tr>");
                out.println("<th>Order Id</th>");
                out.println("<th>Order Date</th>");
                out.println("<th>Customer Id</th>");
                out.println("<th>Customer Name</th>");
                out.println("<th>Total Amount</th>");
                out.println("</tr>");
                
                out.println("<tr>");
                out.println("<td>" + rs.getInt("orderId") + "</td>");
                out.println("<td>" + rs.getTimestamp("orderDate") + "</td>");
                out.println("<td>" + rs.getInt("customerId") + "</td>");
                out.println("<td>" + rs.getString("firstName") + " " + rs.getString("lastName") + "</td>");
                out.println("<td>" + currFormat.format(rs.getDouble("totalAmount")) + "</td>");
                out.println("</tr>");
                out.println("</table><br>");
            }
        } catch (SQLException ex) {
            out.println("<p>SQL Error: " + ex.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>
