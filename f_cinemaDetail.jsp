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
page import="java.util.HashSet"%><%@
page import="java.util.Map"%><%@
page import="java.util.HashMap"%><%@
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="org.json.JSONArray"%><%@ 
page import="org.json.JSONObject"%><%@ 
page import="com.ctbri.srhcore.U"%><%@ 
page import="java.util.Collections"%><%@
page import="java.util.Comparator"%><%@
page import="com.ctbri.srhcore.parsedata.Cinema"%><%@
page import="com.ctbri.srhcore.parsedata.movie.MergeMovie"%><%@
page import="com.ctbri.srhcore.parsedata.zhizhu.ZhizhuCinema"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%!
public class FilmMovieShow
{
	public String id;
	public String refer;
	public String time;
	public String hallid;
	public String cinemaid;
	public String movieid;
	public String price;

	public String getId(){return id;}
	public String getRefer(){return refer;}
	public String getTime(){return time;}
	public String getHallid(){return hallid;}
	public String getCinemaid() {return cinemaid;}
	public String getMovieid(){return movieid;}
	public String getPrice(){return price;}
}
%>
<%
	response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String cinemanid = Tool.getInitialValue(request, "nid","925101602");
	String cinemacid = Tool.getInitialValue(request, "cid","2-101602;3-31070101").trim();  
	String movieid = Tool.getInitialValue(request, "movieid","2-9269,3-001105262013").trim();
	String timestr = Tool.getInitialValue(request, "time","0");
	int time = 0;
	try {
		time = Integer.parseInt(timestr);
	} catch (NumberFormatException e) {
		// TODO Auto-generated catch block
		time =0;
	}
	
    String strEncode = Tool.getInitialValue(request, "encode","GBK").toUpperCase();
    String method = Tool.getInitialValue(request, "method","").toUpperCase();
	
    if(strEncode.length()<1) strEncode = "GBK";
