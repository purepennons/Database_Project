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
	String userID =  String.valueOf(request.getParameter("userID"));
	String passWD = String.valueOf(request.getParameter("passWD"));
	String accountClass = String.valueOf(request.getParameter("accountClass"));
	String errorMessage = "";
	String accountTable = "";
	if(userID == "" || passWD == "" || userID.length()>10){
		errorMessage = "欄位為空值或帳號大於10字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect(addressBase +"index.jsp?errorMessage="+ errorMessage);
		return;
	}
	
	if(accountClass.equals("member"))
		accountTable = "account";
	else
		accountTable = "administrator";
	
	String sqlString = "select username from ";
	sqlString = sqlString + accountTable +" where username = ? and password = ?;";	
	
	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);

		int i = 0;
		ps.setString(++i, userID);
		ps.setString(++i, EncryptBean.encrypt(passWD));
		ResultSet rs = ps.executeQuery();
		if(rs.next()){ 
			Prof userSession = new Prof();
			userSession.setId(rs.getString(1));
			session.setAttribute("userSession", userSession);
			session.setAttribute("accountClass", accountClass);
			rs.close();
			ps.clearParameters();
			ps.close();
			dBConnectionInit.closeConnection();
			if(accountClass.equals("member"))
				response.setHeader("refresh","1;URL=http://114.33.179.243:8080/Database_Project/User/index.jsp");
			else
				response.setHeader("refresh","1;URL=http://114.33.179.243:8080/Database_Project/Admin/adminIndex.jsp");	
		}
		else{
			errorMessage = "帳號或密碼錯誤";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			rs.close();
			ps.clearParameters();
			ps.close();
			dBConnectionInit.closeConnection();
			response.setHeader("refresh","1;URL=http://114.33.179.243:8080/Database_Project/index.jsp?errorMessage="+ errorMessage);
		}
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
<title>登入認證中</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->
</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
<form name="loginCheckForm">
<table>
<tbody>
	<tr><td><h1><b>Waiting...</b></h1></td></tr>
</tbody>
</table>
</form>
<br>
</body>
</html>