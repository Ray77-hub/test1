<!-- index.jsp -->
﻿<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-cache");
response.setDateHeader("Expires", 0);
response.sendRedirect("login.jsp");
%>
