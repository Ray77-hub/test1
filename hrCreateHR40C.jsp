<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<jsp:useBean id="formParameter" scope="request" class="com.gm.HR.CompetencyAssessment.pdf.AssessmentFormParameter" />
<jsp:useBean id="assessmentForm" scope="request" class="com.gm.HR.CompetencyAssessment.pdf.AssessmentForm" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
Connection conn = null;
Statement stat = null;
String WK_TemplatePath = request.getRealPath("/template") + "/";   // 存放產生職能評核通知書PDF檔的資料夾
String WK_DocumentPath = request.getRealPath("/document") + "/";   // 存放產生職能評核通知書PDF檔的資料夾
int WK_Year = 0;
int WK_Month = 0;
int WK_Day = 0;
java.util.Date WK_DateNow = new java.util.Date();
SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
String WK_DateTime = ft.format(WK_DateNow);
String WK_CDateTime = "";
String WK_Command = "";

String uid = "";
String employeeId = "";
String employeeYear = "";
String employeeItem = "";

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");

    uid = request.getParameter("uid");
    String getEmployeeSQL = "SELECT * FROM competency_assessment_list WHERE uid = ?";
    PreparedStatement pstmt = conn.prepareStatement(getEmployeeSQL);
    pstmt.setString(1, uid);
    ResultSet rs = pstmt.executeQuery();

    if (rs.next()) {
        employeeId = rs.getString("id");
        employeeYear = rs.getString("year");
        employeeItem = rs.getString("item");
    }
} catch (Exception e) {
    out.println("無法連接資料庫：" + e.getMessage());
    return;
}


try {
	// 取得系統年度轉成民國年度
	WK_Year = Integer.parseInt(WK_DateTime.substring(0, 4)) - 1911;
	WK_CDateTime = WK_Year + WK_DateTime.substring(4, WK_DateTime.length());
} catch(Exception ex) {
}

// 檢查該員工的資料夾是否存在,若不存在則自動建立
WK_DocumentPath = WK_DocumentPath + "/" + employeeId;
File WK_Folder = new File(WK_DocumentPath); 
if(! WK_Folder.exists()){
	WK_Folder.mkdir(); //建立Sub目錄
}

// 職能評核通知書的檔名組成：評核年度+評核梯次+員工代號+職能評核通知書代號+".pdf"
String WK_FileName = employeeYear + employeeItem + employeeId + "HR40C.pdf";///

// 檢查該員工是否已產生過職能評核通知書,若不存在則建立, 存在則不作任何處理
File WK_File=new File(WK_DocumentPath , WK_FileName);

if(! WK_File.exists()){  //檢查File.txt是否存在
	try {
		// 該員工選擇參加職能評核的更新選擇狀態處理
		WK_Command = "update competency_assessment_list set choose_time='" + WK_CDateTime + "', choose='Y' where year=" + employeeYear + " and item=" + employeeItem + " and id='" + employeeId + "'";
		Class.forName("org.gjt.mm.mysql.Driver");
		conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");
		
		if(conn != null) {
			stat = conn.createStatement();
			stat.execute(WK_Command);
	
			// 設定產生職能評核通知書的相關參數
///
			
			// 產生職能評核通知書 pdf 檔
			assessmentForm.setSourcePDF(WK_TemplatePath + "/HR40C.pdf");//
			assessmentForm.setTargetPDF(WK_DocumentPath + "/" + WK_FileName);
			assessmentForm.createAssessmentForm(formParameter);
			
			out.println("產生職能評核通知書 pdf 檔完成<br>");
			out.println("<button class='button' onclick=\"document.location.href='hrHome.jsp'\">回本次評核畫面</button>");
			
			stat = null;
			conn = null;
		} else {
			out.println("沒有資料");
		}
	} catch(Exception ex) {
		out.println(ex + "無法連接資料庫");
	}
} else {
	out.println("已產生過職能評核通知書 pdf 檔, 不可再次產生<br>");
	out.println("<button class='button' onclick=\"document.location.href='hrHome.jsp'\">回本次評核畫面</button>");
}
%>
