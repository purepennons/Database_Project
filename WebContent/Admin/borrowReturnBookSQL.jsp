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
	String ISBN = String.valueOf(request.getParameter("ISBN"));
	if(ISBN.equals("null"))
		ISBN="";
	String username = String.valueOf(request.getParameter("username"));
	if(username.equals("null"))
		username="";
	String listBy = String.valueOf(request.getParameter("listBy"));
	if(listBy.equals("null"))
		listBy="";
	out.print(ISBN + "   " + username + " " + listBy);
	if(ISBN.equals("") || username.equals("")){
		session.setAttribute("sessionISBN", ISBN);
		session.setAttribute("sessionUsername", username);
		session.setAttribute("sessionListBy", listBy);
		response.sendRedirect("borrowReturnBook.jsp");
		return;
	}
%>

<%	//借書還書，回加減庫存、借閱次數遞增(transaction)
	String stock = "";
	String state = "";
	boolean nullFlag = false;
	boolean zeroStockFlag = false;
	boolean addTimesFlag = false;
	String checkISBNSqlString = "select * from book_information where ISBN = ?";
	String checkUsernameSqlString = "select * from account where username = ?";
	String selectStateSqlString = "select state from borrowing_information where BISBN = ? and bUsername = ? order by starting_day for update;";
	String selectStockSqlString = "select stock from book_information where ISBN = ? for update;";
	String selectTimesSqlString = "select times from book_information where ISBN = ? for update;";
	String bInfoUpdateSqlString  = "";
	String stockUpdateSqlString = "";
	String bTimesUpdateSqlString  = "update book_information set times = times+1 where ISBN = ?;";
	try {
		int i=0, j=0, k=0;
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		dBConnectionInit.getConn().setAutoCommit(false);
		PreparedStatement ps7 
			= dBConnectionInit.getConn().prepareStatement(checkISBNSqlString);
		PreparedStatement ps8 
			= dBConnectionInit.getConn().prepareStatement(checkUsernameSqlString);
		ps7.setString(1, ISBN);
		ps8.setString(1, username);
		ResultSet rs7 = ps7.executeQuery();
		ResultSet rs8 = ps8.executeQuery();
		if(!rs7.next() || !rs8.next())
		{
			rs7.close();
			rs8.close();
			ps7.close();
			ps8.close();
			dBConnectionInit.closeConnection();
			out.print("<table align='center'><tr><td><b>無相符之ISBN或帳號! 系統將於3秒後跳轉回借書還書...</b></tr></td></table>");
			response.setHeader("refresh","3;URL=borrowReturnBook.jsp");
			return;
		}
		Statement st1 = dBConnectionInit.getConn().createStatement();
		Statement st2 = dBConnectionInit.getConn().createStatement();
		st1.addBatch("set autocommit = 0;");
		st1.addBatch("begin work;");
		st2.addBatch("commit;");
		st2.addBatch("set autocommit = 1;");
		st1.executeBatch();
		st1.close();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(selectStateSqlString);
		PreparedStatement ps2 
			= dBConnectionInit.getConn().prepareStatement(selectStockSqlString);
		ps1.setString(++i, ISBN);
		ps1.setString(++i, username);
		ps2.setString(1, ISBN);
		ResultSet rs1 = ps1.executeQuery();
		while(rs1.next()){
			state = rs1.getString(1);
			nullFlag = true;
		}
		rs1.close();
		ps1.close();
		if(state.equals("借閱中") || state.equals("已逾期")){
			bInfoUpdateSqlString  = "update borrowing_information set state = '已歸還', due_day = current_date() where BISBN = ? and bUsername = ? and state = '借閱中' LIMIT 1;";
			stockUpdateSqlString = "update book_information set stock = stock+1 where ISBN = ?;";
		}else if(state.equals("已預約")){
			bInfoUpdateSqlString  = "update borrowing_information set state = '借閱中', starting_day = current_date(), due_day = date_add(current_date, INTERVAL 7 DAY) where  BISBN = ? and bUsername = ? and state = '已預約' LIMIT 1;";
			stockUpdateSqlString = "update book_information set stock = stock-1 where ISBN = ?;";
			addTimesFlag = true;
		}else if(!nullFlag || state.equals("已歸還") || state.equals("取消預約")){
			bInfoUpdateSqlString  = "insert into borrowing_information value(null, ?, ?, current_date, date_add(current_date, INTERVAL 7 DAY), '借閱中');";
			stockUpdateSqlString = "update book_information set stock = stock-1 where ISBN = ?;";
			addTimesFlag = true;
		}else if(state.equals("已逾期")){

		}
		ResultSet rs2 = ps2.executeQuery();
		while(rs2.next()){
			stock = rs2.getString(1);
		}
		rs2.close();
		ps2.close();
		if(Integer.parseInt(stock)<1 && !state.equals("借閱中")){
			st2.executeBatch();
			st2.close();
			dBConnectionInit.closeConnection();
			zeroStockFlag = true;
			out.print("<table align='center'><tr><td><b>庫存為零，無法借閱! 系統將於3秒後跳轉回借書還書...</b></tr></td></table>");
			response.setHeader("refresh","3;URL=borrowReturnBook.jsp");
			return;
		}
		if(!zeroStockFlag){
			PreparedStatement ps3 
				= dBConnectionInit.getConn().prepareStatement(bInfoUpdateSqlString);
			PreparedStatement ps4 
				= dBConnectionInit.getConn().prepareStatement(stockUpdateSqlString);
			ps3.setString(++j, ISBN);
			ps3.setString(++j, username);
			ps4.setString(++k, ISBN);
			ps3.executeUpdate();
			ps4.executeUpdate();
			ps3.close();
			ps4.close();
		}
		if(addTimesFlag){
			PreparedStatement ps5 
				= dBConnectionInit.getConn().prepareStatement(selectTimesSqlString);
			PreparedStatement ps6 
				= dBConnectionInit.getConn().prepareStatement(bTimesUpdateSqlString);
			ps5.setString(1, ISBN);
			ps6.setString(1, ISBN);
			ps5.executeQuery();
			ps6.executeUpdate();
			ps5.close();
			ps6.close();
		}
		st2.executeBatch();
		st2.close();
		dBConnectionInit.closeConnection();
		session.removeAttribute("sessionISBN");
		session.removeAttribute("sessionUsername");
		out.print("<table align='center'><tr><td><b>操作成功!</b></tr></td>");
		out.print("<tr><td><b>系統將於3秒後跳轉回借書還書...</b></tr></td></table>");
		response.setHeader("refresh","3;URL=borrowReturnBook.jsp");
	}catch (SQLException e) {
		out.print("<table align='center'><tr><td><b>交易時間過久，已中止操作。</b></tr></td>");
		out.print("<tr><td><b>系統將於3秒後跳轉回借書還書...</b></tr></td></table>");
		out.print(e.getMessage() + "<br>");
		e.printStackTrace();
		response.setHeader("refresh","3;URL=borrowReturnBook.jsp");
	}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>借書還書</title>

</head>
<body>
</body>
</html>