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

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統 - 管理員模式</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
管理員：   <%=userID %><br>
<a href="<%=addressBase %>Login/logout.jsp">登出</a>
<br>
<br>
<form name="adminIndexForm" action="adminSearchPage.jsp" method="post">

<table align="center">
<tbody>
	<tr>
		<td></td>
		<td style="vertical-align: top;">
			<input type="text"  name="searchText" size="35"></input>
		</td>
		<td>
			<select name="searchType">
				<option value="會員"  selected>會員</option>
				<option value="書名">書名</option>
				<option value="ISBN">ISBN</option>
				<option value="作者">作者</option>
				<option value="出版社">出版社</option>
				<option value="年份">年份</option>
			</select>
		</td>
		<td><input type="submit" value="Serach" ></td>
	</tr>
	<tr>
		<td>類別</td>
		<td>
			<input type="checkbox" name="category[]" value="人文" checked>人文
			<input type="checkbox" name="category[]" value="科學" checked>科學
			<input type="checkbox" name="category[]" value="娛樂" checked>娛樂
			<input type="checkbox" name="category[]" value="其他" checked>其他
		</td>
	</tr>
</tbody>
</table>
</form>
<br>

<table align="center">
	<tbody>
		<tr>
			<td><a href="memberManage.jsp">會員管理</a></td>
			<td>||</td>
			<td><a href="bookManage.jsp">書籍管理</a></td>
		</tr>
		<tr>
			<td><a href="borrowReturnBook.jsp">借書還書</a></td>
			<td>||</td>
			<td><a href="borrowingInfoList.jsp">借閱紀錄</a></td>
		</tr>
	</tbody>
</table>
</body>
</html>