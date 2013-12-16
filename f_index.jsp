<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.parsedata.MovieWanZhu"%><%@ 
page import="com.ctbri.srhcore.parsedata.zhizhu.MovieZhizhu"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="java.util.LinkedList"%><%@ 
page import="java.util.ArrayList"%><%@ 
page import="java.util.List"%><%@ 
page import="java.util.Iterator"%><%@ 
page import="java.util.Set"%><%@ 
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="org.json.JSONArray"%><%@ 
page import="org.json.JSONObject"%><%@ 
page import="com.ctbri.srhcore.U"%><%@ 
page import="com.ctbri.srhcore.parsedata.Cinema"%><%@
page import="com.ctbri.srhcore.parsedata.movie.MergeMovie"%><%@
page import="com.ctbri.srhcore.parsedata.zhizhu.ZhizhuCinema"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%!
public class FilmMovieByDay
{
	public String test;
	public String name;
	public String id;
	public String picture;
	public String getName(){return name;}
	public String getId(){return id;}
	public String getPicture(){return picture;}
}
%>
<%
	response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String day = Tool.getInitialValue(request, "day","0");
	String cityname = Tool.getInitialValue(request, "cityname","北京");
	U.log.info("zhoujc   "+cityname);
//	String citycode = Tool.getInitialValue(request, "citycode","310000");
	String strEncode = Tool.getInitialValue(request, "encode","GBK").toUpperCase();
	String method = Tool.getInitialValue(request, "method","").toUpperCase();
	try{
        if(!method.equals("AJAXPOST")){
            cityname = new String(cityname.getBytes("ISO8859_1"),strEncode);
        }
    }catch(Exception e){
        e.printStackTrace();
    }	
	
	U.log.info("receive para:");
	U.log.info("day: "+ day);
	U.log.info("cityname: "+ cityname);
	U.log.info("== para end==");
	String citycode = Cinema.regbcode.get(cityname);
	U.log.info("citycode:" +citycode);


	String re = "";
	List<FilmMovieByDay> relist = new ArrayList<FilmMovieByDay>();
	if(citycode == null || citycode.length()==0 || citycode.equals("null"))
	{
		re="{\"code\":505}";
	}
	else
	{
		String temp = MergeMovie.getMovieList(citycode);
//		U.log.info(temp);
		StringBuffer sb = new StringBuffer();
		sb.append("{\"code\":200,");
		sb.append("\"list\":").append(temp);
		sb.append("}");
		re = sb.toString();
		JSONObject rejson = new JSONObject(re);
		JSONArray arr = rejson.getJSONArray("list");
		int len = arr.length();
		for (int i = 0; i < len; i++) {
			JSONObject tempjson = arr.getJSONObject(i);
			FilmMovieByDay tt = new FilmMovieByDay();
			tt.name = tempjson.get("name").toString();
			tt.id = tempjson.get("id").toString();
			tt.picture = tempjson.get("picture").toString();
			relist.add(tt);
		}
	}
	pageContext.setAttribute("list", relist);


%>

<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport" />
    <meta content="yes" name="apple-mobile-web-app-capable" />
    <meta content="black" name="apple-mobile-web-app-status-bar-style" />
    <meta content="telephone=no" name="format-detection" />
    <meta content="email=no" name="format-detection" />
    <title>翼周边</title>
    <link href="css/yzb_style.css" rel="stylesheet" type="text/css">
    <link href="css/yzb_movie.css" rel="stylesheet" type="text/css">
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/yzb_ui.min.js" type="text/javascript"></script>
    <style type="text/css">
    </style>

</head>
<body>
<div class="yzb_titlebar" >
    <div class="bar">
        <h1 class="title">电影列表</h1>
    </div>
</div>
<div class="yzb_listbg">
    <ul class="yzb_list list_movie">
        <c:forEach var="item" items="${list}">

        <li>
            <a class="list" href="javascript:submitInfo()">
                <span class="leftpic"><img src="${item['picture']}"></span>
                <span class="left1">${item['name']}</span>

            </a>
        </li>
        </c:forEach>
    </ul>

    <div class="yzb_list_foot fn-clear">
        <c:url var="urlStr" value="/cinemaList.do" />
        <c:if test="${page>1}">
            <a href="${urlStr}?cityName=<en:urlEncode key='${cityName}'/>&muid=${muid}&movieName=<en:urlEncode key='${movieName}'/>&latitude=${latitude}&longitude=${longitude}&page=${page-1<1?1:(page-1)}" class="yzb_btn leftbtn"><img src="images/icon/16black_arrow_left.png" /></a>
        </c:if>
        <span>第${page}页</span>
        <c:if test="${page<pageNum}">
            <a href="${urlStr}?cityName=<en:urlEncode key='${cityName}'/>&ids=${ids}&muid=${muid}&movieName=<en:urlEncode key='${movieName}'/>&latitude=${latitude}&longitude=${longitude}&page=${page+1>pageNum?(page):(page+1)}" class="yzb_btn rightbtn"><img src="images/icon/16black_arrow_right.png" /></a>
        </c:if>

    </div>
    <div class="fn-height"></div>
</div>
<form id="goToDetails" name="goToDetails" action="f_cinemaList.jsp" method="post">
    <input type="hidden" id="nid" name="nid" value=""/>
    <input type="hidden" id="cinemaId" name="cinemaId" value=""/>
    <input type="hidden" id="movieName" name="movieName" value="${movieName}"/>
    <input type="hidden" id="distance" name="distance" value=""/>
    <input type="hidden" id="movieId" name="movieId" value="${ids}"/>
    <input type="hidden" id="muid" name="muid" value="${muid}"/>
</form>
<script>
    function submitInfo(nid,cinemaId,distance){
        $('#nid').val(nid);
        $('#cinemaId').val(cinemaId);
        $('#distance').val(Math.round(distance));
        $("#goToDetails").submit();
    }
</script>
<%@include file="../statistics.jsp"%>
</body>
</html>
