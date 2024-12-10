<!-- empGiveupProcess.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<jsp:useBean id="formParameter" scope="request" class="com.gm.HR.CompetencyAssessment.pdf.AssessmentFormParameter" />
<jsp:useBean id="assessmentForm" scope="request" class="com.gm.HR.CompetencyAssessment.pdf.AssessmentForm" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
Connection conn = null;
Statement stat = null;
String WK_TemplatePath = request.getRealPath("/template") + "/";   // 存放產生職務評核表PDF檔的資料夾
String WK_DocumentPath = request.getRealPath("/document") + "/";   // 存放產生職務評核表PDF檔的資料夾
int WK_Year = 0;
int WK_Month = 0;
int WK_Day = 0;
java.util.Date WK_DateNow = new java.util.Date();
SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
String WK_DateTime = ft.format(WK_DateNow);
String WK_CDateTime = "";
String WK_Command = "";

try {
	// 取得系統年度轉成民國年度
	WK_Year = Integer.parseInt(WK_DateTime.substring(0, 4)) - 1911;
	WK_CDateTime = WK_Year + WK_DateTime.substring(4, WK_DateTime.length());
} catch(Exception ex) {
}

// 取得登入日期時間之年度轉成民國年度
try {
	WK_Year = Integer.parseInt(userInformation.getLoginDatetime().substring(0, 4)) - 1911;
	WK_Month = Integer.parseInt(userInformation.getLoginDatetime().substring(4, 6));
	WK_Day = Integer.parseInt(userInformation.getLoginDatetime().substring(6, 8));
} catch(Exception ex) {
}

// 檢查該員工的資料夾是否存在,若不存在則自動建立
WK_DocumentPath = WK_DocumentPath + "/" + userInformation.getId();
File WK_Folder = new File(WK_DocumentPath); 
if(! WK_Folder.exists()){
	WK_Folder.mkdir(); //建立Sub目錄
}

// 職務評核表的檔名組成：評核年度+評核梯次+員工代號+職務評核表單代號+".pdf"
String WK_FileName = userInformation.getYear() + userInformation.getItem() + userInformation.getId() + "HR40E.pdf";

// 檢查該員工是否已產生過職務評核表,若不存在則建立, 存在則不作任何處理
File WK_File=new File(WK_DocumentPath , WK_FileName);

if(! WK_File.exists()){  //檢查File.txt是否存在
	try {
		// 該員工選擇參加職能評核的更新選擇狀態處理
		WK_Command = "update competency_assessment_list set choose_time='" + WK_CDateTime + "', choose='Y' where year=" + userInformation.getYear() + " and item=" + userInformation.getItem() + " and id='" + userInformation.getId() + "'";///
		Class.forName("org.gjt.mm.mysql.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");
		
		if(conn != null) {
			stat = conn.createStatement();
			stat.execute(WK_Command);
	
			// 設定產生職能評核表的相關參數
			formParameter.setYear(WK_Year);
			formParameter.setMonth(WK_Month);
			formParameter.setDay(WK_Day);
			formParameter.setDepartment(userInformation.getDepartmentName());
			formParameter.setEducation(userInformation.getEducationName());
			formParameter.setApprove(true);
			formParameter.setName(userInformation.getName());
			formParameter.setStartDate(userInformation.getStartDate());
			formParameter.setPosition(userInformation.getPositionName());
			formParameter.setLevel(userInformation.getLevelName());
			formParameter.setCheckOut(true);//
			
			// 產生職能評核表 pdf 檔
			assessmentForm.setSourcePDF(WK_TemplatePath + "/HR40E.pdf");
			assessmentForm.setTargetPDF(WK_DocumentPath + "/" + WK_FileName);
			assessmentForm.createAssessmentForm(formParameter);
			
			out.println("產生職能評核表 pdf 檔完成<br>");///
			out.println("<button class='button' onclick=\"document.location.href='empHome.jsp'\">回本次評核畫面</button>");
			
			stat = null;
			conn = null;
		} else {
			out.println("沒有資料");
		}
	} catch(Exception ex) {
		out.println(ex + "無法連接資料庫");
	}
} else {
	out.println("已產生過職能評核表 pdf 檔, 不可再次產生<br>");
	out.println("<button class='button' onclick=\"document.location.href='empHome.jsp'\">回本次評核畫面</button>");
}
%>