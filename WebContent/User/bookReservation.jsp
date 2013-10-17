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
	String orderURL = "bookReservationConfirm.jsp";
	String formString = "<form name='bookReservationForm' action='";
	formString += orderURL + "' method='post'>";
	out.print(formString);
	out.print("ISBN：<input type='text' name='ISBN' ></input>");
	out.print("<input type='submit' value='預約書籍'></input>(輸入完整ISBN預約書籍)<br>");
	out.print("<input type ='button' onclick=\"javascript:location.href='index.jsp'\" value='回首頁'></input>");
	out.print("</form>");
%>
	
<%
	String ISBN = "";
	String bookName = "";
	String username = userID;
	String name = "";
	String starting_day = "";
	String due_day = "";
	String state = "";
	out.print("<b>預約清單：</b><br>");
	try {
		String sqlString1 = "select T2.idpass, T2.BISBN, T3.BName, T2.bUsername, T1.name, T2.starting_day, T2.due_day, T2.state ";
		String sqlString2 = " from account T1, borrowing_information T2, book_information T3 ";
		String sqlString3 = " where T2.bUsername = ? and T2.BISBN = T3.ISBN and T2.bUsername = T1.username and T2.state = '已預約' order by starting_day;";
		String sqlString = sqlString1 + sqlString2 + sqlString3;
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		ps.setString(1, userID);
		ResultSet rs = ps.executeQuery();
		out.print("<table border='1' color='cyan'>");
		out.print("<tr>");
	    out.print("<th width='120'>"+"ISBN");
	    out.print("<th width='200'>"+"書名");
	    out.print("<th width='80'>"+"帳號");
	    out.print("<th width='100'>"+"借閱人");
	    out.print("<th width='100'>"+"預約日期");
	    out.print("<th width='100'>"+"截止日期");
	    out.print("<th width='80'>"+"書籍狀態");
	    out.print("<th width='40'>"+"");
	    out.print("</tr>");
		while(rs.next()){
			int i=1;
			ISBN = rs.getString(++i);
			bookName = rs.getString(++i);
			username = rs.getString(++i);
			name = rs.getString(++i);
			starting_day = rs.getString(++i);
			due_day = rs.getString(++i);
			state = rs.getString(++i);
			out.print("<tr>");
			out.print("<td>"+ISBN+"</td>");
			out.print("<td>"+bookName+"</td>");
			out.print("<td>"+username+"</td>");
			out.print("<td>"+name+"</td>");
			out.print("<td >"+starting_day+"</td>");
			out.print("<td >"+due_day+"</td>");
			out.print("<td >"+state+"</td>");
			out.print("<td><a href='deleteReservationConfirm.jsp?ISBN=" + ISBN
					+"&username=" + username + "'>取消</a></td>");
			out.print("</tr>");
		}
		out.print("</table>");
		rs.close();
		ps.close();
		dBConnectionInit.closeConnection();
	}catch (SQLException e) {
		out.print(e.getMessage());
		out.print("<br>Fail to Query!");
		e.printStackTrace();
	}

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統 - 書籍預約</title>


</head>
<body>
</body>
</html>