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
	String listBy = String.valueOf(request.getParameter("listBy"));
	if(listBy.equals("null"))
		listBy="全部";
	String ISBN = String.valueOf(request.getParameter("ISBN"));
	if(ISBN.equals("null"))
		ISBN="";
	String username = String.valueOf(request.getParameter("username"));
	if(username.equals("null"))
		username="";
	out.print(ISBN + "   " + username);
	try{
		String sISBN, sUsername, sListBy;
		sISBN = (String)session.getAttribute("sessionISBN");
		sUsername = (String)session.getAttribute("sessionUsername");
		sListBy = (String)session.getAttribute("sessionListBy");
		if(!sISBN.equals("null"))
			ISBN =sISBN;
		if(!sUsername.equals("null"))
			username = sUsername;
		if(!sListBy.equals("null"))
			listBy = sListBy;
	}catch (NullPointerException e){
	}

	session.removeAttribute("sessionISBN");
	session.removeAttribute("sessionUsername");
	session.removeAttribute("sessionListBy");


%>

<%
	
	String orderURL = "borrowReturnBookSQL.jsp?";
	String formString = "<form name='borrowReturnBookForm' action='";
	formString += orderURL + "' method='post'>狀態篩選：";

	out.print(formString);
	out.print("<select name='listBy'>");
	out.print("<option value='全部' selected >全部</option>");
	out.print("<option value='已逾期'>已逾期</option>");
	out.print("<option value='已預約'>已預約</option>");
	out.print("<option value='已歸還'>已歸還</option>");
	out.print("<option value='借閱中'>借閱中</option>");
	out.print("<option value='取消預約'>取消預約</option>");
	out.print("</select>");
	out.print(" ISBN：<input type='text' name='ISBN' value=" + ISBN + "></input>");
	out.print(" 帳號：<input type='text' name='username' value=" + username + "></input>");
	out.print("<input type='submit' value='借還書'>(或借閱資料)</input><br>");
	out.print("<input type ='button' onclick=\"javascript:location.href='adminIndex.jsp'\" value='回首頁'></input>");
	out.print("</form>");
%>

	
<%
	String bookName = "";
	String name = "";
	String starting_day = "";
	String due_day = "";
	String state = "";

	try {
		String subSqlString1 = "select T2.idpass, T2.BISBN, T3.BName, T2.bUsername, T1.name, T2.starting_day, T2.due_day, T2.state ";
		String subSqlString2 = " from account T1, borrowing_information T2, book_information T3 ";
		String subSqlString3 = " where T2.BISBN = T3.ISBN and T2.bUsername = T1.username ";
		String subSqlString = "";
		String sqlString = "";
		if(!listBy.equals("全部")){
			subSqlString = subSqlString1 + subSqlString2 + subSqlString3 + "and T2.state = '" + listBy + "' ";
		}
		else{
			subSqlString = subSqlString1 + subSqlString2 + subSqlString3;
		}
		subSqlString += " and T1.username ='" + username + "'";
		sqlString = subSqlString + " order by starting_day;";
		DBConnectionInit dBConnectionInit = new DBConnectionInit();
		PreparedStatement ps 
			= dBConnectionInit.getConn().prepareStatement(sqlString);
		ResultSet rs = ps.executeQuery();
		out.print("<table border='1' color='cyan'>");
		out.print("<tr>");
	    out.print("<th width='120'>"+"ISBN");
	    out.print("<th width='200'>"+"書名");
	    out.print("<th width='80'>"+"帳號");
	    out.print("<th width='100'>"+"借閱人");
	    out.print("<th width='100'>"+"起始日期");
	    out.print("<th width='100'>"+"截止日期");
	    out.print("<th width='80'>"+"書籍狀態");
	    out.print("</tr>");
		while(rs.next()){
			int i=1;
			ISBN = rs.getString(++i);
			bookName = rs.getString(++i);
			username = rs.getString(++i);
			name = rs.getString(++i);
			starting_day = rs.getString(++i);
			due_day = rs.getString(++i);
			state = rs.getString(++i);
			out.print("<tr>");
			out.print("<td>"+ISBN+"</td>");
			out.print("<td>"+bookName+"</td>");
			out.print("<td>"+username+"</td>");
			out.print("<td>"+name+"</td>");
			out.print("<td >"+starting_day+"</td>");
			out.print("<td >"+due_day+"</td>");
			out.print("<td >"+state+"</td>");
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

<title>線上書籍借閱系統 - 借書還書</title>

</head>
<body>
</body>
</html>