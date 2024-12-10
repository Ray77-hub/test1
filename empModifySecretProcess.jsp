<!-- empModifySecretProcess.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
Connection conn = null;
Statement stat = null;
String WK_T0 = request.getParameter("T0");
String WK_T1 = request.getParameter("T1");
String WK_T2 = request.getParameter("T2");
String WK_Command = "";
int WK_Year = 0;
int WK_Month = 0;
int WK_Day = 0;
int WK_Count = 0;
java.util.Date WK_DateNow = new java.util.Date();
SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
String WK_DateTime = ft.format(WK_DateNow);
String WK_CDateTime = "";

try {
	// 取得系統年度轉成民國年度
	WK_Year = Integer.parseInt(WK_DateTime.substring(0, 4)) - 1911;
	WK_CDateTime = WK_Year + WK_DateTime.substring(4, WK_DateTime.length());
} catch(Exception ex) {
}

if(userInformation != null | userInformation.getId() != null && userInformation.getId().trim().length() > 1) {
	WK_Command = "update user set secret_code='" + WK_T1 + "', update_user_uid=" + userInformation.getUid() + ", update_user='" + userInformation.getId() + "', update_datetime='" + WK_CDateTime + "' ";
	WK_Command = WK_Command + "where uid=" + userInformation.getUid() + " and secret_code='" + WK_T0 + "'";
	
	try {
		Class.forName("org.gjt.mm.mysql.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");
		
		if(conn != null) {
			if(WK_T1.equals(WK_T2)) {
				stat = conn.createStatement();
				WK_Count = stat.executeUpdate(WK_Command);
				
				if(WK_Count == 0) {
					out.println("您輸入不正確的舊密碼，無法變更密碼<br>");
				} else {
					out.println("變更密碼完成<br>");
				}
			} else {
				out.println("您輸入的新密碼與新密碼確認不同，無法變更密碼<br>");
			}
			stat = null;
			conn = null;
		} else {
			out.println("變更密碼失敗<br>");
			// out.println("<button class='button' onclick=\"document.location.href='empModifySecret.jsp'\">回變更密碼畫面</button>");
		}
	} catch(Exception ex) {
		out.println(ex + "無法連接資料庫<br>");
		// out.println("<button class='button' onclick=\"document.location.href='empModifySecret.jsp'\">回變更密碼畫面</button>");
	}
} else {
	out.println("請登入系統後再執行本功能。<br>");
}

out.println("<button class='button' onclick=\"document.location.href='empModifySecret.jsp'\">回變更密碼畫面</button>");
%>