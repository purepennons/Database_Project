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
	String errorMessage = String.valueOf(request.getParameter("errorMessage"));
	errorMessage = new String(errorMessage.getBytes("ISO-8859-1"), "UTF-8");
	if(errorMessage.equals("null"))
		errorMessage="";
	
	Prof userSession = (Prof)session.getAttribute("userSession");
	String accountClass = (String)session.getAttribute("accountClass");
	if(userSession != null){
		if(accountClass.equals("member")){
			response.sendRedirect(addressBase + "User/index.jsp");
			return;
		}
		else{
			response.sendRedirect(addressBase + "Admin/adminIndex.jsp");
			return;
		}
	}		
%>	 

<%
	session.removeAttribute("username");
	session.removeAttribute("password");
	session.removeAttribute("name");
	session.removeAttribute("sex");
	session.removeAttribute("cell_phone");
	session.removeAttribute("email");
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
<b>歡迎使用線上書籍借閱系統~</b><br>
<form name="indexForm" action="Login/loginCheck.jsp" method="post">
<table>
<tbody>
<tr>
<td>帳號</td>
<td style="vertical-align: top;">
	<input name="userID" type="text"></input></td>
</tr>
<tr>
<td>密碼</td>
<td style="vertical-align: top;"> 
	<input name="passWD" type="password"></input></td>
</tr>
<tr>
	<td>登入類型</td>
	<td>
    	<select name="accountClass">
			<option value="member" selected>一般會員</option>
			<option value="admin">管理員 </option>
		</select>
	</td>
    <td> <input value="GO" type="submit"></td>
</tr> 
<tr>
	<td><a href="Register/register.jsp">免費註冊</a></td>
</tr>	
</tbody>
</table>
	<font color="ff0000"><%=errorMessage %></font>
</form>
<br>	
</body>
</html>