//重新编码
	try{
        if(!method.equals("AJAXPOST")){
            cinemanid = new String(cinemanid.getBytes("ISO8859_1"),strEncode);
        }
    }catch(Exception e){
//        e.printStackTrace();
    }
	
	POIObject o = null;

	U.log.info("receive para:");
	U.log.info("id: "+ cinemanid);
	U.log.info("== para end==");

	o = POISearcher.searchById(cinemanid);

	o = (o==null)?new POIObject():o;
	
	String result = "";
	
	String[] cinemaIds = cinemacid.split(";");
	String[] movieIds = movieid.split(",");
	
	Map<String,String> cinemaMap = new HashMap<String,String>();
		
	for(int i =0;i< cinemaIds.length;i++)
	{
		String[] temp = cinemaIds[i].split("-");
		cinemaMap.put(temp[0],temp[1]);
	}
	LinkedList<JSONObject> list = new LinkedList<JSONObject>();
	Set<String> set = new HashSet<String>();
	String code1 = "";
	String code2 = "";
	for (int i = 0; i < movieIds.length; i++) {
		String[] movie = movieIds[i].split("-");
		String c_id = cinemaMap.get(movie[0]);
		String m_id = movie[1];
		String re = "";
		if(movie[0].equals("2") && c_id!= null)
		{
			U.log.debug("2 "+c_id+"  "+ m_id+"  "+time);
			re = Cinema.loadShows(c_id, m_id, time);
			U.log.debug("=====2========");
			U.log.debug(re);
			U.log.debug("=============");
			if(re.trim().length() ==0 || re.indexOf("{")<0)
				continue;
			JSONObject jo = new JSONObject(re);
			code1 = jo.get("code").toString();
			if(jo.get("code").toString().equals("200"))
			{
				JSONArray arr = jo.getJSONArray("shows");
				for (int j = 0; j < arr.length(); j++) {
					JSONObject temp = arr.getJSONObject(j);
					if(!set.contains(temp.get("id")))
					{
						list.add(temp);
						set.add(temp.get("id").toString());
					}
					
				}
			}
			
			
		}
		else if(movie[0].equals("3") && c_id!= null)
		{
			U.log.debug("3 "+c_id+"  "+ m_id+"  "+time);
			re = ZhizhuCinema.loadShows(c_id, m_id, time);
			U.log.debug("======3=======");
			U.log.debug(re);
			U.log.debug("=============");
			if(re.trim().length() ==0 || re.indexOf("{")<0)
				continue;
			JSONObject jo = new JSONObject(re);
			code2 = jo.get("code").toString();
			if(jo.get("code").toString().equals("200"))
			{
				JSONArray arr = jo.getJSONArray("shows");
				for (int j = 0; j < arr.length(); j++) {
					JSONObject temp = arr.getJSONObject(j);
		//			list.add(temp);
					if(!set.contains(temp.get("id")))
					{
						list.add(temp);
						set.add(temp.get("id").toString());
					}
				}
			}
			
		}
	
	}

	
	Collections.sort(list, new Comparator<JSONObject>(){
		public int compare(JSONObject arg0, JSONObject arg1) {
			// TODO Auto-generated method stub
			float s1 = 10000;
			float s2 = 10000;
			try {
				s1 = Float.parseFloat(arg0.get("standard").toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				s1=10000;
			}
			try {
				s2 = Float.parseFloat(arg1.get("standard").toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				s2 = 10000;
			}
			int sort = Float.compare(s1, s2);
			if(sort<0)
			{
				return -1;
			}
			else if(sort ==0)
				return 0;
			else
				return 1;				

		}
		
	});
		
    List<FilmMovieShow> relist = new ArrayList<FilmMovieShow>();
	for(int i = 0;i< list.size();i++)
	{
		JSONObject json = list.get(i);
		FilmMovieShow tt = new FilmMovieShow();
		tt.id = json.get("id").toString();
		tt.time = json.get("time").toString();
		tt.refer = json.get("refer").toString();
		tt.hallid = json.get("hallId").toString();
		tt.movieid = json.get("movieId").toString();
		tt.cinemaid = json.get("cinemaId").toString();
		tt.price = json.get("price").toString();
		relist.add(tt);
	}
	pageContext.setAttribute("relist", relist);
	pageContext.setAttribute("cinema",o);
	pageContext.setAttribute("date",time);



%>


<!doctype html>
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
        <h1 class="title">影院详情</h1>
    </div>
</div>
<div class="yzb_listbg">
    <div class="yzb_poiinfo fn-clear">
        <div class="pic"><img src="${photo}" /></div>
        <div class="info">
            <div class="title">${cinemaName}</div>
            <div>${address}</div>
            <div class="right1"><fmt:parseNumber value="${distance/1000}" type="number"  integerOnly="true"/>公里</div>
        </div>
    </div>
    <a href="tel:${phone}" class="yzb_btn style_big color_gray btn_tel"><img src="images/icon/16black_tel.png" />电 话</a>
    <div class="minititle">电影排期</div>
    <div class="textdiv">
        <div class="moviename">${movieName}</div>
        <ul class="tabbar fn-clear">
            <c:choose>
                <c:when test="${date==0}">
                    <a href="javascript:goToDetailsAgain(0)"> <li class="tab press">今天</li></a>
                </c:when>
                <c:otherwise>
                    <a href="javascript:goToDetailsAgain(0)"> <li class="tab">今天</li></a>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${date==1}">
                    <a href="javascript:goToDetailsAgain(1)"> <li class="tab press">明天</li></a>
                </c:when>
                <c:otherwise>
                    <a href="javascript:goToDetailsAgain(1)"> <li class="tab">明天</li></a>
                </c:otherwise>
            </c:choose>
            <c:choose>
                <c:when test="${date==2}">
                    <a href="javascript:goToDetailsAgain(2)"><li class="tab press">后天</li></a>
                </c:when>
                <c:otherwise>
                    <a href="javascript:goToDetailsAgain(2)"><li class="tab">后天</li></a>
                </c:otherwise>
            </c:choose>

        </ul>
        <c:choose>
            <c:when test="${fn:length(showList)<1}">
                <div class="nodata"><img src="images/nodata.png"></div>
            </c:when>
            <c:otherwise>
                <table class="list">
                    <c:forEach items="${relist}" var="item" varStatus="status">
                        <tr>
                            <td align="center" valign="middle" class="time">${fn:substring(item['time'],10,fn:length(item['time']))}
                            </td>
                            <td align="center" valign="middle" class="info">${item['hallName']}</td>
                            <td align="center" valign="middle" class="price">
                                <c:forEach var="price" items="${item['dtlList']}" varStatus="priceItem">

                                    <a href="javascript:choosePrice('${price['refer']}','${price['cinemaId']}','${price['movieId']}','${price['id']}','${price['hallId']}','${status.index}${priceItem.index}','${status.index}');">
                                    <c:choose>
                                        <c:when test="${price['refer']==3}">
                                            <div id="priceDiv${status.index}${priceItem.index}" class="chose press"><span class="name">
                                                 <input type="hidden" id="refer${status.index}" name="refer" value="${price['refer']}">
                                                 <input type="hidden" id="cinemaId${status.index}" name="refer" value="${price['cinemaId']}">
                                                 <input type="hidden" id="movieId${status.index}" name="refer" value="${price['movieId']}">
                                                 <input type="hidden" id="showId${status.index}" name="refer" value="${price['id']}">
                                                 <input type="hidden" id="hallId${status.index}" name="refer" value="${price['hallId']}">
                                        </c:when>
                                        <c:otherwise>
                                             <div id="priceDiv${status.index}${priceItem.index}" class="chose"><span class="name">
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${price['refer']==2}">
                                        玩主影院  </span><span>￥${price['price']}</span></div></a>
                                    </c:if>
                                    <c:if test="${price['refer']==3}">
                                        蜘蛛网  </span><span>￥${price['userPrice']}</span></div></a>
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td align="center" valign="middle" class="subbtn"><a class="yzb_btn color_red style_flat" href="javascript:submitInfo('${movieName}','${item['hallName']}','${item['time']}','${status.index}')">选座购票</a></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="minititle">影院简介</div>
    <div class="textdiv">
        ${des}
    </div>
    <div class="minititle">影院交通</div>
    <div class="textdiv">
       ${traffic}
    </div>
</div>
<form id="goToChooseSeats" name="goToChooseSeats" action="" method="post">
    <input type="hidden" id="refer" name="refer" value="">
    <input type="hidden" id="cinemaId" name="cinemaId" value="${cinemaId}"/>
    <input type="hidden" id="movieId" name="movieId" value="${movieId}"/>
    <input type="hidden" id="showId" name="showId" value=""/>
    <input type="hidden" id="hallId" name="hallId" value=""/>
    <input type="hidden" id="movieName" name="movieName" value="${movieName}"/>
    <input type="hidden" id="cinemaName" name="cinemaName" value="${cinemaName}"/>
    <input type="hidden" id="hallName" name="hallName" value="${hallName}"/>
    <input type="hidden" id="showTime" name="showTime" value=""/>
    <input type="hidden" id="nid" name="nid" value="${nid}"/>
    <input type="hidden" id="date" name="date" value="${date}"/>
    <input type="hidden" id="muid" name="muid" value="${muid}"/>
    <input type="hidden" id="distance" name="distance" value="${distance}"/>
</form>
<input type="hidden" id="errorMsg" name="errorMsg" value="${errorMsg}"/>
<script>
    $(function(){
         var errorMsg=$('#errorMsg').val();
        if(''!=errorMsg){
            alert(errorMsg);
            $('#errorMsg').val('');
        }
    });
    function submitInfo(movieName,hallName,time,index){
        $('#movieName').val(movieName);
        $('#hallName').val(hallName);
        $('#showTime').val(time);
        var cinemaId=$('#cinemaId').val();
        var movieId=$('#movieId').val();
        var hallId=$('#hallId').val();
        var showId=$('#showId').val();
        var refer=$('#refer').val();
        if(''!=cinemaId&&''!=movieId&&''!=hallId&&''!=showId){
            if(refer!='3'){
                alert("暂时只支持蜘蛛网选座功能！");
                return
            }
        }else{
            //赋予默认值
            var cinemaId=$('#cinemaId'+index).val();
            var movieId=$('#movieId'+index).val();
            var hallId=$('#hallId'+index).val();
            var showId=$('#showId'+index).val();
            var refer=$('#refer'+index).val();
            $('#cinemaId').val(cinemaId);
            $('#movieId').val(movieId);
            $('#hallId').val(hallId);
            $('#showId').val(showId);
            $('#refer').val(refer);
        }
        $("#goToChooseSeats").attr('action','chooseSeats.do');
        $("#goToChooseSeats").submit();
    }
    function goToDetailsAgain(date){
        $('#date').val(date);
        var cinemaId=$('#cinemaId').val();
        if(''!=cinemaId){
            $("#goToChooseSeats").attr('action','cinemaDetails.do');
            $("#goToChooseSeats").submit();
        }
    }

    function choosePrice(refer,cinemaId,movieId,showId,hallId,index,rowId){
//        var flag=$('#chooseFlag'+index).val();
        if(refer=='2'){
            alert("暂时只支持蜘蛛网选座功能！");
            return
        }

        var priceDiv='priceDiv'+rowId;
        $("div[id^=priceDiv]").removeClass();
        $("#priceDiv"+index).addClass("chose press");
        $("div[id^=priceDiv]").addClass("chose");
        $('#chooseFlag'+index).val(true);
        $('#refer').val(refer);
        $('#cinemaId').val(cinemaId);
        $('#movieId').val(movieId);
        $('#showId').val(showId);
        $('#hallId').val(hallId);
    }
</script>
<%@include file="../statistics.jsp"%>
</body>
</html>
