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
	String username = String.valueOf(request.getParameter("username"));
	username = new String(ISBN.getBytes("ISO-8859-1"), "UTF-8");
	if(username.equals("null"))
		username="";
%>

<%
	String actionTo = "deleteReservationSQL.jsp?ISBN=" + ISBN + "&username=" + username;
	out.print("<form name='deleteReservationConfirmForm'action='" + actionTo +"' method='post'>");
	out.print("<table align='center'>");
	out.print("<tbody>");
	out.print("<tr><td><b>確定取消ISBN為" + ISBN + "的書籍?</b><br></td></tr>");
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

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>線上書籍借閱系統 - 取消預約</title>

</head>
<body>
</body>
</html>