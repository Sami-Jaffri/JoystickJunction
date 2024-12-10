<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sami and Ryan's Grocery Order Processing</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            color: #f5f5f5;
        }

        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 20px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }

        p {
            text-align: center;
            font-size: 1.2em;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px auto;
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
            text-transform: uppercase;
            font-weight: bold;
            text-align: center;
        }

        td {
            background: rgba(255, 255, 255, 0.1);
            text-align: center;
        }

        tr:nth-child(even) td {
            background: rgba(255, 255, 255, 0.05);
        }

        button {
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

        button:hover {
            background-color: rgba(255, 255, 255, 0.4);
            transform: scale(1.05);
        }

        form {
            text-align: center;
        }
    </style>
</head>
<body>
    <%@ include file="background.html" %>
    <%@ include file="header.jsp" %>
    <%
        String custId = request.getParameter("customerId");
        @SuppressWarnings({"unchecked"})
        HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            out.println("<p>Database driver not found: " + e.getMessage() + "</p>");
            return;
        }

        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            con.setAutoCommit(false); // Start transaction

            // Validate customer ID
            String customerQuery = "SELECT COUNT(customerId) FROM customer WHERE customerId = ?";
            try (PreparedStatement pstmt = con.prepareStatement(customerQuery)) {
                pstmt.setString(1, custId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    out.println("<h4>ERROR: Customer does not exist.</h4>");
                    return;
                }
            }

            // Validate cart
            if (productList == null || productList.isEmpty()) {
                out.println("<h4>Shopping cart is empty.</h4>");
                return;
            }

            // Insert order summary
            String sql = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, GETDATE(), 0)";
            int orderId;
            try (PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, custId);
                pstmt.executeUpdate();
                ResultSet keys = pstmt.getGeneratedKeys();
                keys.next();
                orderId = keys.getInt(1);
            }

            double totalAmount = 0;

            // Insert order products
            String insertProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
            try (PreparedStatement pstmt = con.prepareStatement(insertProduct)) {
                for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
                    ArrayList<Object> product = entry.getValue();
                    String productId = (String) product.get(0);
                    String price = (String) product.get(2);
                    double pr = Double.parseDouble(price);
                    int qty = ((Integer) product.get(3));

                    pstmt.setInt(1, orderId);
                    pstmt.setString(2, productId);
                    pstmt.setInt(3, qty);
                    pstmt.setDouble(4, pr);
                    pstmt.executeUpdate();

                    totalAmount += pr * qty;
                }
            }

            // Update total in order summary
            String updateTotal = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
            try (PreparedStatement pstmt = con.prepareStatement(updateTotal)) {
                pstmt.setDouble(1, totalAmount);
                pstmt.setInt(2, orderId);
                pstmt.executeUpdate();
            }

            // Display order details
            String showOrder = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";
            try (PreparedStatement pstmt = con.prepareStatement(showOrder)) {
                pstmt.setInt(1, orderId);
                ResultSet resultSet = pstmt.executeQuery();

                out.println("<h1>Order Summary</h1>");
                out.println("<table>");
                out.println("<tr><th>Product ID</th><th>Quantity</th><th>Price</th><th>Total</th></tr>");

                NumberFormat currFormat = NumberFormat.getCurrencyInstance();
                double cumulativeTotal = 0.0;

                while (resultSet.next()) {
                    int productId = resultSet.getInt("productId");
                    int quantity = resultSet.getInt("quantity");
                    double price = resultSet.getDouble("price");
                    double total = quantity * price;
                    cumulativeTotal += total;

                    out.println("<tr>");
                    out.println("<td>" + productId + "</td>");
                    out.println("<td>" + quantity + "</td>");
                    out.println("<td>" + currFormat.format(price) + "</td>");
                    out.println("<td>" + currFormat.format(total) + "</td>");
                    out.println("</tr>");
                }
                out.println("<tr><td colspan='3'>Grand Total</td><td>" + currFormat.format(cumulativeTotal) + "</td></tr>");
                out.println("</table>");
            }

            // Fetch customer name
            String customerNameQuery = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
            try (PreparedStatement pstmt = con.prepareStatement(customerNameQuery)) {
                pstmt.setString(1, custId);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    String firstName = rs.getString("firstName");
                    String lastName = rs.getString("lastName");
                    out.println("<p>Thank you, " + firstName + " " + lastName + "!</p>");
                }
            }

            session.removeAttribute("productList");

            out.println("<form action='listprod.jsp' style='text-align: center; margin-top: 20px;'>"
                + "<button type='submit' style='background-color: white; color: black; padding: 10px 20px; font-size: 1.2em; border: none; border-radius: 25px; cursor: pointer; transition: all 0.3s ease;'>"
                + "Go Back to Shop</button></form>");
        
            con.commit();
        } catch (SQLException e) {
            out.println("<p>Database error: " + e.getMessage() + "</p>");
        }
    %>
</body>
</html>
