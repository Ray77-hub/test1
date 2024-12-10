<!-- hrMenu.jsp -->
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<!-- Start css3menu.com BODY section -->
<input type="checkbox" id="css3menu-switcher" class="c3m-switch-input">
<ul id="css3menu1" class="topmenu">
	<li class="topmenu"><a href="" style="height:16px;line-height:16px;"><span>員工職能評核</span></a>
	<ul>
		<li class="subfirst"><a href="empHome.jsp.jsp">本次評核</a></li>
		<li class="sublast"><a href="empQuery.jsp">查詢評核</a></li>
	</ul></li>
	<li class="topmenu"><a href="" style="height:16px;line-height:16px;"><span>人資職能評核</span></a>
	<ul>
		<li class="subfirst"><a href="hrHome.jsp">本次評核</a></li>
		<li class="sublast"><a href="hrQuery.jsp">查詢評核</a></li>
	</ul></li>
	<li class="topmenu"><a href="" style="height:16px;line-height:16px;"><span>資料設定/維護</span></a>
	<ul>
		<li class="subfirst"><a href="addAssessmentPeriod.jsp">設定職能評核期間</a></li>
		<li><a href="modifyAssessmentPeriod.jsp">修改職能評核期間</a></li>
		<li><a href="modifyEmpSecret.jsp">變更員工密碼</a></li>
		<li class="sublast"><a href=""><span>下載資料範本檔案</span></a>
		<ul>
			<li class="subfirst"><a href="downloadDepartmentXLS.jsp">下載公司部門資料上傳資料範本</a></li>
		<li><a href="downloadAssessmentEmpXLS.jsp">下載員工職能評核名單資料上傳資料範本</a></li>
		<li><a href="downloadEmpAssessmentItemXLS.jsp">下載員工職能評核定義資料上傳資料範本</a></li>
		<li><a href="downloadHrXLS.jsp">下載人資評核分工名單資料上傳資料範本</a></li>
			<li class="sublast"><a href="downloadDirectorXLS.jsp">下載部門主管評核名單資料範本</a></li>
		</ul></li>
		<li class="sublast"><a href=""><span>上傳資料</span></a>
		<ul>
			<li class="subfirst"><a href="uploadDepartmentXLS.jsp">上傳公司部門資料</a></li>
		<li><a href="uploadAssessmentEmpXLS.jsp">上傳員工職能評核名單資料</a></li>
		<li><a href="uploadEmpAssessmentItemXLS.jsp">上傳員工職能評核定義資料</a></li>
		<li><a href="uploadHrAssessmentEmpXLS.jsp">上傳人資評核分工名單資料</a></li>
			<li class="sublast"><a href="uploadDirectorAssessmentEmpXLS.jsp">上傳部門主管評核名單</a></li>
		</ul></li>
		<li class="sublast"><a href=""><span>資料維護</span></a>
		<ul>
			<li class="subfirst"><a href="queryDepartment.jsp">公司部門資料維護</a></li>
		<li><a href="queryAssessmentEmp.jsp">員工職能評核名單資料維護</a></li>
		<li><a href="queryEmpAssessmentItem.jsp">員工職能評核定義資料維護</a></li>
		<li><a href="modifyHrAssessmentEmp.jsp">人資評核分工名單資料維護</a></li>
			<li class="sublast"><a href="queryDirectorAssessmentEmp.jsp">部門主管評核名單資料維護</a></li>
		</ul></li>
	</ul></li>
	<li class="topmenu"><a href="empModifySecret.jsp" style="height:16px;line-height:16px;"><span>變更密碼</span></a>
	<li class="topmenu"><a href="logout.jsp" style="height:16px;line-height:16px;">登出</a></li>
</ul><p class="_css3m"><a href="http://css3menu.com/">css menus</a> by Css3Menu.com</p>
<!-- End css3menu.com BODY section -->