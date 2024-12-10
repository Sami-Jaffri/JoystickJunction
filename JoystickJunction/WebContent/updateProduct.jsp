<%@ page import="java.sql.*, java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<%
    // Fetch form data
    String productId = request.getParameter("productId");
    String newPrice = request.getParameter("price");
    String newDescription = request.getParameter("productDesc");

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection con = DriverManager.getConnection(url, uid, pw);

        // Update query for product price and description
        String updateQuery = "UPDATE product SET productPrice = ?, productDesc = ? WHERE productId = ?";
        PreparedStatement ps = con.prepareStatement(updateQuery);
        ps.setBigDecimal(1, new BigDecimal(newPrice));
        ps.setString(2, newDescription);
        ps.setInt(3, Integer.parseInt(productId));

        int rowsAffected = ps.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<p>Product updated successfully.</p>");
        } else {
            out.println("<p>Error updating product. Please try again.</p>");
        }

        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="admin.jsp">Back to Admin Page</a>
