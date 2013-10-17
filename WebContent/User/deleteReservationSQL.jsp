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
	if(userSession != null && accountClass.equals("member")){
		userID = userSession.getId();
	}
	else{
		response.sendRedirect(addressBase +"Login/unLoginPage.jsp");
		return;
	}
%>


<%
	String ISBN = String.valueOf(request.getParameter("ISBN"));
	ISBN = new String(ISBN.getBytes("ISO-8859-1"), "UTF-8");
	if(ISBN.equals("null"))
		ISBN="";
%>

<%	//刪除預約，回加庫存(transaction)
	String stock = "";
	String username = userID;
	String bInfoDeleteSqlString  = "update borrowing_information set state = '取消預約', due_day = current_date() where bUsername = ? and BISBN = ? and state = '已預約' LIMIT 1;";
	String sqlString1 = "select stock from book_information where ISBN = ? for update;";
	String updateSqlString = "update book_information set stock = stock+1 where ISBN = ?";
	
	try {
		int j = 0;
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		dBConnectionInit.getConn().setAutoCommit(false);
		Statement st1 = dBConnectionInit.getConn().createStatement();
		Statement st2 = dBConnectionInit.getConn().createStatement();
		st1.addBatch("set autocommit = 0;");
		st1.addBatch("begin work;");
		st1.executeBatch();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(bInfoDeleteSqlString);
		PreparedStatement ps2 
			= dBConnectionInit.getConn().prepareStatement(sqlString1);
		PreparedStatement ps3 
			= dBConnectionInit.getConn().prepareStatement(updateSqlString);
		ps1.setString(++j, username);
		ps1.setString(++j, ISBN);
		ps2.setString(1, ISBN);
		ps3.setString(1, ISBN);
		st2.addBatch("commit;");
		st2.addBatch("set autocommit = 1;");
		ps1.executeUpdate();
		ResultSet rs1 =  ps2.executeQuery();
		while(rs1.next()){
			stock = rs1.getString(1);
		}
		ps3.executeUpdate();
		st2.executeBatch();
		st1.close();
		st2.close();
		ps1.close();
		ps2.close();
		ps3.close();
		dBConnectionInit.closeConnection();
		out.print("<table align='center'><tr><td><b>取消成功!</b></tr></td>");
		out.print("<tr><td><b>系統將於3秒後跳轉回書籍預約...</b></tr></td></table>");
		response.setHeader("refresh","3;URL=bookReservation.jsp");
	}catch (SQLException e) {
		out.print("<table align='center'><tr><td><b>交易時間過久，已中止取消。</b></tr></td>");
		out.print("<tr><td><b>系統將於3秒後跳轉回書籍預約...</b></tr></td></table>");
		out.print(e.getMessage() + "<br>");
		e.printStackTrace();
		response.setHeader("refresh","3;URL=bookReservation.jsp");
	}

%>

<%

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>刪除中...</title>

</head>
<body>
</body>
</html>