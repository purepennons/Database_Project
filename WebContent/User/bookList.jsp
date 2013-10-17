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
	session.removeAttribute("ISBN");
	session.removeAttribute("BName");
	session.removeAttribute("bookClass");
	session.removeAttribute("author");
	session.removeAttribute("press");
	session.removeAttribute("stock");
	session.removeAttribute("release_date");
	session.removeAttribute("book_introduction");
%>

<%
	String orderBy = String.valueOf(request.getParameter("order"));
	String keyword = String.valueOf(request.getParameter("keyword"));
	//orderBy = new String(orderBy.getBytes("ISO-8859-1"), "UTF-8");
	if(orderBy.equals("null"))
		orderBy="ISBN";
	//keyword = new String(keyword.getBytes("ISO-8859-1"), "UTF-8");
	if(keyword.equals("null"))
		keyword="";
%>

<%
	String orderURL = "bookList.jsp";
	String formString = "<form name='bookListForm' action='";
	formString += orderURL + "' method='post'>排序";

	out.print(formString);
	out.print("<select name='order'>");
	out.print("<option value='ISBN'>ISBN</option>");
	out.print("<option value='author'>作者</option>");
	out.print("<option value='press'>出版社</option>");
	out.print("<option value='release_date'>年份</option>");
	out.print("<option value='class'>類別</option>");
	out.print("<option value='score'>分數</option>");
	out.print("<option value='times'>借閱次數</option>");
	out.print("</select>");
	out.print("<input type='text' name='keyword' value=" + keyword + "></input>");
	out.print("<input type='submit' value='GO'></input>使用排序與關鍵字篩選<br>");
	out.print("<input type ='button' onclick=\"javascript:location.href='index.jsp'\" value='回首頁'></input>");
	out.print("</form>");
%>
	
<%
	String ISBN = "";
	String BName = "";
	String bookClass = "";
	String author = "";
	String press = "";
	String score = "";
	String stock = "";
	String times = "";
	String release_date = "";

	try {
		//String sqlString = "select ISBN, BName, class, author, press, score, stock, times, release_date from book_information order by ";
		//String sqlString = "select * from book_information order by ";
		//sqlString += orderBy + ";";	
		String sqlKeyword = "'%" + keyword + "%'";
		String sqlString1 = "select * from (select * from book_information where ISBN like " + sqlKeyword + ") as sql1";
		String sqlString2 = "select * from (select * from book_information where BName like " + sqlKeyword + ") as sql2";
		String sqlString3 = "select * from (select * from book_information where author like " + sqlKeyword + ") as sql3";
		String sqlString4 = "select * from (select * from book_information where press like " + sqlKeyword + ") as sql4";
		String sqlString5 = "select * from (select * from book_information where release_date like " + sqlKeyword + ") as sql5";
		String sqlString6 = "select * from (select * from book_information where class like " + sqlKeyword + ") as sql6";		
		String sqlString = sqlString1 + " union "
							+ sqlString2 + " union "
							+ sqlString3 + " union "
							+ sqlString4 + " union "
							+ sqlString5 + " union "
							+ sqlString6 + " order by ";
		sqlString += orderBy + ";";
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		ResultSet rs = ps.executeQuery();
		out.print("<table border='1' color='cyan'>");
		out.print("<tr>");
	    out.print("<th width='100'>"+"ISBN");
	    out.print("<th width='100'>"+"書名");
	    out.print("<th width='40'>"+"類別");
	    out.print("<th width='200'>"+"作者");
	    out.print("<th width='200'>"+"出版社");
	    out.print("<th width='40'>"+"分數");
	    out.print("<th width='40'>"+"庫存");
	    out.print("<th width='80'>"+"借閱次數");
	    out.print("<th width='80'>"+"出版年份");
	    out.print("<th width='40'>"+"");
	    out.print("</tr>");
		while(rs.next()){
			int i=0;
			ISBN = rs.getString(++i);
			BName = rs.getString(++i);
			bookClass = rs.getString(++i);
			author = rs.getString(++i);
			press = rs.getString(++i);
			score = rs.getString(++i);
			stock = rs.getString(++i);
			times = rs.getString(++i);
			release_date = rs.getString(++i);
			out.print("<tr>");
			out.print("<td>"+ISBN+"</td>");
			out.print("<td>"+BName+"</td>");
			out.print("<td>"+bookClass+"</td>");
			out.print("<td>"+author+"</td>");
			out.print("<td >"+press+"</td>");
			out.print("<td >"+score+"</td>");
			out.print("<td >"+stock+"</td>");
			out.print("<td >"+times+"</td>");
			out.print("<td >"+release_date+"</td>");
			out.print("<td><a href='bookDetail.jsp?ISBN=" + ISBN
					+ "'>簡介</a></td>");
			out.print("</tr>");
		}
		out.print("</table>");
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
<title>線上書籍借閱系統 - 書籍清單</title>
<!-- TemplateEndEditable -->
<!-- TemplateBeginEditable name="head" -->
<!-- TemplateEndEditable -->


</head>
<body>
</body>
</html>