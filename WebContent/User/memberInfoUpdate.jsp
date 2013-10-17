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
	String errorMessage = "";
	String username = String.valueOf(request.getParameter("username"));
	String oldPassword = String.valueOf(request.getParameter("oldPassword"));
	String newPassword = String.valueOf(request.getParameter("newPassword"));
	String newPasswordCheck = String.valueOf(request.getParameter("newPasswordCheck"));
	String cell_phone = String.valueOf(request.getParameter("cell_phone"));
	String email = String.valueOf(request.getParameter("email"));
	
	if(oldPassword == ""
			|| newPassword == ""
			|| newPasswordCheck == ""
			|| cell_phone == ""
			|| email == ""){
			errorMessage = "欄位不可為空值";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("MemberInfo.jsp?errorMessage=" + errorMessage );
			return;
		}
		else if(!newPassword.equals(newPasswordCheck)){
			errorMessage = "密碼不符";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("MemberInfo.jsp?errorMessage=" + errorMessage );
			return;		
		}
		else if(cell_phone.length() > 10){
			errorMessage = "手機號碼需小於10個字元且須全為數字";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("MemberInfo.jsp?errorMessage=" + errorMessage );
			return;		
		}
		else if(email.length() > 255){
			errorMessage = "電子信箱需小於255個字元且須全為數字";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("MemberInfo.jsp?errorMessage=" + errorMessage );
			return;		
		}
		
		try{
			int  num = Integer.parseInt(request.getParameter("cell_phone"));
		}catch(Exception e){
			errorMessage = "手機號碼需小於10個字元且須全為數字";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("MemberInfo.jsp?errorMessage=" + errorMessage );
			return;	
		}
%>	

<%	
	String sqlString1 = "select username from account where username = ? and password = ?;";	
	String sqlString2 = "update account set password = MD5(?), cell_phone = ?, email = ? where username = ?;";
	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps1 
			= dBConnectionInit.getConn().prepareStatement(sqlString1);

		int i = 0;
		ps1.setString(++i, username);
		ps1.setString(++i, EncryptBean.encrypt(oldPassword));
		ResultSet rs1 = ps1.executeQuery();
		if(rs1.next()){ 
			PreparedStatement ps2
				= dBConnectionInit.getConn().prepareStatement(sqlString2);
			int j = 0;
			ps2.setString(++j, newPassword);
			ps2.setString(++j, cell_phone);
			ps2.setString(++j, email);
			ps2.setString(++j, username);
			ps2.executeUpdate();
			ps2.clearParameters();
			ps2.close();
			rs1.close();
			ps1.clearParameters();
			ps1.close();
			dBConnectionInit.closeConnection();
			out.print("更新成功!系統將於3秒後跳轉回剛所在頁面...");
			response.setHeader("refresh","3;URL=MemberInfo.jsp");
		}
		else{
			errorMessage = "原始密碼錯誤";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			rs1.close();
			ps1.clearParameters();
			ps1.close();
			dBConnectionInit.closeConnection();
			response.sendRedirect("MemberInfo.jsp?errorMessage=" + errorMessage );
			return;		
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
<title>線上書籍借閱系統</title>
</head>

<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
</body>

</html>
