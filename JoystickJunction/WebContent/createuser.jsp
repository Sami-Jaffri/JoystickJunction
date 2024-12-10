<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.security.*" %>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Customer</title>
    <link rel="stylesheet" href="style.css">
    <style>
        body { font-family: 'Lato', sans-serif; color: #f5f5f5; margin: 0; padding: 20px; }
        .form-container { max-width: 500px; margin: auto; padding: 20px; background: rgba(255, 255, 255, 0.1); border-radius: 10px; box-shadow: 0 6px 15px rgba(0, 0, 0, 0.3); }
        h1 { text-align: center; font-size: 2em; color: #fff; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; font-weight: bold; color: #fff; }
        .form-group input { width: 95%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; margin-top: 5px; }
        .form-group input:focus { border-color: #007bff; outline: none; box-shadow: 0 0 5px rgba(0, 123, 255, 0.5); }
        .custbtn { width: 100%; padding: 10px; border: none; background: linear-gradient(135deg, #007bff, #0056b3); color: white; font-size: 16px; border-radius: 5px; cursor: pointer; }
        .custbtn:hover { background: #0056b3; }
        .message { text-align: center; margin-top: 15px; }
        .message.success { color: #28a745; }
        .message.error { color: #e53935; }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="background.html" %>
    <div class="form-container">
        <h1>Create New Customer</h1>
        <form method="post">
            <div class="form-group">
                <label for="firstName">First Name:</label>
                <input type="text" id="firstName" name="firstName" required>
            </div>
            <div class="form-group">
                <label for="lastName">Last Name:</label>
                <input type="text" id="lastName" name="lastName" required>
            </div>
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class = "custbtn">Create Customer</button>
        </form>
        <%
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                String firstName = request.getParameter("firstName");
                String lastName = request.getParameter("lastName");
                String email = request.getParameter("email");
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    // Hash the password using SHA-256
                    MessageDigest md = MessageDigest.getInstance("SHA-256");
                    byte[] hashedPassword = md.digest(password.getBytes("UTF-8"));
                    StringBuilder sb = new StringBuilder();
                    for (byte b : hashedPassword) sb.append(String.format("%02x", b));
                    String hashedPasswordHex = sb.toString();

                    // Connect to database
                    con = DriverManager.getConnection(url, uid, pw);

                    // Check if username already exists
                    String checkSql = "SELECT COUNT(*) FROM customer WHERE userid = ?";
                    ps = con.prepareStatement(checkSql);
                    ps.setString(1, username);
                    ResultSet rs = ps.executeQuery();
                    rs.next();
                    if (rs.getInt(1) > 0) {
                        out.println("<p class='message error'>Username already exists!</p>");
                    } else {
                        // Insert new customer
                        String insertSql = "INSERT INTO customer (firstName, lastName, email, userid, password) VALUES (?, ?, ?, ?, ?)";
                        ps = con.prepareStatement(insertSql);
                        ps.setString(1, firstName);
                        ps.setString(2, lastName);
                        ps.setString(3, email);
                        ps.setString(4, username);
                        ps.setString(5, hashedPasswordHex);
                        int rows = ps.executeUpdate();
                        if (rows > 0) {
                            out.println("<p class='message success'>Customer created successfully!</p>");
                        } else {
                            out.println("<p class='message error'>Account creation failed.</p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='message error'>Error: " + e.getMessage() + "</p>");
                } finally {
                    if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
                    if (con != null) try { con.close(); } catch (SQLException ignored) {}
                }
            }
        %>
    </div>
</body>
</html>
