<!--
A JSP file that encapsulates database connections.

Public methods:
- public void getConnection() throws SQLException
- public void closeConnection() throws SQLException  
-->

<%@ page import="java.sql.*"%>

<%!
	String dbURL = "jdbc:mysql://165.22.233.10:3307/orders";
	private String uid = "sa";
	private String pw = "304#sa#pw";
	
	private String urlForLoadData = "jdbc:sqlserver://165.22.233.10:3307;TrustServerCertificate=True";
	
	private Connection con = null;
%>

<%!
	public void getConnection() throws SQLException 
	{
		try
		{	// Load driver class
			Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		}
		catch (java.lang.ClassNotFoundException e)
		{
			throw new SQLException("ClassNotFoundException: " +e);
		}
	
		con = DriverManager.getConnection(url, uid, pw);
		Statement stmt = con.createStatement();
	}
   
	public void closeConnection() 
	{
		try {
			if (con != null)
				con.close();
			con = null;
		}
		catch (Exception e)
		{ }
	}
%>
