<!-- loginCheck.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<jsp:useBean id="Message" scope="session" class="com.airlight.DB.ValueObject.MessageValue" />
<%
String WK_PageId = request.getParameter("P0");
if(!Message.getLoginStatus()) {
	Message.setMessage("請先登入");
	WK_PageId = "login.jsp";
}
response.sendRedirect(WK_PageId);
%>