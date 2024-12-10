<%@ page import="java.util.HashMap" %> 
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            color: white;
        }
        h1, h2 {
            text-align: center;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
        }
        th {
            text-align: center;
        }
        input[type="number"] {
            width: 60px;
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            text-align: center;
            font-size: 1em;
            background-color: #fff;
            transition: all 0.3s ease;
        }
        input[type="number"]:focus {
            outline: none;
            border-color: #1f1c2c;
            background-color: #f0f0f0;
        }
        .button {
            display: inline-block;
            padding: 8px 15px;
            font-size: 1em;
            border-radius: 20px;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
        }
        .remove-btn {
            background-color: #e53935;
            color: white;
            border: none;
            cursor: pointer;
        }
        .remove-btn:hover {
            background-color: #b71c1c;
        }
        .update-btn {
            background-color: #1f1c2c;
            color: white;
            border: none;
            cursor: pointer;
        }
        .update-btn:hover {
            background-color: #444;
        }
        .continue-shopping {
            background-color: white;
            color: black;
            display: inline-block;
            padding: 10px 20px;
            font-size: 1.2em;
            border-radius: 25px;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
        }
        .continue-shopping:hover {
            background-color: #0056b3;
        }
        .error-message {
            background-color: #ffcccc;
            color: #990000;
            padding: 10px;
            margin: 20px 0;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        .success-message {
            background-color: #ccffcc;
            color: #006600;
            padding: 10px;
            margin: 20px 0;
            border-radius: 5px;
            text-align: center;
            font-weight: bold;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <%@ include file="background.html" %>
    <%@ include file="header.jsp" %>
<%
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    String removeId = request.getParameter("removeId");
    if (removeId != null) {
        productList.remove(removeId);
        session.setAttribute("productList", productList);
        out.println("<div class='success-message'>Item removed successfully!</div>");
    }

    String updateId = request.getParameter("updateId");
    String newQuantityStr = request.getParameter("newQuantity");
    if (updateId != null && newQuantityStr != null) {
        try {
            int newQuantity = Integer.parseInt(newQuantityStr);
            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    String checkInventoryQuery = "SELECT quantity FROM productinventory WHERE productId = ?";
                    PreparedStatement checkInventoryStmt = con.prepareStatement(checkInventoryQuery);
                    checkInventoryStmt.setString(1, updateId);
                    ResultSet rs = checkInventoryStmt.executeQuery();
                    
                    if (rs.next()) {
                        int availableQty = rs.getInt("quantity");
                        if (availableQty >= newQuantity) {
                            ArrayList<Object> product = productList.get(updateId);
                            if (product != null) {
                                product.set(3, newQuantity);
                                session.setAttribute("productList", productList);
                                out.println("<div class='success-message'>Quantity updated successfully!</div>");
                            }
                        } else {
                            out.println("<div class='error-message'>Requested quantity exceeds available stock. Only " + availableQty + " available.</div>");
                        }
                    } else {
                        out.println("<div class='error-message'>Product not found in inventory.</div>");
                    }
                }
            } catch (SQLException e) {
                out.println("<div class='error-message'>Error: " + e.getMessage() + "</div>");
            }
        } catch (NumberFormatException e) {
            out.println("<div class='error-message'>Invalid quantity entered.</div>");
        }
    }

    if (productList == null || productList.isEmpty()) {
        out.println("<h1>Your shopping cart is empty!</h1>");
    } else {
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        out.println("<h1>Your Shopping Cart</h1>");
        out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
        out.println("<th>Price</th><th>Subtotal</th><th>Action</th><th>Update Quantity</th></tr>");

        double total = 0;
        for (Map.Entry<String, ArrayList<Object>> entry : productList.entrySet()) {
            ArrayList<Object> product = entry.getValue();
            String productId = (String) product.get(0);
            String productName = (String) product.get(1);
            double price = Double.parseDouble(product.get(2).toString());
            int quantity = Integer.parseInt(product.get(3).toString());
            
            out.print("<tr><td>" + productId + "</td>");
            out.print("<td>" + productName + "</td>");
            out.print("<td align=\"center\">" + quantity + "</td>");
            out.print("<td align=\"right\">" + currFormat.format(price) + "</td>");
            out.print("<td align=\"right\">" + currFormat.format(price * quantity) + "</td>");
            out.print("<td><form method=\"GET\" action=\"showcart.jsp\">");
            out.print("<input type=\"hidden\" name=\"removeId\" value=\"" + productId + "\" />");
            out.print("<input type=\"submit\" value=\"Remove\" class=\"button remove-btn\" /></form></td>");
            out.print("<td><form method=\"GET\" action=\"showcart.jsp\">");
            out.print("<input type=\"hidden\" name=\"updateId\" value=\"" + productId + "\" />");
            out.print("<input type=\"number\" name=\"newQuantity\" value=\"" + quantity + "\" min=\"1\" />");
            out.print("<input type=\"submit\" value=\"Update\" class=\"button update-btn\" /></form></td></tr>");
            total += price * quantity;
        }
        out.println("<tr><td colspan=\"5\" align=\"right\"><b>Order Total</b></td>"
                + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
        out.println("</table>");
    }
%>
<div style="text-align: center; margin-top: 20px;">
    <a href="listprod.jsp" class="continue-shopping">Continue Shopping</a>
    <% if (productList != null && !productList.isEmpty()) { %>
        <a href="checkout.jsp" class="continue-shopping">Checkout</a>
    <% } %>
</div>
</body>
</html>
