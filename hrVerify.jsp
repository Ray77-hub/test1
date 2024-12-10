<!-- hrVerify.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<jsp:useBean id="valueA" scope="request" class="com.gm.HR.ValueObject.CompetencyAssessmentListValueObject" />
<jsp:useBean id="mySQL" scope="request" class="com.gm.HR.db.MySQL" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
String WK_uid = request.getParameter("uid");
Connection conn = null;
Statement stat = null;
ResultSet rs = null;
boolean WK_ChooseStatus = false;  // 是否已經選擇評核方式
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
String WK_FileName = "";
String WK_Choose = "";
String WK_ChooseString = "尚未選擇評核方式";
String WK_File = "";
String WK_Link = "";

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
	conn = mySQL.getConnection();
	
	if(conn != null) {
		stat = conn.createStatement();
		rs = stat.executeQuery(WK_Command);
		
		// 取得職能評核的期間
		if(rs.next()) {
			WK_StartDate = rs.getString("start_date");
			WK_EndDate = rs.getString("end_date");
			WK_StartDate1 = Integer.parseInt(WK_StartDate);
			WK_EndDate1 = Integer.parseInt(WK_EndDate);
		} else {
			out.println("沒有資料");
		}
		
		// 查詢員工職能評核名單-取得要評核的員工資料
		WK_Command = "select * from competency_assessment_list where uid='" + WK_uid + "'";
		System.out.println(WK_Command);
		rs = stat.executeQuery(WK_Command);
		
		if(rs.next()) {
			valueA.setUid(rs.getString("uid"));  // 系統唯一識別碼
			valueA.setYear(rs.getString("year"));  // 職能評核年度
			valueA.setItem(rs.getString("item"));  // 梯次
			valueA.setId(rs.getString("id"));  // 員工編號
			valueA.setName(rs.getString("name"));  // 姓名
			valueA.setSex(rs.getString("sex"));  // 性別
			valueA.setBirthday(rs.getString("birthday"));  // 生日
			valueA.setDepartmentId(rs.getString("department_id"));  // 所屬部門代號
			valueA.setDepartmentName(rs.getString("department_name"));  // 所屬部門名稱
			valueA.setJobId(rs.getString("job_id"));  // 職務代號
			valueA.setJobName(rs.getString("job_name"));  // 職務名稱
			valueA.setJobClassId(rs.getString("job_class_id"));  // 職務分級代號
			valueA.setJobClassName(rs.getString("job_class_name"));  // 職務分級名稱
			valueA.setEducationId(rs.getString("education_id"));  // 學歷代號
			valueA.setEducationName(rs.getString("education_name"));  // 學歷名稱
			valueA.setStartDate(rs.getString("start_date"));  // 到職日期
			valueA.setProvideJob(rs.getString("provide_job"));  // 是否需要提供職務條件
			valueA.setProvideWork(rs.getString("provide_work"));  // 是否需要提供工作說明
			valueA.setProvideEducation(rs.getString("provide_education"));  // 是否需要提供學經歷證明
			valueA.setAssessmentJobId(rs.getString("assessment_job_id"));  // 評核職務代號
			valueA.setAssessmentJobName(rs.getString("assessment_job_name"));  // 評核職務名稱
			valueA.setVerifyDirectorId1(rs.getString("verify_director_id_1"));  // 預計審查部門主管工號
			valueA.setVerifyDirectorName1(rs.getString("verify_director_name_1"));  // 預計審查部門主管姓名
			valueA.setVerifyHrId1(rs.getString("verify_hr_id_1"));  // 預計審查人資工號
			valueA.setVerifyHrName1(rs.getString("verify_hr_name_1"));  // 預計審查人資姓名
			valueA.setChooseTime(rs.getString("choose_time"));  // 填寫選擇評核日期時間
			valueA.setChoose(rs.getString("choose"));  // 選擇評核方式
			valueA.setUploadJob(rs.getString("upload_job"));  // 上傳的職務條件檔案
			valueA.setUploadWork(rs.getString("upload_work"));  // 上傳的工作說明檔案
			valueA.setUploadEducation(rs.getString("upload_education"));  // 上傳的學歷證明檔案
			valueA.setUploadJobTime(rs.getString("upload_job_time"));  // 上傳職務條件日期時間
			valueA.setUploadWorkTime(rs.getString("upload_work_time"));  // 上傳工作說明日期時間
			valueA.setUploadEducationTime(rs.getString("upload_education_time"));  // 上傳學歷證明日期時間
			valueA.setVerifyHrId2(rs.getString("verify_hr_id_2"));  // 審查人資工號
			valueA.setVerifyHrName2(rs.getString("verify_hr_name_2"));  // 審查人資姓名
			valueA.setVerifyJob(rs.getString("verify_job"));  // 職務條件檔案評核結果
			valueA.setVerifyWork(rs.getString("verify_work"));  // 工作說明檔案評核結果
			valueA.setVerifyEducation(rs.getString("verify_education"));  // 學歷證明檔案評核結果
			valueA.setVerifyJobOpinion(rs.getString("verify_job_opinion"));  // 職務條件審查意見
			valueA.setVerifyWorkOpinion(rs.getString("verify_work_opinion"));  // 工作說明審查意見
			valueA.setJobTotalItem(rs.getString("job_total_item"));  // 人資審查結果職務條件總項數
			valueA.setJobItem(rs.getString("job_item"));  // 人資審查結果職務條件不符合項數
			valueA.setWorkTotalItem(rs.getString("work_total_item"));  // 人資審查結果工作說明總項數
			valueA.setWorkItem(rs.getString("work_item"));  // 人資審查結果工作說明不符合項數
			valueA.setUploadPhoto(rs.getString("upload_photo"));  // 人資審查上傳照片數量
			valueA.setUploadVideo(rs.getString("upload_video"));  // 人資審查上傳影片數量
			valueA.setHrVerify(rs.getString("hr_verify"));  // 人資審查結果
			valueA.setHrVerifyStatus(rs.getString("hr_verify_status"));  // 人資審查完成狀態
			valueA.setHrVerifyTime(rs.getString("hr_verify_time"));  // 人資審查日期時間
			valueA.setHrVerifyStatusTime(rs.getString("hr_verify_status_time"));  // 人資審查完成日期時間
			valueA.setVerifyDirectorId2(rs.getString("verify_director_id_2"));  // 審查部門主管工號
			valueA.setVerifyDirectorName2(rs.getString("verify_director_name_2"));  // 審查部門主管姓名
			valueA.setDirectorVerify(rs.getString("director_verify"));  // 部門主管審查結果
			valueA.setDirectorVerifyOpinion(rs.getString("director_verify_opinion"));  // 部門主管不認同意見
			valueA.setDirectorVerifyTime(rs.getString("director_verify_time"));  // 部門主管審查完成日期時間
			valueA.setFormCreate(rs.getString("form_create"));  // 是否產生職能評核表
			valueA.setNoticeCreate(rs.getString("notice_create"));  // 是否產生職能評核通知書
			valueA.setFormCreateTime(rs.getString("form_create_time"));  // 產生職能評核表日期時間
			valueA.setNoticeCreateTime(rs.getString("notice_create_time"));  // 產生職能評核通知書日期時間
			valueA.setFormFile(rs.getString("form_file"));  // 職能評核表檔案
			valueA.setNoticeFile(rs.getString("notice_file"));  // 職能評核通知書檔案
			valueA.setFormDownloadTime(rs.getString("form_download_time"));  // 下載職能評核表日期時間
			valueA.setNoticeDownloadTime(rs.getString("notice_download_time"));  // 下載職能評核通知書日期時間
			valueA.setFormDownloadCount(rs.getString("form_download_count"));  // 下載職能評核表次數
			valueA.setNoticeDownloadCount(rs.getString("notice_download_count"));  // 下載職能評核通知書次數
			valueA.setCreateUserUid(rs.getString("create_user_uid"));  // 建立人使用者系統唯一識別碼
			valueA.setCreateUser(rs.getString("create_user"));  // 建立人
			valueA.setCreateDatetime(rs.getString("create_datetime"));  // 建立日期時間
			valueA.setUpdateUserUid(rs.getString("update_user_uid"));  // 異動人使用者系統唯一識別碼
			valueA.setUpdateUser(rs.getString("update_user"));  // 異動人
			valueA.setUpdateDatetime(rs.getString("update_datetime"));  // 異動日期時間
			/* WK_Choose = rs.getString("choose");
			if(WK_Choose.equals("Y") || WK_Choose.equals("N")) {
				WK_ChooseStatus = true;  // 已經選擇評核方式
			} */
		} else {
			out.println("沒有資料");
		}
		
		rs.close();
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
function FormA3SubmitA() {
	// alert('FormA3SubmitA()');
	if(confirm('您選擇的是評核完成,確定嗎？')) {
		FormA3.action="hrVerifyProcess.jsp";
		FormA3.submit();
	}
}

function FormA3SubmitB() {
	// alert('FormA3SubmitB()');
	if(confirm('您選擇的是退回,確定嗎？')) {
		FormA3.action="hrGobackProcess.jsp";
		FormA3.submit();
	}
}
//-->
</SCRIPT>
<body>
<center>
<h2>
職能評核系統-人資評核
</h2>
<table border=0 width='800px'>
  <tr><td align='right'><%=userInformation.getName()%><br><%=userInformation.getCDate()%></td></tr>
</table>
<table border=1>
  <tr><td bgcolor='#96D4D4' align='center'>單位</td><td align='center'><%=valueA.getDepartmentName()%></td><td bgcolor='#96D4D4' align='center'>姓名</td><td align='center'><%=valueA.getName()%></td><td bgcolor='#96D4D4' align='center'>到職日期</td><td align='center'><%=valueA.getStartDate()%></td></tr>
  <tr><td bgcolor='#96D4D4' align='center'>評核職務</td><td align='center'><%=valueA.getAssessmentJobName()%></td><td bgcolor='#96D4D4' align='center'>職務分級</td><td align='center'><%=valueA.getJobClassName()%></td><td bgcolor='#96D4D4' align='center'>學歷</td><td align='center'><%=valueA.getEducationName()%></td></tr>
</table><br>
<%
if(WK_Cdate1 >= WK_StartDate1 && WK_Cdate1 <= WK_EndDate1) {
	out.println("本次申請職能評核期間：" + WK_StartDate.substring(0, 3) + "年" + WK_StartDate.substring(3, 5) + "月" + WK_StartDate.substring(5, 7) + "日開始" + WK_EndDate.substring(0, 3) + "年" + WK_EndDate.substring(3, 5) + "月" + WK_EndDate.substring(5, 7) + "日結束<br>");
}
%>
<table border=0>
  <tr>
    <td>
	  上傳照片：
	  <form name='FormA1' enctype='multipart/form-data' method='post' action='hrUploadPhoto.jsp'>
	    <input type='hidden' name='T0' value='<%=valueA.getUid()%>'>
	    <input type='file' name='File' size='100'>
	    <input type='submit' value='上傳'>
	  </form>
	</td>
    <td>
	  上傳影片：
	  <form name='FormA2' enctype='multipart/form-data' method='post' action='hrUploadVideo.jsp'>
	    <input type='file' name='File' size='100'>
	    <input type='hidden' name='T0' value='<%=valueA.getUid()%>'>
	    <input type='submit' value='上傳'>
	  </form>
	  
	</td>
  </tr>
  <form name='FormA3' method='post'>
  <tr>
    <td width=400><table border=1 >
	      <tr>
		    <td align='center'>　</td>
		    <td align='center'>合格</td>
		    <td align='center'>不合格</td>
		    <td align='center'>補件</td>
	      </tr>
		  <%
		  if(valueA.getProvideJob().equals("Y")) {
			  WK_Link = "/document/" + valueA.getId() + "/" + valueA.getUploadJob();
			  WK_File = "<a href='" + WK_Link + "' target='_blank'>職務條件</a>";
			  out.println("<tr>");
			  out.println("  <td>1." + WK_File + "</td>");
			  out.println("  <td align='center'><input type='checkbox' id='A11' name='A11' value='Y'></td>");
			  out.println("  <td align='center'><input type='checkbox' id='A12' name='A12' value='N'></td>");
			  out.println("  <td align='center'><input type='checkbox' id='A13' name='A13' value='C'></td>");
			  out.println("</tr>");
		  }
		  
		  if(valueA.getProvideWork().equals("Y")) {
			  WK_Link = "/document/" + valueA.getId() + "/" + valueA.getUploadWork();
			  WK_File = "<a href='" + WK_Link + "' target='_blank'>工作說明</a>";
			  out.println("<tr>");
			  out.println("  <td>2." + WK_File + "</td>");
			  out.println("  <td align='center'><input type='checkbox' id='A21' name='A21' value='Y'></td>");
			  out.println("  <td align='center'><input type='checkbox' id='A22' name='A22' value='N'></td>");
			  out.println("  <td align='center'><input type='checkbox' id='A23' name='A23' value='C'></td>");
			  out.println("</tr>");
		  }
		  
		  if(valueA.getProvideEducation().equals("Y")) {
			  WK_Link = "/document/" + valueA.getId() + "/" + valueA.getUploadEducation();
			  WK_File = "<a href='" + WK_Link + "' target='_blank'>學經歷證明</a>";
			  out.println("<tr>");
			  out.println("  <td>3." + WK_File + "</td>");
			  out.println("  <td></td>");
			  out.println("  <td></td>");
			  out.println("  <td></td>");
			  out.println("</tr>");
		  }
		  %>
		</table>
	</td>
    <td width=500><table border=0>
	      <tr>
		    <td>職務條件審查意見</td>
		    <td>工作說明審查意見</td>
		  </tr>
	      <tr>
		    <td><textarea name='mytext1' rows='6' cols='30' maxlength=300 placeholder='職務條件審查意見'></textarea></td>
		    <td><textarea name='mytext2' rows='6' cols='30' maxlength=300 placeholder='工作說明審查意見'></textarea></td>
		  </tr>
		</table>
	</td>
  </tr>
  <tr>
    <td colspan=2>
	  <table border=0>
	    <tr><td>審查結果</td></tr>
	    <tr><td><input type='checkbox' id='A41' name='A41'>合格,項目全符合</td></tr>
	    <tr><td><input type='checkbox' id='A42' name='A42'>本次職能評核資格不符</td></tr>
	    <tr><td><input type='checkbox' id='A43' name='A43'>不合格</td></tr>
	    <tr><td>　(1)職務條件共<input type='text' id='A44' name='A44' size='5' maxlength='5'>項，第<input type='text' id='A45' name='A45'>項不符合；</td></tr>
	    <tr><td>　(2)工作說明共<input type='text' id='A46' name='A46' size='5' maxlength='20'>項，第<input type='text' id='A47' name='A47'>項不符合。</td></tr>
	    <tr><td align='center'><button class='button' onclick='FormA3SubmitA();'>評核完成</button>　<input type='button' value='退回' onclick='FormA3SubmitB();'></td></tr>
	  </table>
	</td>
  </tr>
  <input type='hidden' id='T0' name='T0' value='<%=valueA.getUid()%>'>
  </form>
</table>
</center>
<%
rs = null;
stat = null;
conn = null;
%>
</body>
</html>
