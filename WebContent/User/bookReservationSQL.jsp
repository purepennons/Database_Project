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
	String reISBN = String.valueOf(request.getParameter("ISBN"));
	reISBN = new String(reISBN.getBytes("ISO-8859-1"), "UTF-8");
	if(reISBN.equals("null"))
		reISBN="";
%>

<%	//預約 庫存扣除 +新增預約紀錄(transaction)
	String stock = "";
	String username = userID;
	String sqlString1 = "select stock from book_information where ISBN = ? for update;";
	String updateSqlString = "update book_information set stock = stock-1 where ISBN = ?";
	String bInfoInsertSqlString  = "insert into borrowing_information value(null, ?, ?, current_date, date_add(current_date, INTERVAL 3 DAY), '已預約');";
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
			= dBConnectionInit.getConn().prepareStatement(sqlString1);
		PreparedStatement ps2 
			= dBConnectionInit.getConn().prepareStatement(updateSqlString);
		PreparedStatement ps4 
			= dBConnectionInit.getConn().prepareStatement(bInfoInsertSqlString);
		ps1.setString(1, reISBN);
		ps2.setString(1, reISBN);
		st2.addBatch("commit;");
		st2.addBatch("set autocommit = 1;");
		ResultSet rs1 = ps1.executeQuery();
		while(rs1.next()){
			stock = rs1.getString(1);
			out.print(stock);
		}
		if(Integer.parseInt(stock)<1){
			out.print("<table align='center'><tr><td><b>庫存為零，預約失敗! 系統將於3秒後跳轉回書籍預約...</b></tr></td></table>");
			st2.executeBatch();
			rs1.close();
			st1.close();
			st2.close();
			ps1.close();
			ps2.close();
			ps4.close();
			dBConnectionInit.closeConnection();
			response.setHeader("refresh","3;URL=bookReservation.jsp");
		}
		ps2.executeUpdate();
		ps4.setString(++j, reISBN);
		ps4.setString(++j, username);
		ps4.executeUpdate();
		st2.executeBatch();
		rs1.close();
		st1.close();
		st2.close();
		ps1.close();
		ps2.close();
		ps4.close();
		dBConnectionInit.closeConnection();
		out.print("<table align='center'><tr><td><b>預約成功!</b></tr></td>");
		out.print("<tr><td><b>系統將於3秒後跳轉回書籍預約...</b></tr></td></table>");
		response.setHeader("refresh","3;URL=bookReservation.jsp");
	}catch (SQLException e) {
		out.print("<table align='center'><tr><td><b>交易時間過久，已中止預約。</b></tr></td>");
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

<title>預約中...</title>

</head>
<body>
</body>
</html>