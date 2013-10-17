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
	String ISBN = String.valueOf(request.getParameter("ISBN"));
	String BName = String.valueOf(request.getParameter("BName"));
	String bookClass = String.valueOf(request.getParameter("bookClass"));
	String author = String.valueOf(request.getParameter("author"));
	String press = String.valueOf(request.getParameter("press"));
	String stock = String.valueOf(request.getParameter("stock"));
	String release_date = String.valueOf(request.getParameter("release_date"));
	String book_introduction = String.valueOf(request.getParameter("book_introduction"));
	book_introduction = book_introduction.replace("\r\n", "<br>");
	if( BName == ""
		|| press == ""
		|| stock == ""
		|| release_date == ""){
		errorMessage = "註明'*'的欄位不可為空值";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;
	}
	else if(BName.length() > 20 || press.length() > 20){
		errorMessage = "書名與出版社需小於20個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;		
	}
	else if(author.length() > 10){
		errorMessage = "作者需小於50個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;		
	}
	else if(release_date.length() > 5){
		errorMessage = "出版年份需小於5個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;		
	}
	else if(stock.length() > 3){
		errorMessage = "庫存需小於3個字元且需小於256";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;		
	}
	
	try{
		int  num = Integer.parseInt(request.getParameter("release_date"));
	}catch(Exception e){
		errorMessage = "出版年份需小於5個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;	
	}
	try{
		int  num = Integer.parseInt(request.getParameter("stock"));
	}catch(Exception e){
		errorMessage = "庫存需小於3個字元且需小於256";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;	
	}
	
	if(Integer.valueOf(stock)>255){
		errorMessage = "庫存需小於3個字元且需小於256";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("updateBookInfo.jsp?ISBN="+ ISBN + "&errorMessage=" + errorMessage);
		return;	
	}
%>	
<%	
	String sqlString1 = "update book_information set BName = ?, class = ?, author = ?, press = ?, stock = ?, release_date = ? where ISBN = ?;";
	String sqlString2 = "update book_introduction set content = ? where ISBN = ?;";


	try {
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		int i = 0, j = 0;
			PreparedStatement ps1
				= dBConnectionInit.getConn().prepareStatement(sqlString1);
			PreparedStatement ps2
			= dBConnectionInit.getConn().prepareStatement(sqlString2);
			ps1.setString(++i, BName);
			ps1.setString(++i, bookClass);
			ps1.setString(++i, author);
			ps1.setString(++i, press);
			ps1.setString(++i, stock);
			ps1.setString(++i, release_date);
			ps1.setString(++i, ISBN	);
			ps2.setString(++j, book_introduction);
			ps2.setString(++j, ISBN);
			ps1.executeUpdate();
			ps2.executeUpdate();
			ps1.clearParameters();
			ps2.clearParameters();
			ps1.close();
			ps2.close();
			dBConnectionInit.closeConnection();
			response.setHeader("refresh","1;URL=updateBookInfo.jsp?ISBN=" + ISBN);
	}catch (SQLException e) {
		out.println(e.getMessage());
		e.printStackTrace();
	}

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>線上書籍借閱系統 - 修改書籍</title>
</head>

<body>
</body>

</html>
