<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Joystick Junction</title>
    <link href='https://fonts.googleapis.com/css?family=Lato:300,400,700' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="style.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            color: #f0f0f0;
        }
        h5 {
            text-align: center;
            font-size: 2.5em;
            color: #ffffff;
            margin-bottom: 20px;
        }
        form {
            text-align: center;
            margin-bottom: 30px;
        }
        input[type="text"], select {
            padding: 12px 15px;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
            border: 1px solid #aaa;
            font-size: 16px;
            margin: 15px;
            background-color: rgba(255, 255, 255, 0.8);
        }
        input[type="submit"], input[type="reset"] {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            margin: 8px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: #fff;
            transition: transform 0.3s ease, background 0.3s ease;
        }
        input[type="reset"] {
            background: linear-gradient(135deg, #e53935, #b71c1c);
        }
        .product-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .product-card {
            background: #2a2a2a;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 6px 10px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.3);
        }
        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .product-body {
            padding: 20px;
            text-align: center;
        }
        .product-title {
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 10px;
            color: white;
        }
        .product-price {
            font-size: 1.2em;
            color: white;
        }
        .product-buttons a {
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
        .product-buttons a:hover {
            background-color: rgba(255, 255, 255, 0.4);
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <%@ include file="background.html" %>
    <%@ include file="header.jsp" %>
    <h5>What products are you looking for today?</h5>
    <form method="get" action="listprod.jsp">
        <input type="text" name="productName" placeholder="Enter product name...">
        <select name="category">
            <option value="">All Categories</option>
            <option value="1">Action</option>
            <option value="2">Adventure</option>
            <option value="3">RPG</option>
            <option value="4">Sports</option>
            <option value="5">Strategy</option>
        </select>
        <input type="submit" value="Search">
        <input type="reset" value="Reset">
    </form>

    <div class="product-list">
        <%
            String name = request.getParameter("productName");
            String category = request.getParameter("category");
            String nameFilter = (name == null || name.trim().isEmpty()) ? "%" : "%" + name + "%";
            String categoryFilter = (category == null || category.isEmpty()) ? "%" : category;

            try {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                    String query = "SELECT productId, productName, productPrice, categoryId FROM product WHERE productName LIKE ? AND categoryId LIKE ?";
                    PreparedStatement preparedStatement = con.prepareStatement(query);
                    preparedStatement.setString(1, nameFilter);
                    preparedStatement.setString(2, categoryFilter);
                    ResultSet resultSet = preparedStatement.executeQuery();

                    while (resultSet.next()) {
                        String pname = resultSet.getString("productName");
                        int pid = resultSet.getInt("productId");
                        double pp = resultSet.getDouble("productPrice");
                        String productPrice = NumberFormat.getCurrencyInstance().format(pp);
                        String productImage = "img/" + pid + "a.jpg";
        %>
        <div class="product-card">
            <img class="product-image" src="<%=productImage%>" alt="<%=pname%>">
            <div class="product-body">
                <h5 class="product-title">
                    <a href="product.jsp?id=<%=pid%>" style="text-decoration: none; color: inherit;">
                        <%= pname %>
                    </a>
                </h5>
                <p class="product-price">Price: <%= productPrice %></p>
                <div class="product-buttons">
                    <a href="addcart.jsp?id=<%=pid%>&name=<%=URLEncoder.encode(pname, "UTF-8")%>&price=<%=pp%>" class="btn-primary">Add to Cart</a>
                </div>
            </div>
        </div>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</body>
</html>
