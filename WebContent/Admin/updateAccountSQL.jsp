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
	String errorMessage = "";
	String username = String.valueOf(request.getParameter("username"));
	String newPassword = String.valueOf(request.getParameter("newPassword"));
	String newPasswordCheck = String.valueOf(request.getParameter("newPasswordCheck"));
	String name = String.valueOf(request.getParameter("name"));
	String sex = String.valueOf(request.getParameter("sex"));
	String cell_phone = String.valueOf(request.getParameter("cell_phone"));
	String email = String.valueOf(request.getParameter("email"));
	
	if(name == "" || sex == "" || cell_phone == "" || email == ""){
			errorMessage = "除密碼欄外，欄位不可為空值";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("updateAccount.jsp?userID="+ username + "&errorMessage=" + errorMessage);
			return;
	}
	else if(!newPassword.equals(newPasswordCheck)){
		errorMessage = "密碼不符";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateAccount.jsp?userID="+ username + "&errorMessage=" + errorMessage);
		return;		
	}
	else if(!sex.equals("M") && !sex.equals("F")){
		errorMessage = "性別欄位只可為'M'或'F'";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateAccount.jsp?userID="+ username + "&errorMessage=" + errorMessage);
		return;	
	}
	else if(cell_phone.length() > 10){
		errorMessage = "手機號碼需小於10個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateAccount.jsp?userID="+ username + "&errorMessage=" + errorMessage);
		return;		
	}
	else if(email.length() > 255){
		errorMessage = "電子信箱需小於255個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateAccount.jsp?userID="+ username + "&errorMessage=" + errorMessage);
		return;		
	}
	
	try{
		int  num = Integer.parseInt(request.getParameter("cell_phone"));
	}catch(Exception e){
		errorMessage = "手機號碼需小於10個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateAccount.jsp?userID="+ username + "&errorMessage=" + errorMessage);
		return;	
	}
%>	
<%	
	String sqlString = "";
	if(!newPassword.equals("")){
		sqlString = "update account set password = MD5(?), name = ?, sex = ?, cell_phone = ?, email = ? where username = ?;";
	}
	else{
		sqlString = "update account set name = ?, sex = ?, cell_phone = ?, email = ? where username = ?;";
	}

	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		int i = 0;
			PreparedStatement ps2
				= dBConnectionInit.getConn().prepareStatement(sqlString);
			int j = 0;
			if(!newPassword.equals(""))
				ps2.setString(++j, newPassword);
			ps2.setString(++j, name);
			ps2.setString(++j, sex);
			ps2.setString(++j, cell_phone);
			ps2.setString(++j, email);
			ps2.setString(++j, username);
			ps2.executeUpdate();
			ps2.clearParameters();
			ps2.close();
			dBConnectionInit.closeConnection();
			response.setHeader("refresh","1;URL=updateAccount.jsp?userID="+ username);
	}catch (SQLException e) {
		out.println(e.getMessage());
		e.printStackTrace();
	}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>線上書籍借閱系統 - 修改會員</title>
</head>

<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
</body>

</html>
