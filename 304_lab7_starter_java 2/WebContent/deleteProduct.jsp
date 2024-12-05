<%@ page import="java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    String productId = request.getParameter("productId");

    try {
        // Load JDBC driver and establish connection
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection con = DriverManager.getConnection(url, uid, pw);

        // Delete related entries in productinventory
        String deleteProductInventoryQuery = "DELETE FROM productinventory WHERE productId = ?";
        PreparedStatement ps1 = con.prepareStatement(deleteProductInventoryQuery);
        ps1.setInt(1, Integer.parseInt(productId));
        ps1.executeUpdate();

        // Delete related entries in orderproduct
        String deleteOrderProductQuery = "DELETE FROM orderproduct WHERE productId = ?";
        PreparedStatement ps2 = con.prepareStatement(deleteOrderProductQuery);
        ps2.setInt(1, Integer.parseInt(productId));
        ps2.executeUpdate();

        // Delete product
        String deleteProductQuery = "DELETE FROM product WHERE productId = ?";
        PreparedStatement ps3 = con.prepareStatement(deleteProductQuery);
        ps3.setInt(1, Integer.parseInt(productId));

        int rowsAffected = ps3.executeUpdate();
        if (rowsAffected > 0) {
            out.println("<p>Product and all related data successfully deleted.</p>");
        } else {
            out.println("<p>Error: Product not found or could not be deleted.</p>");
        }

        ps1.close();
        ps2.close();
        ps3.close();
        con.close();
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>
<a href="admin.jsp">Back to Admin Page</a>
