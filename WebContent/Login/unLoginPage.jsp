<%@ page contentType="text/html; charset=UTF-8"
	 pageEncoding="UTF-8" language="java"
	 import="java.sql.*" 
	 errorPage="" %>
<%@page import="java.sql.*" %>
<%@page import="javax.sql.*" %>
<%@page import="javax.naming.*" %>
<%@page import="User.Prof" %>
<% final String addressBase = "http://114.33.179.243:8080/Database_Project/"; %>
<%request.setCharacterEncoding("UTF-8"); %>

<%
	Prof userSession = (Prof)session.getAttribute("userSession");
	if(userSession != null){
		userSession = null;
		session.removeAttribute("userSession");
		session.removeAttribute("accountClass");
		response.sendRedirect(addressBase +"index.jsp");
		return;
	}
	else{
		session.removeAttribute("userSession");
		session.removeAttribute("accountClass");
		session.invalidate();
		response.setHeader("refresh","0;URL=unLoginPage.jsp");
	}
	
%>
<%
	response.setHeader("refresh","3;URL=http://114.33.179.243:8080/Database_Project/index.jsp");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
<form name="unLoginPageForm">
<table>
<tbody>
	<tr><td align="center"><b>尚未登入，系統將在3秒後跳轉回首頁...</b></td></tr>
	<tr><td><a href="<%=addressBase %>index.jsp">點擊這裡立即跳轉</a></td></tr>
</tbody>
</table>
</form>
<br>
</body>
</html>