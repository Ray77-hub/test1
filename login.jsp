<!-- login.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.util.*" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
%>
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="initial-scale=1.0">
  <title>職能評核系統</title>
</head>

<body ontouchstart="" style="background-color:#EBEBEB" background="picture\BG-1280.png" bgproperties=fixed>
<center>
<h2>
職能評核系統
</h2>
<br><br>
<%
if(userInformation.getErrorCounter() < 3) {
	out.println("<form name='FormA' action='loginProcess.jsp' method='post'>");
	out.println("<table>");
	out.println("  <tr><td>工號：<input name='T0' type='text' id='T0' tabindex='0' size='20' maxlength='20'></td></tr>");
	out.println("  <tr><td>密碼：<input name='T1' type='password' id='T1' tabindex='1' size='20' maxlength='20'></td></tr>");
	out.println("  <tr><td><center><br><button class='button' onclick='FormA.sumbit();'>登入</button>　<input type='reset' value='重新輸入'></center></td></tr>");
	out.println("</table>");
	out.println("</form>");
} else {
	out.println("您登入錯誤次數超過3次，無法再登入系統。");
}
%>
</center>
</body>
</html>
