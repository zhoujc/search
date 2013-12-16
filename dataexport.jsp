<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=GBK"%>
<html>
<head>
    <title>基础数据导出</title>
    <meta http-equiv="CONTENT-TYPE" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="query.css"/>
    <script type="text/javascript" src="js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="js/My97DatePicker/WdatePicker.js"></script>
</head>
<body>
<div class="query">
    <div id="allquery" style="padding: 25px; ">	
        <form action="">
            <table>
                <tr>
                    <td>起始日期：</td>
                    <td><input type="text" id="startDate" name="startDate" onclick="WdatePicker()"/></td>
                </tr>
                <tr>
                    <td>终止日期：</td>
                    <td><input type="text" id="endDate"  name="endDate" onclick="WdatePicker()"/> </td>
                </tr>
                <tr>
                    <td>基站：</td>
                    <td><input type="text" id="b_station" name="b_station"/></td>
                </tr>
                <tr>
                    <td>终端类型：</td>
                    <td><input type="text" id="type" name="type"/></td>
                </tr>
                <tr>
                <select name=mini>
                    <option value="1">地区</option>
                    <option value="2">终端</option>
                </select>
                </tr>
                <tr>
                <input type="text" id="minikeyword" name="minikeyword"/>
                </tr>
                <tr>
                    <td><input type="submit" value="导出" /></td>
                </tr>
            </table>
        </form>
    </div>
	
<%@page import="java.util.*"%>
<% 
	
	//获取请求的参数,其中括号中的参数需要与前面dataexport.jsp页面的form中input属性name一致
	String start_date = request.getParameter("startDate");
	String end_date = request.getParameter("endDate");
	String base_station = request.getParameter("b_station");
	String client_type = request.getParameter("type");
	String mini = request.getParameter("mini");
	String minikeyword = request.getParameter("minikeyword");
	
%>
<!--
	<button id="btn" onclick="resultListSwitch()">显示/隐藏-查询结果列表<button>
-->	
		<script language="javascript">
		function resultListSwitch(){
			//获取结果列表table
			var tab = document.getElementById("resultList");
			tab.style.display = tab.style.display =="" ? "none":"";
		}
		function fillInputText(){
			document.getElementById("startDate").value = "<%=start_date%>";
			document.getElementById("endDate").value = "<%=end_date%>";
			document.getElementById("b_station").value = "<%=base_station%>";
			document.getElementById("type").value = "<%=client_type%>";
		}
		function clearInputText(){
			document.getElementById("startDate").value ="";
			document.getElementById("endDate").value = "";
			document.getElementById("b_station").value = "";
			document.getElementById("type").value ="";
		}
		</script>
		
	<%
	
	if (start_date!=null  && end_date!=null){
		//此时为逻辑处理角色-有结果列表
		
		//进行逻辑处理， 其中DataResultVo 需要在上面进行导入，
		ArrayList list = new ArrayList();
		  list.add("a");
		  list.add("1");
		  list.add("b");
		  list.add("2");
		  list.add("c");
		  list.add("3");
		  list.add("d");
		  //list1.add("4");
		  
		
		//遍历查询结果，已表格方式展示
		out.println("<table border=1  width='300' id='resultList'   style='width:300'>");
		out.println("<tr><th>字段1</th></tr>");
		for (int i=0;i<list.size();++i){
			out.println("<tr><td>"+list.get(i)+"</td></tr>");
		}
		if(end_date!=null){		
        end_date = new String(end_date.getBytes("iso8859-1"),"gb2312");
        }
		out.println("<tr><td>"+start_date+"</td></tr>");
		out.println("<tr><td>"+end_date+"</td></tr>");
		out.println("<tr><td>"+base_station+"</td></tr>");
		out.println("<tr><td>"+client_type+"</td></tr>");
		out.println("<tr><td>"+mini+"</td></tr>");
		out.println("<tr><td>"+minikeyword+"</td></tr>");
		out.println("</table>");
		out.println("<script type='text/javascript' >fillInputText();</script>");
		
	}
	else{
		//此时为请求角色-无结果列表
		out.println("<script type='text'/javascript >clearInputText(); resultListSwitch();</script>");
	}
	%>
</body>
</html>