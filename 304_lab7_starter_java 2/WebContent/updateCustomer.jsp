<%@ page language="java" import="java.io.*,java.sql.*" %>
<%@ include file="jdbc.jsp" %>
<%
    String customerId = request.getParameter("customerId");
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phonenum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");

    Connection con = null;
    PreparedStatement ps = null;

    try {
        con = DriverManager.getConnection(url, uid, pw);
        String updateSql = "UPDATE customer SET firstName = ?, lastName = ?, email = ?, phonenum = ?, address = ?, city = ?, state = ?, postalCode = ?, country = ? WHERE customerId = ?";
        ps = con.prepareStatement(updateSql);
        ps.setString(1, firstName);
        ps.setString(2, lastName);
        ps.setString(3, email);
        ps.setString(4, phonenum);
        ps.setString(5, address);
        ps.setString(6, city);
        ps.setString(7, state);
        ps.setString(8, postalCode);
        ps.setString(9, country);
        ps.setString(10, customerId);

        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
            session.setAttribute("updateMessage", "Your information has been updated successfully.");
        } else {
            session.setAttribute("updateMessage", "Update failed. Please try again.");
        }

        response.sendRedirect("customer.jsp");
    } catch (SQLException e) {
        out.println("<p>Error updating customer information: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>
