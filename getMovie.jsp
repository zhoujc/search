<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.parsedata.MovieWanZhu"%><%@ 
page import="com.ctbri.srhcore.parsedata.zhizhu.MovieZhizhu"%><%@ 
page import="com.ctbri.srhcore.parsedata.wpw.MovieWpw"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="java.util.LinkedList"%><%@ 
page import="java.util.List"%><%@ 
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="com.ctbri.srhcore.U"%><%@ 
page import="com.ctbri.srhcore.parsedata.Cinema"%><%@
page import="com.ctbri.srhcore.parsedata.wpw.WpwCinema"%><%@ 
page import="com.ctbri.srhcore.parsedata.zhizhu.ZhizhuCinema"%><%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());


	String movieId = Tool.getInitialValue(request, "movieId","");
	String refer = Tool.getInitialValue(request, "refer","2");//1 ÊÇÍøÆ±Íø 2ÊÇÍæÖ÷
	
	U.log.info("receive para:");

	U.log.info("movieId: "+ movieId);
	U.log.info("refer: "+ refer);
	U.log.info("== para end==");
	String re = "";
	if(movieId.length()==0)
	{
		re="{\"code\":505}";
	}
	else if(refer.equals("2"))
	{
		MovieWanZhu o = Cinema.getMovieWanzhu(movieId);
		if(o!= null)
		{
			StringBuffer sb = new StringBuffer();
			sb.append("{\"code\":200,");
			sb.append("\"movie\":").append("{");
			sb.append("\"id\":").append("\"").append(o.id).append("\"").append(",");
			sb.append("\"name\":").append("\"").append(o.name).append("\"").append(",");
			sb.append("\"type\":").append("\"").append(o.type).append("\"").append(",");
			sb.append("\"language\":").append("\"").append(o.language).append("\"").append(",");
			sb.append("\"director\":").append("\"").append(o.director).append("\"").append(",");
			sb.append("\"actor\":").append("\"").append(o.actor).append("\"").append(",");
			sb.append("\"release\":").append("\"").append(o.release).append("\"").append(",");
			sb.append("\"duration\":").append("\"").append(o.duration).append("\"").append(",");
			sb.append("\"trailer\":").append("\"").append(o.trailer).append("\"").append(",");
			sb.append("\"picture\":").append("\"").append(o.picture).append("\"").append(",");
			sb.append("\"descript\":").append("\"").append(o.descript).append("\"");
			sb.append("}");
			sb.append("}");
			re = sb.toString();
		}
		else
		{
			re="{\"code\":404}";//no found
		}
	}
	else if(refer.equals("3"))
	{
		MovieZhizhu o = ZhizhuCinema.getMovieZhizhu(movieId);
		if(o!= null)
		{
			StringBuffer sb = new StringBuffer();
			sb.append("{\"code\":200,");
			sb.append("\"movie\":").append("{");
			sb.append("\"id\":").append("\"").append(o.id).append("\"").append(",");
			sb.append("\"name\":").append("\"").append(o.name).append("\"").append(",");
			sb.append("\"englishName\":").append("\"").append(o.englishName).append("\"").append(",");
			sb.append("\"openingDate\":").append("\"").append(o.openingDate).append("\"").append(",");
			sb.append("\"director\":").append("\"").append(o.director).append("\"").append(",");
			sb.append("\"actor\":").append("\"").append(o.actor).append("\"").append(",");
			sb.append("\"duration\":").append("\"").append(o.duration).append("\"").append(",");
			sb.append("\"description\":").append("\"").append(o.description).append("\"").append(",");
			sb.append("\"picture\":").append("\"").append(o.picture).append("\"").append(",");	
			sb.append("\"country\":").append("\"").append(o.country).append("\"");
			sb.append("}");
			sb.append("}");
			re = sb.toString();
		}
		else
		{
			re="{\"code\":404}";//no found
		}
	}
	else if(refer.equals("1"))
	{
		MovieZhizhu o = ZhizhuCinema.getMovieZhizhu(movieId);
		if(o!= null)
		{
			StringBuffer sb = new StringBuffer();
			sb.append("{\"code\":200,");
			sb.append("\"movie\":").append("{");
			sb.append("\"id\":").append("\"").append(o.id).append("\"").append(",");
			sb.append("\"name\":").append("\"").append(o.name).append("\"").append(",");
			sb.append("\"sort\":").append("\"").append(o.englishName).append("\"").append(",");
			sb.append("\"showDate\":").append("\"").append(o.openingDate).append("\"").append(",");
			sb.append("\"director\":").append("\"").append(o.director).append("\"").append(",");
			sb.append("\"mp\":").append("\"").append(o.actor).append("\"").append(",");
			sb.append("\"sphoto\":").append("\"").append(o.duration).append("\"").append(",");
			sb.append("\"description\":").append("\"").append(o.description).append("\"").append(",");
			sb.append("\"area\":").append("\"").append(o.picture).append("\"").append(",");	
			sb.append("\"lphoto\":").append("\"").append(o.picture).append("\"").append(",");	
			sb.append("\"grade\":").append("\"").append(o.picture).append("\"").append(",");	
			sb.append("\"msg\":").append("\"").append(o.picture).append("\"").append(",");	
			sb.append("\"type\":").append("\"").append(o.country).append("\"");
			sb.append("}");
			sb.append("}");
			re = sb.toString();
		}
		else
		{
			re="{\"code\":404}";//no found
		}
	}

	else
	{
		re="{\"code\":505}";
	}
	out.print(re);
	
    out.flush();

