<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.pojo.POIObject"%><%@ 
page import="com.ctbri.srcapi.SearchResult"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="com.ctbri.srcapi.tool.ParserReviews"%><%@ 
page import="com.ctbri.srhcore.parsedata.zhizhu.ZhizhuCinema"%><%@ 
page import="com.ctbri.srhcore.parsedata.wpw.WpwCinema"%><%@ 
page import="com.ctbri.srcapi.tool.Review"%><%@ 
page import="java.util.LinkedList"%><%@ 
page import="java.util.List"%><%@ 
page import="com.ctbri.srcapi.POISearcher"%><%@ 
page import="org.json.JSONArray"%><%@ 
page import="org.json.JSONObject"%><%@ 
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="com.ctbri.srhcore.U"%><%@ 
page import="com.ctbri.srhcore.parsedata.Cinema"%><%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String cinemaId = Tool.getInitialValue(request, "cinemaId","");
	String movieId = Tool.getInitialValue(request, "movieId","");
	String timestr = Tool.getInitialValue(request, "time","0");
	String refer = Tool.getInitialValue(request, "refer","2");//1 ÊÇÍøÆ±Íø 2ÊÇÍæÖ÷
	int time = 0;
	try {
		time = Integer.parseInt(timestr);
	} catch (NumberFormatException e) {
		// TODO Auto-generated catch block
		time =0;
	}
	Integer.parseInt(timestr);
	
   
    POIObject o = null;

	U.log.info("receive para:");
	U.log.info("cinemaId: "+ cinemaId);
	U.log.info("movieId: "+ movieId);
	U.log.info("time: "+ time);
	U.log.info("refer: "+ refer);
	U.log.info("== para end==");
	
	String re = "";
	if(cinemaId.length()==0 || movieId.length()==0)
	{
		re="{\"code\":505}";
	}
	else if(refer.equals("2"))
	{
		re = Cinema.loadShows(cinemaId,movieId,time);

	}
	else if(refer.equals("3"))
	{
		re = ZhizhuCinema.loadShows(cinemaId,movieId,time);
	}
	else if(refer.equals("1"))
	{
		re = WpwCinema.loadShows(cinemaId,movieId,time);
	}
	else
	{
		re="{\"code\":505}";
	}
	out.print(re);
    out.flush();


%> 
