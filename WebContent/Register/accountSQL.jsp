<%@ page contentType="text/html; charset=UTF-8"
	 pageEncoding="UTF-8" language="java"
	 import="java.sql.*" 
	 errorPage="" %>
<%@page import="java.sql.*" %>
<%@page import="javax.sql.*" %>
<%@page import="javax.naming.*" %>
<%@page import="Database.DBConnectionInit" %>
<% final String addressBase = "http://114.33.179.243:8080/Database_Project/"; %>
<%request.setCharacterEncoding("UTF-8"); %>

<%
	String username = session.getAttribute("username").toString();
	String password = session.getAttribute("password").toString();
	String name = session.getAttribute("name").toString();
	String sex = session.getAttribute("sex").toString();
	String cell_phone = session.getAttribute("cell_phone").toString();
	String email = session.getAttribute("email").toString();
	
	String sexValue = sex.equals("0")?"M":"F";
	String sqlString = "insert into account value(?, MD5(?), ?, ?, ?, now(), ?);";

	try {
		//ResultSetMetaData ms = rs.getMetaData();
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		int i = 0;
		ps.setString(++i, username);
		ps.setString(++i, password);
		ps.setString(++i, name);
		ps.setString(++i, cell_phone);
		ps.setString(++i, email);
		ps.setString(++i, sexValue);
		ps.executeUpdate();
		ps.clearParameters();
		ps.close();
		dBConnectionInit.closeConnection();
		session.removeAttribute("username");
		session.removeAttribute("password");
		session.removeAttribute("name");
		session.removeAttribute("sex");
		session.removeAttribute("cell_phone");
		session.removeAttribute("email");
		
		out.print("註冊成功!系統將於3秒後跳轉回首頁...");
		response.setHeader("refresh","3;URL=http://114.33.179.243:8080/Database_Project/index.jsp");
	}catch (SQLException e) {
		out.println(e.getMessage());
		e.printStackTrace();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">-->
<title>Loading...</title>
</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
<form>
<table border="0">
<tbody>
	<!--<tr><td><a href="http://114.33.179.243:8080/Database_Project/index.jsp">回首頁</a></td></tr>-->
</tbody>
</table>
</form>
</body>
</html>