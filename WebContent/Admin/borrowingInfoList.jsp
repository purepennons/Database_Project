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
	String keyword = String.valueOf(request.getParameter("keyword"));
	if(keyword.equals("null"))
		keyword="";
	String keywordType = String.valueOf(request.getParameter("keywordType"));
	if(keywordType.equals("null"))
		keywordType="";
%>

<%
	String orderURL = "borrowingInfoList.jsp";
	String formString = "<form name='borrowingInfoListForm' action='";
	formString += orderURL + "' method='post'>狀態篩選 ";

	out.print(formString);
	out.print("<select name='listBy'>");
	out.print("<option value='全部' selected >全部</option>");
	out.print("<option value='已逾期'>已逾期</option>");
	out.print("<option value='已預約'>已預約</option>");
	out.print("<option value='已歸還'>已歸還</option>");
	out.print("<option value='借閱中'>借閱中</option>");
	out.print("<option value='取消預約'>取消預約</option>");
	out.print("</select>");
	out.print(" 查詢項目 <select name='keywordType'>");
	out.print("<option value='帳號' selected >帳號</option>");
	out.print("<option value='姓名'>姓名</option>");
	out.print("<option value='ISBN'>ISBN</option>");
	out.print("<option value='書名'>書名</option>");
	out.print("</select>");
	out.print("<input type='text' name='keyword' value=" + keyword + "></input>");
	out.print("<input type='submit' value='GO'></input>使用書籍狀態與關鍵字篩選<br>");
	out.print("<input type ='button' onclick=\"javascript:location.href='adminIndex.jsp'\" value='回首頁'></input>");
	out.print("</form>");
%>


	
<%
	String ISBN = "";
	String bookName = "";
	String username = userID;
	String name = "";
	String starting_day = "";
	String due_day = "";
	String state = "";

	try {
		String sqlKeyword = "'%" + keyword + "%'";
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
		
		if(keywordType.equals("帳號")){
			subSqlString += " and T1.username like binary" + sqlKeyword;
		}else if(keywordType.equals("姓名")){
			subSqlString += " and T1.name like binary" + sqlKeyword;
		}else if(keywordType.equals("ISBN")){
			subSqlString += " and T3.ISBN like binary" + sqlKeyword;
		}else if(keywordType.equals("書名")){
			subSqlString += " and T3.BName like binary " + sqlKeyword;
		}
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

<title>線上書籍借閱系統 - 借閱紀錄</title>

</head>
<body>
</body>
</html>