<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.pojo.POIObject"%><%@ 
page import="com.ctbri.srcapi.SearchResult"%><%@ 
page import="com.ctbri.srcapi.SearchResult"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="com.ctbri.srcapi.POISearcher"%><%@ 
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
public class FilmCinema
{
	public String nid;
	public String cid;
	public String name;
	public String point;
	public String address;
	public String photo;
	public double distance;

	public String getNid(){return nid;}
	public String getCid(){return cid;}
	public String getName(){return name;}
	public String getPoint(){return point;}
	public String getAddress() {return address;}
	public String getPhoto(){return photo;}
	public double getDistance(){return distance;}
}
%>
<%
	response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String strCity = Tool.getInitialValue(request, "city","");
	String poiType = Tool.getInitialValue(request, "poitype","").trim();  
	String querykey = Tool.getInitialValue(request, "querykey","").trim();
	String movieName = Tool.getInitialValue(request, "moviename","").trim();
	String tag = Tool.getInitialValue(request, "channel","0").trim();
    String strPage = Tool.getInitialValue(request, "pn","1");
    String strRowNum = Tool.getInitialValue(request, "rn","10");
    String strLimit = Tool.getInitialValue(request, "nlimit","100");
    int limitEnd = Tool.getIntFormString(strLimit,100);

//	String strLicenseKey = Tool.getInitialValue(request, "key","");
    String strEncode = Tool.getInitialValue(request, "encode","GBK").toUpperCase();
    String method = Tool.getInitialValue(request, "method","").toUpperCase();
	String strsortby = Tool.getInitialValue(request,"sortby","0");

	String poiStrLat = Tool.getInitialValue(request, "lat","");
    String poiStrLon = Tool.getInitialValue(request, "lon","");
	double poiLat = 0;
    double poiLon = 0;
    if( poiStrLat.length()>0 && poiStrLon.length()>0 ) {
        poiLat = Tool.getDoubleFormString(poiStrLat, 0D);
        poiLon = Tool.getDoubleFormString(poiStrLon, 0D);
	}

	String district = Tool.getInitialValue(request, "district",""); 
    if(strEncode.length()<1) strEncode = "GBK";
//重新编码
	try{
        if(!method.equals("AJAXPOST")){
            strCity = new String(strCity.getBytes("ISO8859_1"),strEncode);
        }
    }catch(Exception e){
//        e.printStackTrace();
    }
    try{
        if(!method.equals("AJAXPOST")){
            movieName = new String(movieName.getBytes("ISO8859_1"),strEncode);
        }
    }catch(Exception e){
//        e.printStackTrace();
    }
 
    try{
        if(!method.equals("AJAXPOST")){
            querykey = new String(querykey.getBytes("ISO8859_1"),strEncode);
        }
    }catch(Exception e){
//        e.printStackTrace();
    }

	try{
        if(!method.equals("AJAXPOST")){
            district = new String(district.getBytes("ISO8859_1"),strEncode);
        }
    }catch(Exception e){
//        e.printStackTrace();
    }
	

		
    if(poiType==null) poiType="";

	String defaultCenter = "";
	
	int sortby = Tool.getIntFormString(strsortby,0);
	int nPage = Tool.getIntFormString(strPage,1);
	int nRowNum = Tool.getIntFormString(strRowNum,10);
    nRowNum = nRowNum>20 ? 20 : nRowNum; 
    int iStart = Math.max( 0, (nPage-1)* nRowNum + 1 );
    int iEnd = Math.max( 0, nPage*nRowNum );


    int resultNum = 150;
    if(iStart<resultNum && iEnd>resultNum ){
        iEnd = resultNum;
    } else if(iStart>resultNum && iEnd>resultNum) {
        iStart = 0;
        iEnd = 0;
    }

    int nTotalPoiCount = 0;
    double strTime = 0;
    LinkedList<POIObject> vPois = new LinkedList<POIObject>();
    int nNumOfPoisCurrPage = 0;

    String mapCenter = defaultCenter;
   
	String usrQuery = "tag:"+tag+" +tag:"+tag;
	if(movieName.contains("imax") || movieName.contains("IMAX"))
		usrQuery += " +brand:imax" ;
	int mnameIndex = movieName.indexOf("(");
	if(mnameIndex>0)
	{
		movieName = movieName.substring(0,mnameIndex);
		U.log.info("change moviename 2 "+ movieName);
	}

	try{
		//search
		SearchResult sr = null;
		if( querykey.length()>0 || poiType.length()>0  ||usrQuery.length()>0) {
//                sr = com.mapbar.GeoService.search.Search.searchNearby(strCity, keyType + " " + poiType, pt, "",strQuery, nRange, iStart, iEnd);
			U.log.info("receive para:");
			U.log.info("city: "+ strCity);
			U.log.info("querykey: "+ querykey);
			U.log.info("district: "+ district);
			U.log.info("poiType: ["+ poiType+"]");
			U.log.info("movieName: "+ movieName);
			U.log.info("channel: "+ tag);
			U.log.info("start: "+ iStart);
			U.log.info("end: "+ iEnd);
			U.log.info("sortby: "+ sortby);
			U.log.info("poiStrLat: "+ poiLat);
			U.log.info("poiStrLon: "+ poiLon);
			U.log.info("== para end==");
			
			if(movieName != null && movieName.length()>0)
				usrQuery += " +brand:\""+movieName+"\"";
			if(district != null && district.length()>0)
			{
				String disCode = Cinema.regbcode.get(district);
				usrQuery += " +district:\""+disCode +"\"";
			}
			U.log.info("usrQuery: "+ usrQuery);
			sr = POISearcher.search(strCity, querykey, poiType, usrQuery, iStart, iEnd, false, false,sortby,poiLon,poiLat);
		}

		sr = (sr==null)?new SearchResult():sr;

		if(sr != null && sr.getPOIs() != null && !sr.getPOIs().isEmpty()) {
			nTotalPoiCount = sr.getTotalCount();
			vPois = sr.getPOIs();
			nNumOfPoisCurrPage = vPois.size();
			strTime = ((double)sr.getTime())/1000;
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	List<FilmCinema> relist = new ArrayList<FilmCinema>();
	 for (int i = 0; i < nNumOfPoisCurrPage; i++) {
		POIObject obj = (POIObject)vPois.get(i);
		FilmCinema t = new FilmCinema();
		t.nid = obj.getId();
		t.cid = obj.getFieldValue("cid");
		t.name = obj.getName();
		t.point = obj.getLon()+","+obj.getLat();
		t.address = obj.getAddr();
		t.photo = obj.getFieldValue("photo");
		t.distance = obj.getDistance();
		relist.add(t);
	 }
	pageContext.setAttribute("cinemaList", relist);


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
        <h1 class="title">影院列表</h1>
    </div>
</div>
<div class="yzb_listbg">
    <ul class="yzb_list list_movie">
        <c:forEach var="item" items="${cinemaList}">
        <input type="hidden" id="cid" name="cid" value="${item['cid']}" />
        <li>
            <a class="list" href="javascript:submitInfo('${item['nid']}','${item['cid']}',${item['distance']})">
                <span class="leftpic"><img src="${item['photo']}"></span>
                <span class="left1">${item['name']}</span>
                <span class="right1"><fmt:parseNumber value="${item['distance']/1000}" type="number"  integerOnly="true"/>公里</span>
                <span class="left2">${item['address']}</span>
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
<form id="goToDetails" name="goToDetails" action="cinemaDetails.do" method="post">
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
