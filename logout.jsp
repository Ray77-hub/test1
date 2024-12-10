<!-- loginProcess.jsp -->
<%@ page language="java" contentType="text/html;charset=utf-8" %>
<jsp:useBean id="userInformation" scope="session" class="com.gm.HR.ValueObject.LoginUserValueObject" />
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
userInformation = null;
response.sendRedirect("login.jsp");
%>