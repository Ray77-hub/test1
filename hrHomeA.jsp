<!-- hrHome.jsp -->
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="initial-scale=1.0">
  <title>職能評核系統</title>
  <jsp:include page="menuHead.jsp" ></jsp:include>
</head>
<body>
<center>
<h2>
職能評核系統
</h2>
<table border=1>
  <tr><td bgcolor='#96D4D4' align='center'>單位</td><td>人資處</td><td bgcolor='#96D4D4' align='center'>姓名</td><td>李小娟</td><td bgcolor='#96D4D4' align='center'>到職日期</td><td>999年99月99日</td></tr>
  <tr><td bgcolor='#96D4D4' align='center'>評核職務</td><td>人資專員</td><td bgcolor='#96D4D4' align='center'>職務分級</td><td>中階</td><td bgcolor='#96D4D4' align='center'>學歷</td><td>大學</td></tr>
</table><br>
<jsp:include page="hrMenu.jsp" ></jsp:include>
<br><br>
<table border=0>
  <tr><td><form name="FormA" action="A.jsp" method='post'>
            本次申請職能評核期間：9999年99月99日開始9999年99月99日結束<br>
            是否申請本次職能評核？
		    <input type="radio" id="申請評核" name="a" value="申請評核">申請評核<br>&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;
		    <input type="radio" id="放棄評核" name="a" value="放棄評核">放棄評核
		    <button class="button" onclick="FormA.sumbit();">確定送出</button>
          </form>
      </td></tr>
</table>
</center>
</body>
</html>
