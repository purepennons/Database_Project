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
	String errorMessage = String.valueOf(request.getParameter("errorMessage"));
	errorMessage = new String(errorMessage.getBytes("ISO-8859-1"), "UTF-8");
	if(errorMessage.equals("null"))
		errorMessage="";
%>

<%
	String ISBN = ""; 
	String BName = "";
	String bookClass = "";
	String author = "";
	String press = "";
	String stock = "";
	String release_date = "";
	String book_introduction = "";	
	
	try{
		ISBN = session.getAttribute("ISBN").toString();
		BName = session.getAttribute("BName").toString();
		bookClass = session.getAttribute("bookClass").toString();
		author = session.getAttribute("author").toString();
		press = session.getAttribute("press").toString();
		stock = session.getAttribute("stock").toString();
		release_date = session.getAttribute("release_date").toString();
		book_introduction = session.getAttribute("book_introduction").toString();	
	}catch(NullPointerException e){
		
	}
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統 - 書籍管理</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->


</head>
<body>
<h2><b>新增書籍</b></h2>
<form name="registerForm" action="insertBookConfirm.jsp" method="post">
<table border='1'>
<tbody>
<tr>
	<td>ISBN<font color="ff0000">*</font></td>
	<td style="vertical-align: top;">
	<input name="ISBN" type="text" value=<%=ISBN %>> </td>
</tr>

<tr>
	<td>書名<font color="ff0000">*</font></td>
    <td style="vertical-align: top;">
	<input name="BName" type="text" value=<%=BName %>> </td>
</tr>

<tr>
	<td>類別</td>
	<td>
    	<select name="bookClass">
			<option value="人文" selected>人文</option>
			<option value="科學">科學</option>
			<option value="娛樂">娛樂</option>
			<option value="其他">其他</option>
		</select>
	</td>
</tr>
<tr>
	<td>作者</td>
    <td style="vertical-align: top;">
	<input name="author" type="text" value=<%=author %>> </td>
</tr>
<tr>
	<td>出版社<font color="ff0000">*</font></td>
    <td style="vertical-align: top;">
	<input name="press" type="text" value=<%=press %>> </td>
</tr>
<tr>
	<td>庫存<font color="ff0000">*</font></td>
    <td style="vertical-align: top;">
	<input name="stock" type="text" value=<%=stock %>> </td>
</tr>
<tr>
	<td>出版年份<font color="ff0000">*</font></td>
    <td style="vertical-align: top;">
	<input name="release_date" type="text" value=<%=release_date %>> </td>
</tr>
<tr>
	<td>簡介</td>
	<td>
		<textarea rows="10" cols="50" name=book_introduction ><%=book_introduction %></textarea>
	</td>	
</tr>

<tr>
	<td></td>
	<td>
		<input type ='button' onclick="javascript:location.href='bookManage.jsp'" value='回書籍管理'></input>
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