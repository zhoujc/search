<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.parsedata.MovieWanZhu"%><%@ 
page import="com.ctbri.srhcore.parsedata.zhizhu.MovieZhizhu"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="java.util.LinkedList"%><%@ 
page import="java.util.List"%><%@ 
page import="java.util.Iterator"%><%@ 
page import="java.util.Set"%><%@ 
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="com.ctbri.srhcore.U"%><%@ 
page import="com.ctbri.srhcore.parsedata.Cinema"%><%@
page import="com.ctbri.srhcore.parsedata.movie.MergeMovie"%><%@
page import="com.ctbri.srhcore.parsedata.zhizhu.ZhizhuCinema"%><%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String day = Tool.getInitialValue(request, "day","0");
	String cityname = Tool.getInitialValue(request, "cityname","±±¾©");
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
	}

	
	out.print(re);
	
    out.flush();

%> 
