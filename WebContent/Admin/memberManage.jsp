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
	String orderBy = String.valueOf(request.getParameter("order"));
	//orderBy = new String(orderBy.getBytes("ISO-8859-1"), "UTF-8");
	if(orderBy.equals("null"))
		orderBy="username";
	String keyword = String.valueOf(request.getParameter("keyword"));
	//keyword = new String(keyword.getBytes("ISO-8859-1"), "UTF-8");
	if(keyword.equals("null"))
		keyword="";
%>

<%
	String orderURL = "memberManage.jsp";
	String formString = "<form name='memberManageForm' action='";
	formString += orderURL + "' method='post'>排序";

	out.print(formString);
	out.print("<select name='order'>");
	out.print("<option value='username'>帳號</option>");
	out.print("<option value='register_date'>註冊日期</option>");
	out.print("<option value='name'>姓名</option>");
	out.print("</select>");
	out.print("<input type='text' name='keyword' value=" + keyword + "></input>");
	out.print("<input type='submit' value='GO'></input>使用排序與關鍵字篩選<br>");
	out.print("<input type ='button' onclick=\"javascript:location.href='adminIndex.jsp'\" value='回首頁'></input>");
	out.print("</form>");
%>


	
<%
	String username = "";
	String name = "";
	String sex = "";
	String cell_phone = "";
	String email = "";
	String register_date = "";

	try {
		//String sqlString = "select username, name, sex, cell_phone, email, register_date from account order by ";
		//sqlString += orderBy + ";";	
		String sqlKeyword = "'%" + keyword + "%'";
		String sqlString1 = "select * from (select username, name, sex, cell_phone, email, register_date from account where username like binary " + sqlKeyword + ") as sql1";
		String sqlString2 = "select * from (select username, name, sex, cell_phone, email, register_date from account where name like binary " + sqlKeyword + ") as sql2";
		String sqlString3 = "select * from (select username, name, sex, cell_phone, email, register_date from account where sex like binary " + sqlKeyword + ") as sql3";
		String sqlString4 = "select * from (select username, name, sex, cell_phone, email, register_date from account where cell_phone like binary " + sqlKeyword + ") as sql4";
		String sqlString5 = "select * from (select username, name, sex, cell_phone, email, register_date from account where email like binary " + sqlKeyword + ") as sql5";
		String sqlString6 = "select * from (select username, name, sex, cell_phone, email, register_date from account where register_date like binary " + sqlKeyword + ") as sql6";		
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
		int i = 0;
		//ps.setString(++i, ord);
		ResultSet rs = ps.executeQuery();
		out.print("<table border='1' color='cyan'>");
		out.print("<tr>");
	    out.print("<th width='80'>"+"帳號");
	    out.print("<th width='80'>"+"姓名");
	    out.print("<th width='40'>"+"性別");
	    out.print("<th width='100'>"+"手機號碼");
	    out.print("<th width='200'>"+"電子信箱");
	    out.print("<th width='200'>"+"註冊日期");
	    out.print("<th width='40'>"+"");
	    out.print("<th width='40'>"+"");
	    out.print("</tr>");
		while(rs.next()){
			username = rs.getString(1);
			name = rs.getString(2);
			sex = rs.getString(3);
			cell_phone = rs.getString(4);
			email = rs.getString(5);
			register_date = rs.getString(6);
			out.print("<tr>");
			out.print("<td>"+username+"</td>");
			out.print("<td>"+name+"</td>");
			out.print("<td>"+sex+"</td>");
			out.print("<td>"+cell_phone+"</td>");
			out.print("<td >"+email+"</td>");
			out.print("<td >"+register_date+"</td>");
			out.print("<td><a href='updateAccount.jsp?userID=" + username
					+ "'>修改</a></td>");
			out.print("<td><a href='deleteAccountConfirm.jsp?userID=" + username
						+ "'>刪除</a></td>");
			out.print("</tr>");
		}
		out.print("</table>");
		rs.close();
		ps.close();
		dBConnectionInit.closeConnection();
	}catch (SQLException e) {
		out.print(e.getMessage());
		out.print("Fail to Query!");
		e.printStackTrace();
	}

%>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title>線上書籍借閱系統 - 會員管理</title>

</head>
<body>
</body>
</html>