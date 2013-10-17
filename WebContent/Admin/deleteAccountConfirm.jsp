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
	String deleteUsername = String.valueOf(request.getParameter("userID"));
	deleteUsername = new String(deleteUsername.getBytes("ISO-8859-1"), "UTF-8");
	if(deleteUsername.equals("null"))
		deleteUsername="";
	session.setAttribute("deleteUsername", deleteUsername);
%>





<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>線上書籍借閱系統 - 會員刪除</title>

</head>
<body>
<form name="deleteAccountConfirmForm" action="deleteAccountSQL.jsp" method="post">
<table align="center">
<tbody>
<tr><td><h1><b>確定刪除<%=deleteUsername %>?</b></h1><br></td></tr>
<tr>
	<td>
		<input type ="button" onclick="history.back()" value="上一頁"></input>
	</td>
	<td>	
		<input type="submit" value="確定"></input>
	</td>
</tr>
</tbody>
</table>
</form>
</body>
</html>