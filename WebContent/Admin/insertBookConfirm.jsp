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
	
	session.setAttribute("ISBN", ISBN);
	session.setAttribute("BName", BName);
	session.setAttribute("bookClass", bookClass);
	session.setAttribute("author", author);
	session.setAttribute("press", press);
	session.setAttribute("stock", stock);
	session.setAttribute("release_date", release_date);
	session.setAttribute("book_introduction", book_introduction);
	
	if(ISBN == "" 
		|| BName == ""
		|| press == ""
		|| stock == ""
		|| release_date == ""){
		errorMessage = "註明'*'的欄位不可為空值";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;
	}
	else if(ISBN.length() > 13){
		errorMessage = "ISBN需小於13個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;
	}
	else if(BName.length() > 20 || press.length() > 20){
		errorMessage = "書名與出版社需小於20個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(author.length() > 10){
		errorMessage = "作者需小於50個字元";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(release_date.length() > 5){
		errorMessage = "出版年份需小於5個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(stock.length() > 3){
		errorMessage = "庫存需小於3個字元且需介於0~255";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;		
	}
	else if(Integer.valueOf(stock)>255 || Integer.valueOf(stock)<0){
		errorMessage = "庫存需小於3個字元且需介於0~255";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;	
	}
	
	try{
		int  num = Integer.parseInt(request.getParameter("release_date"));
	}catch(Exception e){
		errorMessage = "出版年份需小於5個字元且需全為數字";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;	
	}
	try{
		int  num = Integer.parseInt(request.getParameter("stock"));
	}catch(Exception e){
		errorMessage = "庫存需小於3個字元且需介於0~255";
		errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
		response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
		return;	
	}
%>

<%
	
	try {
		String sqlString = "select ISBN from book_information where ISBN = '";
		sqlString += ISBN + "';";
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		Statement st = dBConnectionInit.getConn().createStatement();
		ResultSet rs = st.executeQuery(sqlString);
		if(rs.next()){ 
			errorMessage = ISBN + "已被使用";
			errorMessage = java.net.URLEncoder.encode(errorMessage,"UTF-8");
			response.sendRedirect("insertBookInfo.jsp?errorMessage=" + errorMessage );
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
<title>新增書籍確認頁面</title>
</head>
<body>
<form name="registerConfirmForm" action="insertBookSQL.jsp" method="post">
<table border="1">
<tbody>
<tr><td><h2><b>確認頁面</b></h2></td></tr>

<tr><td>ISBN</td><td><%=ISBN%></td></tr>
<tr><td>書名</td><td><%=BName%></td></tr>
<tr><td>類別</td><td><%=bookClass%></td></tr>
<tr><td>作者</td><td><%=author%></td></tr>
<tr><td>出版社</td><td><%=press%></td></tr>
<tr><td>庫存</td><td><%=stock%></td></tr>
<tr><td>出版日期</td><td><%=release_date%></td></tr>
<tr><td>簡介</td><td><%=book_introduction%></td></tr>
<tr><td>
	<input type ="button" onclick="history.back()" value="修改"></input>
	<input type="submit" value="確認送出"></input>
</td></tr>

</tbody>
</table>
</form>
</body>
</html>