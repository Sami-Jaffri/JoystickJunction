<%@ page language="java" import="java.io.*,java.sql.*,java.security.*" %>
<%@ include file="jdbc.jsp" %>
<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        System.err.println(e);
    }

    if (authenticatedUser != null) {
        response.sendRedirect("listprod.jsp"); // Successful login
    } else {
        response.sendRedirect("login.jsp"); // Failed login - redirect back to login page with a message
    }
%>

<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null || username.isEmpty() || password.isEmpty())
            return null;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Hash the input password using SHA-256
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedPasswordBytes = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedPasswordBytes) sb.append(String.format("%02x", b));
            String hashedPasswordHex = sb.toString();

            // Load the JDBC driver
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Connect to the database
            conn = DriverManager.getConnection(url, uid, pw);

            // First, check with the hashed password
            String sql = "SELECT password FROM customer WHERE userid = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedPassword = rs.getString("password");

                // Compare hashed password
                if (storedPassword.equals(hashedPasswordHex)) {
                    retStr = username; // Successful login with hashed password
                } else if (storedPassword.equals(password)) {
                    retStr = username; // Successful login with plain-text password (fallback)

                    // Optional: Update the plain-text password to hashed for consistency
                    String updateSql = "UPDATE customer SET password = ? WHERE userid = ?";
                    try (PreparedStatement updatePstmt = conn.prepareStatement(updateSql)) {
                        updatePstmt.setString(1, hashedPasswordHex);
                        updatePstmt.setString(2, username);
                        updatePstmt.executeUpdate();
                    }
                }
            }
        } catch (ClassNotFoundException ex) {
            out.println("JDBC Driver not found: " + ex.getMessage());
        } catch (SQLException ex) {
            out.println("SQL Error: " + ex.getMessage());
        } catch (NoSuchAlgorithmException ex) {
            out.println("Hashing error: " + ex.getMessage());
        } finally {
            // Close resources
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }

        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Invalid username or password. Please try again.");
        }

        return retStr;
    }
%>
