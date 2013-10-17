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
	String searchText = String.valueOf(request.getParameter("searchText"));
	if(searchText.equals("")){
		response.sendRedirect("index.jsp");
		return;
	}
	String searchType = String.valueOf(request.getParameter("searchType"));
	String[] category = request.getParameterValues("category[]");
	if(category == null){
		response.sendRedirect("index.jsp");
		return;
	}
%>
	
<%
	String ISBN = "";
	try {		
		String sqlString = "";
		String sqlKeyword = "'%" + searchText + "%'";
		String[] subSqlString = new String[category.length];
		out.print("<input type ='button' onclick=\"javascript:location.href='index.jsp'\" value='回首頁'></input><br>");
		out.print("<h2>搜尋結果：</h2><br>");
		for(int i=0;i<category.length;i++){
			subSqlString[i] = "";
			if(searchType.equals("書名")){
				subSqlString[i] = " select BName, ISBN, class, score, author, press, release_date, stock from book_information where BName like binary " + sqlKeyword + " and class = ";
			}else if(searchType.equals("ISBN")){
				subSqlString[i] = " select BName, ISBN, class, score, author, press, release_date, stock from book_information where ISBN like binary " + sqlKeyword + " and class = ";
			}else if(searchType.equals("作者")){
				subSqlString[i] = " select BName, ISBN, class, score, author, press, release_date, stock from book_information where author like binary " + sqlKeyword + " and class = ";
			}else if(searchType.equals("出版社")){
				subSqlString[i] = " select BName, ISBN, class, score, author, press, release_date, stock from book_information where press like binary " + sqlKeyword + " and class = ";
			}else if(searchType.equals("年份")){
				subSqlString[i] = " select BName, ISBN, class, score, author, press, release_date, stock from book_information where release_date like binary " + sqlKeyword + " and class = ";
			}	
			
			subSqlString[i] += "'" +  category[i] + "' ";
			if(i == (category.length-1)){
				sqlString += subSqlString[i];
			}
			else{
				sqlString += subSqlString[i] + " union ";
			}
		}
		sqlString += ";";
		boolean nullFlag = false;
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		ResultSet rs = ps.executeQuery();
		while(rs.next()){
			int i = 0;
			out.print("_____________________<br>");
			out.print("書名：" + rs.getString(++i) + " ");
			ISBN = rs.getString(++i);
			out.print("<a href='bookDetail.jsp?ISBN="+ ISBN + "'>(簡介)</a>");
			out.print("<a href='bookReservationConfirm.jsp?ISBN="+ ISBN + "'>(預約)</a><br>");
			out.print("ISBN：" + ISBN + "<br>");
			out.print("類別：" + rs.getString(++i)+ "<br>");
			out.print("分數：" + rs.getString(++i)+ "<br>");
			out.print("作者：" + rs.getString(++i)+ "<br>");
			out.print("出版社：" + rs.getString(++i)+ "<br>");
			out.print("出版年份：" + rs.getString(++i)+ "<br>");
			out.print("庫存：" + rs.getString(++i)+ "<br>");
			out.print("<br>");
			nullFlag = true;
		}
		if(! nullFlag)
			out.print("查無資料<br>");
		rs.close();
		ps.close();
		dBConnectionInit.closeConnection();
	}catch (SQLException e) {
		out.print(e.getMessage());
		out.print("<br>Fail to Query!");
		e.printStackTrace();
	}

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<!-- TemplateBeginEditable name="doctitle" -->
<title>線上書籍借閱系統 - 查詢</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->


</head>
<body>
</body>
</html>