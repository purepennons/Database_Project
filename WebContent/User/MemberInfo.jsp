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
	String errorMessage = String.valueOf(request.getParameter("errorMessage"));
	errorMessage = new String(errorMessage.getBytes("ISO-8859-1"), "UTF-8");
	if(errorMessage.equals("null"))
		errorMessage="";
%>

	
<%

	String sqlString = "select username, name, sex, cell_phone, email from account where username = '";
	sqlString += userID + "';";
	String username = "";
	String name = "";
	String sex = "";
	String cell_phone = "";
	String email = "";

	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		Statement st 
			= dBConnectionInit.getConn().createStatement();
		int i = 0;
		ResultSet rs = st.executeQuery(sqlString);
		while(rs.next()){
			username = rs.getString(1);
			name = rs.getString(2);
			sex = rs.getString(3);
			cell_phone = rs.getString(4);
			email = rs.getString(5);
		}
		rs.close();
		st.close();
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
<title>線上書籍借閱系統 - 會員資料</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->


</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
<form name="memberInfoForm" action="memberInfoUpdate.jsp" method="post">
<table>
<tbody>
<tr><td><h2><b>會員資料</b></h2></td></tr>
<tr>
	<td>帳號</td>
	<td style="vertical-align: top;">
	<input name="username" type="text" value=<%=username%> readonly> </td>
</tr>

<tr>
	<td>原始密碼</td>
    <td style="vertical-align: top;"> 
	<input name="oldPassword" type="password"></td>
</tr>
<tr>
	<td>新密碼</td>
    <td style="vertical-align: top;"> 
	<input name="newPassword" type="password"></td>
</tr>
<tr>
	<td>新密碼確認</td>
    <td style="vertical-align: top;"> 
	<input name="newPasswordCheck" type="password"></td>
</tr>
<tr>
	<td>姓名</td>
    <td style="vertical-align: top;">
	<input name="name" type="text" value=<%=name%> readonly> </td>
</tr>
<tr>
	<td>性別</td>
    <td style="vertical-align: top;">
	<input name="sex" type="text" value=<%=sex%> readonly> </td>
</tr>
<tr>
	<td>手機號碼</td>
    <td style="vertical-align: top;">
	<input name="cell_phone" type="text" value=<%=cell_phone%> > </td>
</tr>
<tr>
	<td>電子信箱</td>
    <td style="vertical-align: top;">
	<input name="email" type="text" value=<%=email%> > </td>
</tr>

<tr>
	<td></td>
	<td><input type ="button" onclick="javascript:location.href='index.jsp'" value="回首頁"></input>
    	<input type="submit" value="修改"></input>
    </td>
</tr>
</tbody>
</table>
<font color="ff0000"><%=errorMessage %></font>
</form>
<br>	
</body>
</html>