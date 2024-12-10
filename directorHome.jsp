<!-- directorHome.jsp -->
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
<body>
<center>
<h2>
職能評核系統
</h2>
<table border=0 width='800px'>
  <tr><td align='right'>陳大炮<br>999年99月99日</td></tr>
</table>
<br>
<jsp:include page="directorMenu.jsp" ></jsp:include>
<br><br>
<form name="FormA" action="A.jsp" method='post'>
<table border=1>
  <caption>待評核名單</caption>
  <tr>
    <td align='center'>項次</td>
	<td align='center'>員工姓名</td>
	<td align='center'>完成日期</td>
	<td align='center'>上傳數量</td>
	<td align='center'>上傳檔案</td>
	<td align='center'></td>
  </tr>
  <tr>
    <td align='center'>1</td>
	<td>洪七公</td>
	<td>999/99/99</td>
	<td align='center'>3</td>
	<td>職務條件, 工作說明, 學歷證明</td>
	<td align='center'><button class="button" onclick="FormA.sumbit();">評核</button></td>
  </tr>
</table>
</form><br>
<table border=1>
  <caption>已評核名單</caption>
  <tr>
    <td align='center'>項次</td>
	<td align='center'>員工姓名</td>
	<td align='center'>完成日期</td>
	<td align='center'>上傳數量</td>
	<td align='center'>上傳檔案</td>
  </tr>
  <tr>
    <td align='center'>1</td>
	<td>洪七公</td>
	<td>999/99/99</td>
	<td align='center'>3</td>
	<td>職務條件, 工作說明, 學歷證明</td>
  </tr>
</table>
</center>
</body>
</html>
