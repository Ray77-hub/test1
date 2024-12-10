<!-- empModifySecret.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
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
  <jsp:include page="menuHead.jsp" ></jsp:include>
</head>
<SCRIPT language=JavaScript>
<!--
function FormSubmit() {
	if(document.getElementById('T0').value.trim().length < 1) {
		alert('您必須輸入舊密碼。');
 		document.getElementById('T0').focus();
	} else if(document.getElementById('T1').value.trim().length < 1) {
		alert('您必須輸入新密碼。');
		document.getElementById('T1').focus();
	} else if(document.getElementById('T2').value.trim().length < 1) {
		alert('您必須輸入新密碼確認。');
		document.getElementById('T2').focus();
	} else {
		FormA.action="empModifySecretProcess.jsp";
		FormA.submit();
	}
}
//-->
</SCRIPT>
<body>
<center>
<h2>
職能評核系統
</h2>
<table border=1>
  <tr><td bgcolor='#96D4D4' align='center'>單位</td><td><%=userInformation.getDepartmentName()%></td><td bgcolor='#96D4D4' align='center'>姓名</td><td><%=userInformation.getName()%></td><td bgcolor='#96D4D4' align='center'>到職日期</td><td><%=userInformation.getStartDate()%></td></tr>
  <tr><td bgcolor='#96D4D4' align='center'>評核職務</td><td><%=userInformation.getPositionName()%></td><td bgcolor='#96D4D4' align='center'>職務分級</td><td><%=userInformation.getLevelName()%></td><td bgcolor='#96D4D4' align='center'>學歷</td><td><%=userInformation.getEducationName()%></td></tr>
</table><br>
<%
String WK_Menu = "empMenu.jsp";
if(userInformation.getRole().equals("HR")) {
	WK_Menu = "hrMenu.jsp";
} else if(userInformation.getRole().equals("DM")) {
	WK_Menu = "directorMenu.jsp";
}
%>
<jsp:include page="<%=WK_Menu%>" ></jsp:include>
<br><br>
<%
if(userInformation != null && userInformation.getId() != null && userInformation.getId().trim().length() > 1) {
	out.println("<form name='FormA' method='post'>");
	out.println("<table>");
	out.println("  <tr><td>　　舊密碼：<input name='T0' type='password' id='T0' tabindex='0' size='20' maxlength='20' placeholder='舊密碼'></td></tr>");
	out.println("  <tr><td>　　新密碼：<input name='T1' type='password' id='T1' tabindex='1' size='20' maxlength='20' placeholder='新密碼'></td></tr>");
	out.println("  <tr><td>新密碼確認：<input name='T2' type='password' id='T2' tabindex='2' size='20' maxlength='20' placeholder='新密碼確認'></td></tr>");
	out.println("  <tr><td><center><br><button class='button' onclick='FormSubmit();'>變更密碼</button>　<input type='reset' value='重新輸入'></center></td></tr>");
	out.println("</table>");
	out.println("</form>");
} else {
	out.println("請登入系統後再執行本功能。<br>");
	out.println("<button class='button' onclick=\"document.location.href='login.jsp'\">回登入畫面</button>");
}
%>
</center>
</body>
</html>
