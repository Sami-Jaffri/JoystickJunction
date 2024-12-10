<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<%
String reviewComment = request.getParameter("reviewComment");
String reviewRating = request.getParameter("reviewRating");
String productId = request.getParameter("productId");
String username = (String) session.getAttribute("authenticatedUser");

if (username == null) {
    response.sendRedirect("login.jsp");
    return;
}

try (Connection connection = DriverManager.getConnection(url, uid, pw)) {
    // Get customerId of logged-in user
    String customerQuery = "SELECT customerId FROM customer WHERE userid = ?";
    int customerId = -1;
    try (PreparedStatement customerStmt = connection.prepareStatement(customerQuery)) {
        customerStmt.setString(1, username);
        ResultSet rs = customerStmt.executeQuery();
        if (rs.next()) {
            customerId = rs.getInt("customerId");
        }
    }

    if (customerId == -1) {
        out.println("<p>Error: Customer ID not found for user: " + username + "</p>");
        return;
    }

    // Check if the user has already submitted a review for the product
    String checkReviewQuery = "SELECT COUNT(*) FROM review WHERE customerId = ? AND productId = ?";
    boolean reviewExists = false;
    try (PreparedStatement checkStmt = connection.prepareStatement(checkReviewQuery)) {
        checkStmt.setInt(1, customerId);
        checkStmt.setInt(2, Integer.parseInt(productId));
        ResultSet rs = checkStmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            reviewExists = true;
        }
    }

    if (reviewExists) {
        out.println("<p>You have already submitted a review for this product.</p>");
        return;
    }

    // Insert review
    String insertQuery = "INSERT INTO review (reviewRating, reviewDate, customerId, productId, reviewComment) "
                       + "VALUES (?, GETDATE(), ?, ?, ?)";
    try (PreparedStatement insertStmt = connection.prepareStatement(insertQuery)) {
        insertStmt.setInt(1, Integer.parseInt(reviewRating));
        insertStmt.setInt(2, customerId);
        insertStmt.setInt(3, Integer.parseInt(productId));
        insertStmt.setString(4, reviewComment);
        insertStmt.executeUpdate();
    }

    response.sendRedirect("product.jsp?id=" + productId + "&message=Review added successfully!");
} catch (SQLException e) {
    out.println("<p>Error submitting review: " + e.getMessage() + "</p>");
}
%>
