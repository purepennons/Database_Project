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
	String updateISBN = String.valueOf(request.getParameter("ISBN"));
	updateISBN = new String(updateISBN.getBytes("ISO-8859-1"), "UTF-8");
	if(updateISBN.equals("null"))
		updateISBN="";
	session.setAttribute("updateISBN", updateISBN);
%>
	
<%

	String sqlString1 = "select ISBN, BName, class, author, press, stock, release_date from book_information where ISBN = '";
	sqlString1 += updateISBN + "';";
	String sqlString2 = "select content from book_introduction where ISBN = '";
	sqlString2 += updateISBN + "';";
	String ISBN = "";
	String BName = "";
	String bookClass = "";
	String author = "";
	String press = "";
	String stock = "";
	String release_date = "";
	String book_introduction ="";

	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		Statement st1 
			= dBConnectionInit.getConn().createStatement();
		Statement st2 
		= dBConnectionInit.getConn().createStatement();
		ResultSet rs1 = st1.executeQuery(sqlString1);
		ResultSet rs2 = st2.executeQuery(sqlString2);
		while(rs1.next()){
			int i = 0;
			ISBN = rs1.getString(++i);
			BName = rs1.getString(++i);
			bookClass = rs1.getString(++i);
			author = rs1.getString(++i);
			press = rs1.getString(++i);
			stock = rs1.getString(++i);
			release_date = rs1.getString(++i);
		}
		while(rs2.next()){
			book_introduction = rs2.getString(1);
			book_introduction = book_introduction.replace("<br>", "\r\n");
		}
		rs1.close();
		rs2.close();
		st1.close();
		st2.close();
		dBConnectionInit.closeConnection();
	}catch (SQLException e) {
		out.println(e.getMessage());
		e.printStackTrace();
	}

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統 - 詳細資料</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->


</head>
<body>
<h2><b>ISBN：<%=updateISBN%></b></h2>
<table>
<tbody>
<tr>
	<td>ISBN</td>
	<td style="vertical-align: top;">
	<input name="ISBN" type="text" value=<%=ISBN %> readonly> </td>
</tr>

<tr>
	<td>書名</td>
    <td style="vertical-align: top;">
	<input name="BName" type="text" value=<%=BName %> readonly> </td>
</tr>

<tr>
	<td>類別</td>
    <td style="vertical-align: top;">
	<input name="BName" type="text" value=<%=bookClass %> readonly> </td>
</tr>
<tr>
	<td>作者</td>
    <td style="vertical-align: top;">
	<input name="author" type="text" value=<%=author %> readonly> </td>
</tr>
<tr>
	<td>出版社</td>
    <td style="vertical-align: top;">
	<input name="press" type="text" value=<%=press %> readonly> </td>
</tr>
<tr>
	<td>庫存</td>
    <td style="vertical-align: top;">
	<input name="stock" type="text" value=<%=stock %> readonly> </td>
</tr>
<tr>
	<td>出版年份</td>
    <td style="vertical-align: top;">
	<input name="release_date" type="text" value=<%=release_date %> readonly> </td>
</tr>
<tr>
	<td>簡介</td>
	<td>
		<textarea rows="10" cols="50" name=book_introduction readonly><%=book_introduction %></textarea>
	</td>	
</tr>
<tr>
	<td></td>
	<td><input type ="button" onclick="history.back()" value="上一頁"></input></td>
</tr>
</tbody>
</table>
<br>	
</body>
</html>