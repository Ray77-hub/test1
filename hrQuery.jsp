<!-- hrQuery.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);

String WK_year = request.getParameter("year");
String WK_item = request.getParameter("item");
String WK_number = request.getParameter("number");
String WK_department = request.getParameter("department");
String WK_qualified = request.getParameter("qualified");
int WK_Year = 0;
int WK_Month = 0;
int WK_Day = 0;
java.util.Date WK_DateNow = new java.util.Date();
SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddHHmmss");
String WK_DateTime = ft.format(WK_DateNow);
String WK_CDateTime = "";

HashMap<String, String> departmentMap = new HashMap<>();
departmentMap.put("FIN", "財務部");
departmentMap.put("ESH", "職安室");
departmentMap.put("HR", "人資部");
departmentMap.put("SC", "業務部");
departmentMap.put("DC", "研發部");
departmentMap.put("QC", "品保部");
departmentMap.put("LAB", "實驗室");
departmentMap.put("ADM", "管理部");
departmentMap.put("PC", "廠務部");

HashMap<String, String> hrlevelMap = new HashMap<>();
hrlevelMap.put("Y", "合格");
hrlevelMap.put("C", "補件");
hrlevelMap.put("N", "不合格");

HashMap<String, String> directorlevelMap = new HashMap<>();
directorlevelMap.put("Y", "認同");
directorlevelMap.put("N", "不認同");

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

Connection conn = null;
Statement stat = null;
ResultSet rs = null;
%>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="initial-scale=1.0">
        <title>職能評核系統</title>
        <jsp:include page="menuHead.jsp"></jsp:include>
        <style>
            
		</style>
		<script>
		    
		</script>
    </head>
    <body>
        <center>
            <h2>職能評核系統</h2>
            <table border=0 width='800px'>
                <tr>
                    <td align='right'><%=userInformation.getName()%><br><%=WK_Year%>/<%=WK_Month%>/<%=WK_Day%></td>
                </tr>
            </table>
            <br>
            <jsp:include page="hrMenu.jsp"></jsp:include>
            <br><br>
			<form method="post">
				<table border=1 width='500px'>
					<tr>
						<td>年度：<input type="text" name="year" size="5"></td>
						<td>部門：
							<select name="department">
								<option value="">請選擇</option>
								<option value="FIN">財務部</option>
								<option value="ESH">職安室</option>
								<option value="HR">人資部</option>
								<option value="SC">業務部</option>
								<option value="DC">研發部</option>
								<option value="QC">品保部</option>
								<option value="LAB">實驗室</option>
								<option value="ADM">管理部</option>
								<option value="PC">廠務部</option>
							</select>
						</td>
						<td>
							<input type="checkbox" name="qualified" value="Y">認同
						</td>
						<td></td>
					</tr>
					<tr>
						<td>梯次：<input type="text" size="5" name="item"></td>
						<td>工號：<input type="text" size="5" name="number"></td>
						<td>
							<input type="checkbox" name="qualified" value="N">不認同
						</td>
						<td><input type='submit' value='查詢' name='B1'></td>
					</tr>
				</table>
			</form>
			<%
			try {
				Class.forName("org.gjt.mm.mysql.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");
				int i = 0;
	
				if(conn != null) {
					stat = conn.createStatement();
					String sql = "SELECT * FROM competency_assessment_list " +
								"WHERE year ='" + WK_year + "' and department_id ='" + WK_department + "' and item ='" + WK_item + "' and id ='" + WK_number + "' and director_verify ='" + WK_qualified + "'";

					rs = stat.executeQuery(sql);
					out.println("<table border='1' cellpadding='0' cellspacing='0' width='1200px' bordercolor='#ffffff'>");
					out.println("  <tr bgcolor='#CCCCCC' height='35'>");
					out.println("    <td width='50px' align='center'><font color='#000000'></font></td>");
					out.println("    <td width='100px' align='center'><font color='#000000'>年度</font></td>");
					out.println("    <td width='100px' align='center'><font color='#000000'>部門</font></td>");
					out.println("    <td width='150px' align='center'><font color='#000000'>姓名</font></td>");
					out.println("    <td width='300px' align='center'><font color='#000000'>上傳檔案</font></td>");
					out.println("    <td width='100px' align='center'><font color='#000000'>人資</font></td>");
					out.println("    <td width='100px' align='center'><font color='#000000'>主管</font></td>");
					out.println("    <td width='300px' align='center'><font color='#000000'>　</font></td>");
					out.println("  </tr>");
     				while(rs.next()) {
						i++;
						out.println("  <tr height='35' bgcolor='#CCFFFF' onMouseOver=\"this.style.backgroundColor='#FFCC00';this.style.cursor='hand';\" onMouseOut=\"this.style.backgroundColor='#CCFFFF';\">");
						out.println("    <td align='center'>" + i + "</td>");
						out.println("    <td align='center'>" + rs.getString("year") + "</td>");
						out.println("    <td align='center'>" + departmentMap.get(rs.getString("department_id")) + "</td>");
						out.println("    <td align='center'>" + rs.getString("name") + "</td>");
						out.println("    <td align='left'>" + "<a href='directorDownloadJob.jsp?id=" + rs.getString("id") + "&upload_job=" + rs.getString("upload_job") + "' target='_blank'>職務條件</a>" + "," +"<a href='directorDownloadWork.jsp?id=" + rs.getString("id") + "&upload_work=" + rs.getString("upload_work") + "' target='_blank'>工作說明</a>"+ "," +"<a href='directorDownloadEducation.jsp?id=" + rs.getString("id") + "&upload_education=" + rs.getString("upload_education") + "' target='_blank'>學歷證明</a>" + "</td>");
						out.println("    <td align='center'>" + hrlevelMap.get(rs.getString("hr_verify")) + "</td>");
						out.println("    <td align='center'>" + directorlevelMap.get(rs.getString("director_verify")) + "</td>");
						out.println("    <td align='left'>" + "<a href='directorDownloadHR40E.jsp?id=" + rs.getString("id") + "&form_file=" + rs.getString("form_file") + "' target='_blank'>職能評核表</a>" + "," +"<a href='directorDownloadHR40C.jsp?id=" + rs.getString("id") + "&notice_file=" + rs.getString("notice_file") + "' target='_blank'>職能評核通知書</a>"+ "</td>");
						out.println("  </tr>");
					}
		
					rs.close();
					stat.close();
					conn.close();
					out.println("</table>");
				} else {
					out.println("資料庫連線失敗");
				}
			} catch(Exception ex) {
				out.println("資料庫查詢資料失敗");
			}
			%>
		</center>
	</body>
</html>
