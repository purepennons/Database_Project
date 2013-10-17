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
	String[] sexValue = {"男", "女"};
	String errorMessage = "";
	String username= String.valueOf(request.getParameter("username"));
	String password= String.valueOf(request.getParameter("password"));
	String passwordCheck= String.valueOf(request.getParameter("passwordCheck"));
	String name= String.valueOf(request.getParameter("name"));
	Integer sex = Integer.parseInt(request.getParameter("sex"));
	String cell_phone= String.valueOf(request.getParameter("cell_phone"));
	String email= String.valueOf(request.getParameter("email"));
	
	session.setAttribute("username", username);
	session.setAttribute("password", password);
	session.setAttribute("name", name);
	session.setAttribute("sex", sex.toString());
	session.setAttribute("cell_phone", cell_phone);
	session.setAttribute("email", email);
	
	if(username == "" 
		|| password == ""
		|| name == ""
		|| cell_phone == ""
		|| email == ""){
		errorMessage = "欄位不可為空值";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;
	}
	else if(username.length() > 10){
		errorMessage = "帳號英文+數字需小於10個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;
	}
	else if(!password.equals(passwordCheck)){
		errorMessage = "密碼不符";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(name.length() > 20){
		errorMessage = "姓名需小於20個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(cell_phone.length() > 10){
		errorMessage = "手機號碼需小於10個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(email.length() > 255){
		errorMessage = "電子信箱需小於255個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;		
	}
	
	try{
		int  num = Integer.parseInt(request.getParameter("cell_phone"));
	}catch(Exception e){
		errorMessage = "手機號碼需小於10個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
		return;	
	}
	
	try {
		String sqlString = "select username from account where username = '";
		sqlString += username + "';";
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		Statement st = dBConnectionInit.getConn().createStatement();
		ResultSet rs = st.executeQuery(sqlString);
		if(rs.next()){ 
			errorMessage = username + "已被使用";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("register.jsp?errorMessage=" + errorMessage );
			return;	
		}
		rs.close();
		st.close();
		dBConnectionInit.closeConnection();
		
	}catch (SQLException e) {
		out.println(e.getMessage());
		e.printStackTrace();
	}	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<!--  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">-->
<title>註冊資料確認頁面</title>
</head>
<body
style="position: absolute; top: 50%; left: 50%; margin-left: -163px; margin-top: -138px;">
<form name="registerConfirmForm" action="accountSQL.jsp" method="post">
<table border="1">
<tbody>
<tr><td><h2><b>確認頁面</b></h2></td></tr>

<tr><td>帳號</td><td><%=username %></td></tr>
<tr><td>密碼</td><td><%=password %></td></tr>
<tr><td>姓名</td><td><%=name %></td></tr>
<tr><td>性別</td><td><%=sexValue[sex] %></td></tr>
<tr><td>手機號碼</td><td><%=cell_phone %></td></tr>
<tr><td>電子信箱</td><td><%=email %></td></tr>
<tr><td>
	<!--  <input type ="button" onclick="javascript:location.href='register.jsp'" value="重新輸入"></input>
	-->
	<input type ="button" onclick="history.back()" value="修改"></input>
	<input type="submit" value="確認送出"></input>
</td></tr>

</tbody>
</table>
</form>
</body>
</html>