<!-- loginProcess.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
Connection conn = null;
Statement stat = null;
ResultSet rs = null;
String WK_T0 = request.getParameter("T0");
String WK_T1 = request.getParameter("T1");
String WK_Command = "select * from user, employee where user.id='" + WK_T0 + "' AND user.secret_code='" + WK_T1 + "' AND user.uid=employee.user_uid";
java.util.Date WK_DateNow = new java.util.Date();
SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
String WK_DateTime = ft.format(WK_DateNow);
int WK_Year = 0;

try {
	// 取得系統年度轉成民國年度
	WK_Year = Integer.parseInt(WK_DateTime.substring(0, 4)) - 1911;
} catch(Exception ex) {
}

if(userInformation.getErrorCounter() > 3) {
	response.sendRedirect("login.jsp");
} else {
	try {
		Class.forName("org.gjt.mm.mysql.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");
		
		if(conn != null) {
			stat = conn.createStatement();
			rs = stat.executeQuery(WK_Command);
			if(rs.next()) {
				userInformation.setUid(rs.getInt("user.uid"));  // 使用者系統唯一識別碼
				userInformation.setId(rs.getString("user.id"));  // 使用者帳號
				userInformation.setName(rs.getString("user.name"));  // 使用者名稱
				userInformation.setType(rs.getString("user.type"));  // 使用者類別
				userInformation.setRole(rs.getString("user.role"));  // 使用者角色
				userInformation.setDepartmentId(rs.getString("employee.department_id"));  // 所屬部門代號
				userInformation.setDepartmentName(rs.getString("employee.department_name"));  // 所屬部門名稱
				userInformation.setLoginDatetime(WK_DateTime);  // 登入日期時間
				userInformation.setCDate((WK_Year) + "年" + WK_DateTime.substring(4, 6) + "月" + WK_DateTime.substring(6, 8) + "日");  // 民國年月日
				userInformation.setPositionId(rs.getString("employee.job_id"));  // 職務代號
				userInformation.setPositionName(rs.getString("employee.job_name"));  // 職務名稱
				userInformation.setLevelId(rs.getString("employee.job_class_id"));  // 職務分級代號
				userInformation.setLevelName(rs.getString("employee.job_class_name"));  // 職務分級名稱
				userInformation.setEducationId(rs.getString("employee.education_id"));  // 學歷代號
				userInformation.setEducationName(rs.getString("employee.education_name"));  // 學歷名稱
				userInformation.setStartDate(rs.getString("employee.start_date"));  // 到職日期
				userInformation.setYear(rs.getString("employee.year"));  // 本次職能評核年度
				userInformation.setItem(rs.getString("employee.item"));  // 本次職能評核序號
				userInformation.setStatus(rs.getString("employee.status"));  // 本次是否需要評核方式
				response.sendRedirect("empHome.jsp");
			} else {
				userInformation.setErrorCounter(userInformation.getErrorCounter() + 1);
				out.println("您輸入的帳號或密碼錯誤,請再確認一下。<br>");
				out.println("<button class='button' onclick=\"document.location.href='login.jsp'\">回登入畫面</button>");
			}
			
			rs = null;
			stat = null;
			conn = null;
		} else {
			out.println("無法與資料庫連線。<br>");
			out.println("<button class='button' onclick=\"document.location.href='login.jsp'\">回登入畫面</button>");
		}
	} catch(Exception ex) {
		out.println(ex + "無法連接資料庫。<br>");
		out.println("<button class='button' onclick=\"document.location.href='login.jsp'\">回登入畫面</button>");
	}
}
%>