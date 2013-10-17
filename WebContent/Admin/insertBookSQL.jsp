<%@ page contentType="text/html; charset=UTF-8"
	 pageEncoding="UTF-8" language="java"
	 import="java.sql.*" 
	 errorPage="" %>
<%@page import="java.sql.*" %>
<%@page import="javax.sql.*" %>
<%@page import="javax.naming.*" %>
<%@page import="EncryptBean.EncryptBean" %>
<%@page import="User.Prof" %>
<%@page import="Database.DBConnectionInit" %>
<% final String addressBase = "http://114.33.179.243:8080/Database_Project/"; %>
<%request.setCharacterEncoding("UTF-8"); %>
<%
	Prof userSession = (Prof)session.getAttribute("userSession");
	String accountClass = (String)session.getAttribute("accountClass");
	String userID = "";
	if(userSession != null && accountClass.equals("admin")){
		userID = userSession.getId();
	}
	else{
		response.sendRedirect(addressBase +"Login/unLoginPage.jsp");
		return;
	}
%>

<%
	String ISBN = session.getAttribute("ISBN").toString();
	String BName = session.getAttribute("BName").toString();
	String bookClass = session.getAttribute("bookClass").toString();
	String author = session.getAttribute("author").toString();
	String press = session.getAttribute("press").toString();
	String stock = session.getAttribute("stock").toString();
	String release_date = session.getAttribute("release_date").toString();
	String book_introduction = session.getAttribute("book_introduction").toString();
	String sqlString1 = "insert into book_information(ISBN, BName, class, author, press, stock, release_date) value(?, ?, ?, ?, ?, ?, ?);";
	String sqlString2 = "insert into book_introduction value(?, ?);";

	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(sqlString1);
		PreparedStatement ps2 
		= dBConnectionInit.getConn().prepareStatement(sqlString2);
		int i = 0, j=0;
		ps1.setString(++i, ISBN);
		ps1.setString(++i, BName);
		ps1.setString(++i, bookClass);
		ps1.setString(++i, author);
		ps1.setString(++i, press);
		ps1.setString(++i, stock);
		ps1.setString(++i, release_date);
		ps2.setString(++j, ISBN);
		ps2.setString(++j, book_introduction);
		ps1.executeUpdate();
		ps2.executeUpdate();
		ps1.clearParameters();
		ps2.clearParameters();
		ps1.close();
		ps2.close();
		dBConnectionInit.closeConnection();
		session.removeAttribute("ISBN");
		session.removeAttribute("BName");
		session.removeAttribute("bookClass");
		session.removeAttribute("author");
		session.removeAttribute("press");
		session.removeAttribute("stock");
		session.removeAttribute("release_date");
		session.removeAttribute("book_introduction");
		response.setHeader("refresh","1;URL=http://114.33.179.243:8080/Database_Project/Admin/bookManage.jsp");
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