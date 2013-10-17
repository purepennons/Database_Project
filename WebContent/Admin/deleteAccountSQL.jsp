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
	String deleteUsername = (String)session.getAttribute("deleteUsername");
	String borrowCheckSqlString1 = "(select * from borrowing_information where bUsername = ? and state = '借閱中' for update)";
	String borrowCheckSqlString2 = "(select * from borrowing_information where bUsername = ? and state = '已逾期' for update)";
	String borrowCheckSqlString3 = "select BISBN, state from borrowing_information where bUsername = ? and state = '已預約' for update";		
	String borrowCheckSqlString = borrowCheckSqlString1 + " union " + borrowCheckSqlString2;
	String selectStockSqlString = "select stock from book_information where ISBN = ? for update;";
	String updateSqlString = "update book_information set stock = stock+1 where ISBN = ?;";
	String sqlString = "delete from account where username = ?;";

	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(borrowCheckSqlString);
		PreparedStatement ps2 
			= dBConnectionInit.getConn().prepareStatement(borrowCheckSqlString3);
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		int i = 0;
		Statement st1 = dBConnectionInit.getConn().createStatement();
		Statement st2 = dBConnectionInit.getConn().createStatement();
		st1.addBatch("set autocommit = 0;");
		st1.addBatch("begin work;");
		st2.addBatch("commit;");
		st2.addBatch("set autocommit = 1;");
		st1.executeBatch();
		ps1.setString(++i, deleteUsername);
		ps1.setString(++i, deleteUsername);
		ps2.setString(1 , deleteUsername);
		ps.setString(1, deleteUsername);
		ResultSet rs1 = ps1.executeQuery();
		if(rs1.next()){
			out.print("<table align='center'><tr><td><b>存在尚未歸還之書籍，刪除失敗! 系統將於3秒後跳轉回會員管理...</b></tr></td></table>");
			st2.executeBatch();
			st1.close();
			st2.close();
			rs1.close();
			ps1.clearParameters();
			ps2.clearParameters();
			ps1.close();
			ps2.close();
			ps.close();
			dBConnectionInit.closeConnection();
			session.removeAttribute("deleteUsername");
			response.setHeader("refresh","3;URL=memberManage.jsp");
			return;
		}
		ResultSet rs2 = ps2.executeQuery();
		while(rs2.next()){
			String reISBN = rs2.getString(1);
			//out.print(reISBN);
			PreparedStatement ps3 
				= dBConnectionInit.getConn().prepareStatement(selectStockSqlString);
			PreparedStatement ps4 
				= dBConnectionInit.getConn().prepareStatement(updateSqlString);
			ps3.setString(1, reISBN);
			ps4.setString(1, reISBN);
			ps3.executeQuery();
			ps4.executeUpdate();
			ps3.clearParameters();
			ps4.clearParameters();
			ps3.close();
			ps4.close();
		}
		
		ps.executeUpdate();
		ps.clearParameters();
		st2.executeBatch();
		st1.close();
		st2.close();
		rs1.close();
		rs2.close();
		ps1.close();
		ps2.close();
		ps.close();
		dBConnectionInit.closeConnection();
		session.removeAttribute("deleteUsername");
		response.setHeader("refresh","1;URL=memberManage.jsp");
		return;
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