<%@ page contentType="text/html; charset=UTF-8"
	 pageEncoding="UTF-8" language="java"
	 import="java.sql.*" 
	 errorPage="" %>
	 <% final String addressBase = "http://114.33.179.243:8080/Database_Project/"; %>
<%request.setCharacterEncoding("UTF-8"); %>

<% 
	String errorMessage = String.valueOf(request.getParameter("errorMessage"));
	errorMessage = new String(errorMessage.getBytes("ISO-8859-1"), "UTF-8");
	if(errorMessage.equals("null"))
		errorMessage="";
%>

<%
	String username = ""; 
	String name = "";
	String cell_phone = "";
	String email = "";

	try{
		username = session.getAttribute("username").toString();
		name = session.getAttribute("name").toString();
		cell_phone = session.getAttribute("cell_phone").toString();
		email = session.getAttribute("emailr").toString();	
	}catch(NullPointerException e){
	
	}	
%>




<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!-- <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">-->
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統 - 註冊</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
<form name="registerForm" action="registerConfirm.jsp" method="post">
<table border="0">
<tbody>
<tr><td><h2><b>註冊</b></h2></td></tr>
<tr>
	<td>帳號</td>
	<td style="vertical-align: top;">
	<input name="username" type="text" value=<%=username %>> </td>
</tr>

<tr>
	<td>密碼</td>
    <td style="vertical-align: top;"> 
	<input name="password" type="password"></td>
</tr>
<tr>
	<td>密碼確認</td>
    <td style="vertical-align: top;"> 
	<input name="passwordCheck" type="password"></td>
</tr>
<tr>
	<td>姓名</td>
    <td style="vertical-align: top;">
	<input name="name" type="text" value=<%=name %>> </td>
</tr>
<tr>
	<td>性別</td>
    <td style="vertical-align: top;">
	<input type="radio" name="sex" value="0" checked>男
	<input type="radio" name="sex" value="1">女 </td>
</tr>
<tr>
	<td>手機號碼</td>
    <td style="vertical-align: top;">
	<input name="cell_phone" type="text" value=<%=cell_phone %>> </td>
</tr>
<tr>
	<td>電子信箱</td>
    <td style="vertical-align: top;">
	<input name="email" type="text" value=<%=email %>> </td>
</tr>

<tr>
	<td><input type ='button' onclick="javascript:location.href='<%=addressBase %>index.jsp'" value='回首頁'></input></td>
	<td>
		<input type="reset" value="重置"></input>
    	<input type="submit" value="提交"></input>
    </td>
</tr>

</tbody>
</table>
<font color="ff0000"><%=errorMessage %></font>
</form>
</body>
</html>
