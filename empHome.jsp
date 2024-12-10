<!-- empHome.jsp -->
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
String WK_StartDate = "";
String WK_EndDate = "";
String WK_Command = "select * from competency_assessment_period where status='Y'";
String WK_Cdate = "";
int WK_Year = 0;
int WK_StartDate1 = 0;
int WK_EndDate1 = 0;
int WK_Cdate1 = 0;
String WK_TemplatePath = request.getRealPath("/template") + "/";   // 職務評核表樣板檔案的資料夾
String WK_DocumentPath = request.getRealPath("/document") + "/";   // 存放產生職務評核表PDF檔的資料夾
String WK_PdfLink = "/document/" + userInformation.getId();
try {
	// 取得登入日期時間之年度轉成民國年度
	WK_Year = Integer.parseInt(userInformation.getLoginDatetime().substring(0, 4)) - 1911;
	WK_Cdate = WK_Year + userInformation.getLoginDatetime().substring(4, 8);
	WK_Cdate1 = Integer.parseInt(WK_Cdate);
} catch(Exception ex) {
}

// 檢查該員工的資料夾是否存在,若不存在則自動建立
WK_DocumentPath = WK_DocumentPath + "/" + userInformation.getId();
File d = new File(WK_DocumentPath); 
if(! d.exists()){
	d.mkdir(); //建立Sub目錄
}

try {
	Class.forName("org.gjt.mm.mysql.Driver");
	conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");
	
	if(conn != null) {
		stat = conn.createStatement();
		rs = stat.executeQuery(WK_Command);
		if(rs.next()) {
			WK_StartDate = rs.getString("start_date");
			WK_EndDate = rs.getString("end_date");
			WK_StartDate1 = Integer.parseInt(WK_StartDate);
			WK_EndDate1 = Integer.parseInt(WK_EndDate);
		} else {
			out.println("沒有資料");
		}
	} else {
		out.println("沒有資料");
	}
} catch(Exception ex) {
	out.println(ex + "無法連接資料庫");
}
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
	if(document.getElementById('R1').checked) {
		alert('您選擇的是申請評核。');
		FormA.action="empJoin.jsp";
		FormA.submit();
	} else if(document.getElementById('R2').checked) {
		alert('您選擇的是放棄評核。');
		FormA.action="empGiveupProcess.jsp";
		FormA.submit();
	} else {
		alert('請選擇申請評或是放棄評核。');
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
<table border=0>
  <tr><td>
<%
// 職務評核表的檔名組成：評核年度+評核梯次+員工代號+職務評核表單代號+".pdf"
String WK_FileName = userInformation.getYear() + userInformation.getItem() + userInformation.getId() + "HR40E.pdf";
WK_PdfLink = WK_PdfLink + "/" + WK_FileName;

// 檢查該員工是否已產生過職務評核表,若不存在則出現是否參加職務評核的選項, 存在則出現下載連結
File f=new File(WK_DocumentPath , WK_FileName);
if(! f.exists()){  //檢查File.txt是否存在
	if(userInformation.getStatus().equals("Y") && WK_Cdate1 >= WK_StartDate1 && WK_Cdate1 <= WK_EndDate1) {
		out.println("<form name='FormA' method='post'>");
		out.println("本次申請職能評核期間：" + WK_StartDate.substring(0, 3) + "年" + WK_StartDate.substring(3, 5) + "月" + WK_StartDate.substring(5, 7) + "日開始" + WK_EndDate.substring(0, 3) + "年" + WK_EndDate.substring(3, 5) + "月" + WK_EndDate.substring(5, 7) + "日結束<br>");
		out.println("是否申請本次職能評核？");
		out.println("<input type='radio' id='R1' name='choose' value='R1'>申請評核<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;");
		out.println("<input type='radio' id='R2' name='choose' value='R2'>放棄評核");
		out.println("<button class='button' onclick='FormSubmit();'>確定送出</button>");
		out.println("</form>");
	}
} else {
	out.println("本次申請職能評核期間：" + WK_StartDate.substring(0, 3) + "年" + WK_StartDate.substring(3, 5) + "月" + WK_StartDate.substring(5, 7) + "日開始" + WK_EndDate.substring(0, 3) + "年" + WK_EndDate.substring(3, 5) + "月" + WK_EndDate.substring(5, 7) + "日結束<br>");
	out.println("您選擇放棄參加本次職能評核<br><br>");
	out.println("<a href='" + WK_PdfLink + "?t=" + System.currentTimeMillis() + "' download='" + userInformation.getYear() + "年第" + userInformation.getItem() + "梯次職務評核表.pdf'" +" target='_blank'>下載放棄職務評核表</a>");
}
%>
      </td></tr>
</table>
</center>
</body>
</html>
