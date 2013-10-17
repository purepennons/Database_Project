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

	String deleteISBN = (String)session.getAttribute("deleteISBN");
	String bookBorrowCheckSqlString1 = "(select * from borrowing_information where BISBN = ? and state = '借閱中' for update)";
	String bookBorrowCheckSqlString2 = "(select * from borrowing_information where BISBN = ? and state = '已逾期' for update)";
	String bookBorrowCheckSqlString = bookBorrowCheckSqlString1 + " union " + bookBorrowCheckSqlString2;
	String sqlString1 = "delete from book_information where ISBN = ?;";
	String sqlString2 = "delete from book_introduction where ISBN = ?;";
	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(sqlString1);
		PreparedStatement ps2 
			= dBConnectionInit.getConn().prepareStatement(sqlString2);
		PreparedStatement ps3 
			= dBConnectionInit.getConn().prepareStatement(bookBorrowCheckSqlString);
		int i = 0;
		Statement st1 = dBConnectionInit.getConn().createStatement();
		Statement st2 = dBConnectionInit.getConn().createStatement();
		st1.addBatch("set autocommit = 0;");
		st1.addBatch("begin work;");
		st2.addBatch("commit;");
		st2.addBatch("set autocommit = 1;");
		st1.executeBatch();

		ps1.setString(1, deleteISBN);
		ps2.setString(1, deleteISBN);
		ps3.setString(++i, deleteISBN);
		ps3.setString(++i, deleteISBN);
		ResultSet rs1 = ps3.executeQuery();
		if(rs1.next()){
			out.print("<table align='center'><tr><td><b>存在尚未歸還之書籍，刪除失敗! 系統將於3秒後跳轉回書籍管理...</b></tr></td></table>");
			st2.executeBatch();
			st1.close();
			st2.close();
			rs1.close();
			ps1.clearParameters();
			ps2.clearParameters();
			ps1.close();
			ps2.close();
			ps3.close();
			dBConnectionInit.closeConnection();
			session.removeAttribute("deleteISBN");
			response.setHeader("refresh","3;URL=bookManage.jsp");
			return;					
		}	
		ps1.executeUpdate();
		ps2.executeUpdate();
		st2.executeBatch();
		rs1.close();
		st1.close();
		st2.close();
		ps1.clearParameters();
		ps2.clearParameters();
		ps1.close();
		ps2.close();
		dBConnectionInit.closeConnection();
		session.removeAttribute("deleteISBN");
		response.setHeader("refresh","1;URL=bookManage.jsp");
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
<body>
</body>
</html>