/**

	StringBuffer sbjo = new StringBuffer();
	String r = o.getFieldValue("comment");
	StringBuffer sbre = new StringBuffer();
	sbre.append("[ ");
	if(r !=null && r.length()>0)
	{
		List<Review> list = ParserReviews.parse(r);
		
		StringBuffer sb2 = new StringBuffer();
		for(int i = 0;i< list.size();i++)
		{
			Review tempr = list.get(i);
			sb2.append("{");
			sb2.append("username:").append("\"").append(tempr.username).append("\"").append(",");
			sb2.append("comment:").append("\"").append(tempr.comment).append("\"").append(",");
			sb2.append("time:").append("\"").append(tempr.time).append("\"");
			sb2.append("},");
		}
		if(sb2.length()>0)
		{
			sbre.append(sb2.substring(0,sb2.length()-1));
		}
	}
	sbre.append("]");

	sbjo.append("{");
	sbjo.append("\"nid\":").append("\"").append(o.getFieldValue("nid")).append("\"").append(",");
	sbjo.append("\"cid\":").append("\"").append(o.getFieldValue("cid")).append("\"").append(",");
	sbjo.append("\"cityName\":").append("\"").append(o.getFieldValue("cityName")).append("\"").append(",");
	sbjo.append("\"cityCode\":").append("\"").append(o.getFieldValue("cityCode")).append("\"").append(",");
	sbjo.append("\"name\":").append("\"").append(o.getFieldValue("name")).append("\"").append(",");
	sbjo.append("\"address\":").append("\"").append(o.getFieldValue("address")).append("\"").append(",");
	sbjo.append("\"phone\":").append("\"").append(o.getFieldValue("phone")).append("\"").append(",");
	sbjo.append("\"typeName\":").append("\"").append(o.getFieldValue("typeName")).append("\"").append(",");
	sbjo.append("\"typeCode\":").append("\"").append(o.getFieldValue("typeCode")).append("\"").append(",");
	sbjo.append("\"latitude\":").append("\"").append(o.getFieldValue("latitude")).append("\"").append(",");
	sbjo.append("\"longitude\":").append("\"").append(o.getFieldValue("longitude")).append("\"").append(",");
	sbjo.append("\"district\":").append("\"").append(o.getFieldValue("district")).append("\"").append(",");
	sbjo.append("\"tag\":").append("\"").append(o.getFieldValue("tag")).append("\"").append(",");
	if(o.getFieldValue("rank").length()>0)
		sbjo.append("\"rank\":").append("\"").append(o.getFieldValue("rank")).append("\"").append(",");
//	if(o.getFieldValue("brand").length()>0)
//		sbjo.append("\"brand\":").append("\"").append(o.getFieldValue("brand")).append("\"").append(",");
	if(o.getFieldValue("traffic").length()>0)
		sbjo.append("\"traffic\":").append("\"").append(o.getFieldValue("traffic")).append("\"").append(",");
	if(o.getFieldValue("des").length()>0)
		sbjo.append("\"des\":").append("\"").append(o.getFieldValue("des").replaceAll("@@", "\n")).append("\"").append(",");
	if(o.getFieldValue("spicalDes").length()>0)
		sbjo.append("\"spicalDes\":").append("\"").append(o.getFieldValue("spicalDes")).append("\"").append(",");
	if(o.getFieldValue("webUrl").length()>0)
		sbjo.append("\"webUrl\":").append("\"").append(o.getFieldValue("webUrl")).append("\"").append(",");
	if(o.getFieldValue("favorite").length()>0)
		sbjo.append("\"favorite\":").append("\"").append(o.getFieldValue("favorite")).append("\"").append(",");
//	if(o.getFieldValue("reviews").length()>0)
//		sbjo.append("\"reviews\":").append(sbre.toString()).append(",");
	if(o.getFieldValue("is_park_vailable").length()>0)
		sbjo.append("\"is_park_vailable\":").append("\"").append(o.getFieldValue("is_park_vailable")).append("\"").append(",");
	if(o.getFieldValue("is_room_available").length()>0)
		sbjo.append("\"is_room_available\":").append("\"").append(o.getFieldValue("is_room_available")).append("\"").append(",");
	if(o.getFieldValue("refer").length()>0)
		sbjo.append("\"refer\":").append("\"").append(o.getFieldValue("refer")).append("\"").append(",");
	
	///////////////////////////////////////////////////////////////////////////
	if(o.getFieldValue("avePerCost").length()>0)
		sbjo.append("\"price\":").append("\"").append(o.getFieldValue("avePerCost")).append("\"").append(",");
	if(o.getFieldValue("trafficRoute").length()>0)
		sbjo.append("\"traffic\":").append("\"").append(o.getFieldValue("trafficRoute")).append("\"").append(",");
	if(o.getFieldValue("intro").length()>0)
		sbjo.append("\"des\":").append("\"").append(o.getFieldValue("intro")).append("\"").append(",");
	if(o.getFieldValue("headPic").length()>0)
		sbjo.append("\"photo\":").append("\"").append(o.getFieldValue("headPic")).append("\"").append(",");
	if(o.getFieldValue("specialty").length()>0)
		sbjo.append("\"favorite\":").append("\"").append(o.getFieldValue("specialty")).append("\"").append(",");

	if(o.getFieldValue("comment").length()>0)
	{
		sbjo.append("\"reviews\":").append(sbre.toString()).append(",");
//		sbjo.append("\"comment\":").append("\"").append(o.getFieldValue("comment")).append("\"").append(",");
	}
		
	if(o.getFieldValue("isPark").length()>0)
		sbjo.append("\"is_park_vailable\":").append("\"").append(o.getFieldValue("isPark")).append("\"").append(",");
	if(o.getFieldValue("ispack").length()>0)
		sbjo.append("\"is_room_available\":").append("\"").append(o.getFieldValue("ispack")).append("\"").append(",");
	if(o.getFieldValue("source").length()>0)
		sbjo.append("\"refer\":").append("\"").append(o.getFieldValue("source")).append("\"").append(",");
	if(o.getFieldValue("isBookingStatus").length()>0)
		sbjo.append("\"isBookingStatus\":").append("\"").append(o.getFieldValue("isBookingStatus")).append("\"").append(",");

	if(o.getFieldValue("recommendValue").length()>0)
		sbjo.append("\"recommendValue\":").append("\"").append(o.getFieldValue("recommendValue")).append("\"").append(",");
	if(o.getFieldValue("zcDiscount").length()>0)
		sbjo.append("\"zcDiscount\":").append("\"").append(o.getFieldValue("zcDiscount")).append("\"").append(",");
	if(o.getFieldValue("ftDiscount").length()>0)
		sbjo.append("\"ftDiscount\":").append("\"").append(o.getFieldValue("ftDiscount")).append("\"").append(",");
	if(o.getFieldValue("area").length()>0)
		sbjo.append("\"area\":").append("\"").append(o.getFieldValue("area")).append("\"").append(",");
	if(o.getFieldValue("msId").length()>0)
		sbjo.append("\"msId\":").append("\"").append(o.getFieldValue("msId")).append("\"").append(",");

	if(o.getFieldValue("msDiscount").length()>0)
		sbjo.append("\"msDiscount\":").append("\"").append(o.getFieldValue("msDiscount")).append("\"").append(",");
	if(o.getFieldValue("msIsfree").length()>0)
		sbjo.append("\"msIsfree\":").append("\"").append(o.getFieldValue("msIsfree")).append("\"").append(",");
	///////////////////////////////////////////////////////////////////////////////////////////////

	sbjo.append("\"brand\":").append("\"").append(o.getFieldValue("brand")).append("\"");//.append(",");
//	sbjo.append(":").append("\"").append(o.getFieldValue("")).append("\"").append(",");
	sbjo.append("}");



	out.print(sbjo);
    out.flush();
**/
%> 
