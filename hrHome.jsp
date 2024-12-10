<%@ page language="java" contentType="text/html;charset=utf-8" %>
<%@ page import="java.sql.*,java.net.URLEncoder,java.io.*,java.util.*,java.text.*" %>
<%@ page import="javax.naming.Context, javax.naming.InitialContext, javax.sql.DataSource" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
Connection conn = null;
Statement stat = null;
String id = request.getParameter("id");
String year = request.getParameter("year");
String department = request.getParameter("department");
String category = request.getParameter("category");
String option = request.getParameter("option");

List<String> conditions = new ArrayList<>();
if (id != null && !"".equals(id)) {
    conditions.add("id='" + id + "'");
}
if (year != null && !"".equals(year)) {
    conditions.add("year='" + year + "'");
}
if (department != null && !"".equals(department)) {
    conditions.add("department_id='" + department + "'");
}
if (category != null && !"".equals(category) && option != null && !"".equals(option)) {
    conditions.add(category + "='" + option + "'");
}
String getListSQL = "SELECT * FROM competency_assessment_list";
if (!conditions.isEmpty()) {
    getListSQL += " WHERE " + String.join(" AND ", conditions);
}
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
<h2>職能評核系統</h2>
<%
try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost/hr?useUnicode=true&characterEncoding=UTF-8", "user", "123456");

    // 待評核名單
    out.println("<h2>待評核名單</h2>");
    out.println("<table border='1'>");
    out.println("<tr><th>項次</th><th>待評核名單</th><th>完成日期</th><th>上傳數量</th><th>上傳檔案</th><th>評核</th></tr>");
    Statement stmt1 = conn.createStatement();
    ResultSet rs1 = stmt1.executeQuery(getListSQL);
    while (rs1.next()) {
        if (rs1.getString("hr_verify_status").equals("R")) {
            out.println("<tr><td>" + rs1.getString("uid") + "</td><td>" + rs1.getString("name") + "</td><td>" + rs1.getString("update_datetime") + "</td><td>3</td><td>職務條件, 工作說明, 學歷證明</td><td><a href='hrVerify.jsp'><button>評核</button></a></td></tr>");
        }
    }
    out.println("</table><br>");
    rs1.close();
    stmt1.close();

    // 合格名單
    out.println("<h2>合格名單</h2>");
    out.println("<table border='1'>");
    out.println("<tr><th>項次</th><th>合格名單</th><th>人資建議</th><th>人資人員</th><th>建議日期</th><th>部門主管</th><th>評核日期</th><th>評核結果</th><th>產生職能評核通知書</th></tr>");
    Statement stmt2 = conn.createStatement();
    ResultSet rs2 = stmt2.executeQuery(getListSQL);
    while (rs2.next()) {
        if (rs2.getString("hr_verify").equals("Y")) {
            out.println("<tr><td>" + rs2.getString("uid") + "</td><td>" + rs2.getString("name") + "</td><td>合格</td><td>" + rs2.getString("update_user") + "</td><td>" + rs2.getString("update_datetime") + "</td><td>" + rs2.getString("verify_director_id_1") + "</td><td>" + rs2.getString("update_datetime") + "</td><td>認同</td><td><a href='hrCreateHR40C.jsp?uid=" + rs2.getString("uid") + "'><button>產生職能評核通知書</button></a></td></tr>");
        }
    }
    out.println("</table><br>");
    rs2.close();
    stmt2.close();

    // 不合格名單
    out.println("<h2>不合格名單</h2>");
    out.println("<table border='1'>");
    out.println("<tr><th>項次</th><th>不合格名單</th><th>人資建議</th><th>人資人員</th><th>建議日期</th><th>部門主管</th><th>評核日期</th><th>評核結果</th><th>產生職能評核通知書</th></tr>");
    Statement stmt3 = conn.createStatement();
    ResultSet rs3 = stmt3.executeQuery(getListSQL);
    while (rs3.next()) {
        if (rs3.getString("hr_verify").equals("N")) {
            out.println("<tr><td>" + rs3.getString("uid") + "</td><td>" + rs3.getString("name") + "</td><td>不合格</td><td>" + rs3.getString("update_user") + "</td><td>" + rs3.getString("update_datetime") + "</td><td>" + rs3.getString("verify_director_id_1") + "</td><td>" + rs3.getString("update_datetime") + "</td><td>認同</td><td><a href='hrCreateHR40C.jsp?uid=" + rs3.getString("uid") + "'><button>產生職能評核通知書</button></a></td></tr>");
        }
    }
    out.println("</table><br>");
    rs3.close();
    stmt3.close();

    // 資格不符名單
    out.println("<h2>資格不符名單</h2>");
    out.println("<table border='1'>");
    out.println("<tr><th>項次</th><th>資格不符名單</th><th>人資建議</th><th>人資人員</th><th>建議日期</th><th>部門主管</th><th>評核日期</th><th>評核結果</th><th>產生職能評核通知書</th></tr>");
    Statement stmt4 = conn.createStatement();
    ResultSet rs4 = stmt4.executeQuery(getListSQL);
    while (rs4.next()) {
        if (rs4.getString("hr_verify").equals("C")) {
            out.println("<tr><td>" + rs4.getString("uid") + "</td><td>" + rs4.getString("name") + "</td><td>資格不符</td><td>" + rs4.getString("update_user") + "</td><td>" + rs4.getString("update_datetime") + "</td><td>" + rs4.getString("verify_director_id_1") + "</td><td>" + rs4.getString("update_datetime") + "</td><td>認同</td><td><a href='hrCreateHR40C.jsp?uid=" + rs4.getString("uid") + "'><button>產生職能評核通知書</button></a></td></tr>");
        }
    }
    out.println("</table><br>");
    out.println("<button class='button' onclick=\"document.location.href='queryAssessmentEmp.jsp'\">回員工職能評核名單資料維護-查詢畫面</button>");
    rs4.close();
    stmt4.close();
} catch(Exception ex) {
    out.println("讀取員工評核資料過程中發生錯誤：" + ex.getMessage() + "<br>");
} finally {
    if(conn != null) try { conn.close(); } catch(SQLException ex) {}
}
%>
</center>
</body>
</html>
