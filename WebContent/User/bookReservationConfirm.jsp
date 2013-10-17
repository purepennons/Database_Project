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

<%	//庫存查詢
	String stock = "";
	boolean nullFlag = false;
	String sqlString = "select stock from book_information where ISBN = ?;";
	try {
		int i = 0;
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		ps1.setString(++i, reISBN);
		ResultSet rs1 = ps1.executeQuery();
		while(rs1.next()){
			stock = rs1.getString(1);
			out.print(stock);
			nullFlag = true;
		}
		if(!nullFlag || Integer.parseInt(stock)<1){
			out.print("<table align='center'><tr><td><b>查無為ISBN之書籍或庫存為零! 系統將於3秒後跳轉回書籍預約...</b></tr></td></table>");
			rs1.close();
			ps1.close();
			dBConnectionInit.closeConnection();
			nullFlag = false;
			response.setHeader("refresh","3;URL=bookReservation.jsp");
		}
		rs1.close();
		ps1.close();
		dBConnectionInit.closeConnection();
	}catch (SQLException e) {
		out.print(e.getMessage());
		e.printStackTrace();
	}

%>

<%
	String actionTo = "bookReservationSQL.jsp?ISBN=" + reISBN;
	if(nullFlag){
		out.print("<form name='bookReservationConfirmForm'action='" + actionTo +"' method='post'>");
		out.print("<table align='center'>");
		out.print("<tbody>");
		out.print("<tr><td><b>確定預約ISBN為" + reISBN + "的書籍?</b><br></td></tr>");
		out.print("<tr>");
		out.print("<td>");
		out.print("<input type ='button' onclick='history.back()' value='上一頁'></input>");
		out.print("</td>");
		out.print("<td>");
		out.print("<input type='submit' value='確定'></input>");
		out.print("</tr>");
		out.print("</tbody>");
		out.print("</table>");
		out.print("</form>");
	}
%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>線上書籍借閱系統 - 書籍預約</title>

</head>
<body>
</body>
</html>