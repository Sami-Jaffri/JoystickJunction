<%@ include file="jdbc.jsp" %>
<%
    int warehouseId = Integer.parseInt(request.getParameter("warehouseId"));
    int productId = Integer.parseInt(request.getParameter("productId"));
    int newQuantity = Integer.parseInt(request.getParameter("quantity"));

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        Connection con = DriverManager.getConnection(url, uid, pw);

        String updateQuery = 
            "UPDATE productinventory " +
            "SET quantity = ? " +
            "WHERE warehouseId = ? AND productId = ?";

        PreparedStatement ps = con.prepareStatement(updateQuery);
        ps.setInt(1, newQuantity);
        ps.setInt(2, warehouseId);
        ps.setInt(3, productId);

        int rowsUpdated = ps.executeUpdate();
        ps.close();
        con.close();

        if (rowsUpdated > 0) {
            session.setAttribute("message", "Inventory updated successfully.");
        } else {
            session.setAttribute("error", "Failed to update inventory.");
        }
    } catch (Exception e) {
        session.setAttribute("error", "Error: " + e.getMessage());
    }

    response.sendRedirect("admin.jsp");
%>
