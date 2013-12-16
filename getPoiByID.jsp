<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.pojo.POIObject"%><%@ 
page import="com.ctbri.srcapi.SearchResult"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="com.ctbri.srcapi.tool.ParserReviews"%><%@ 
page import="com.ctbri.srcapi.tool.Review"%><%@ 
page import="java.util.LinkedList"%><%@ 
page import="java.util.List"%><%@ 
page import="com.ctbri.srcapi.POISearcher"%><%@ 
page import="org.json.JSONArray"%><%@ 
page import="org.json.JSONObject"%><%@ 
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="com.ctbri.srhcore.U"%>
<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String poiid = Tool.getInitialValue(request, "id","");
   
    POIObject o = null;

	U.log.info("receive para:");
	U.log.info("id: "+ poiid);
	U.log.info("== para end==");

	o = POISearcher.searchById(poiid);

	o = (o==null)?new POIObject():o;

/**
	JSONObject jo = new JSONObject(); 	
	jo.put("city",strCity);
	jo.put("keyType",keyType);
	jo.put("potType",poiType);
	jo.put("range",nRange);
**/


	StringBuffer sbjo = new StringBuffer();
	String r = o.getFieldValue("comment").replaceAll("\"", "\\\\\"");
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
			sb2.append("\"username\":").append("\"").append(tempr.username).append("\"").append(",");
			sb2.append("\"comment\":").append("\"").append(tempr.comment).append("\"").append(",");			
			sb2.append("\"time\":").append("\"").append(tempr.time).append("\"").append(",");
			sb2.append("\"source\":").append("\"").append(tempr.source).append("\"");
			sb2.append("},");
		}
		if(sb2.length()>0)
		{
			sbre.append(sb2.substring(0,sb2.length()-1));
		}
	}
	sbre.append("]");
	/**
	String cityName = o.getFieldValue("cityName");
	if(cityName.trim().length()<1)
	{
		String citycode = o.getFieldValue("cityCode");
		if(UPara.gbcode.size() ==0 )
			UPara.loadGBCityCode();
		if(citycode.startsWith("11") && citycode.length() ==6) citycode = "110000";
			else if(citycode.startsWith("31") && citycode.length() ==6 ) citycode = "310000";
			else if(citycode.startsWith("12") && citycode.length() ==6 ) citycode = "120000";
			else if(citycode.startsWith("50") && citycode.length() ==6 ) citycode = "500000";
		cityName  = new String(UPara.gbcode.get(citycode).getBytes("GBK"), "UTF-8");
		System.out.println(UPara.gbcode.get(citycode));

	}
	**/
	sbjo.append("{");
	sbjo.append("\"nid\":").append("\"").append(o.getFieldValue("nid")).append("\"").append(",");
	sbjo.append("\"cid\":").append("\"").append(o.getFieldValue("cid")).append("\"").append(",");
	if(o.getFieldValue("cityName").length()>0)
		sbjo.append("\"cityName\":").append("\"").append(o.getFieldValue("cityName")).append("\"").append(",");
	if(o.getFieldValue("cityCode").length()>0)
		sbjo.append("\"cityCode\":").append("\"").append(o.getFieldValue("cityCode")).append("\"").append(",");
	if(o.getFieldValue("name").length()>0)
		sbjo.append("\"name\":").append("\"").append(o.getFieldValue("name").replaceAll("\"", "\\\\\"")).append("\"").append(",");
	if(o.getFieldValue("address").length()>0)
		sbjo.append("\"address\":").append("\"").append(o.getFieldValue("address").replaceAll("\"", "\\\\\"")).append("\"").append(",");
	if(o.getFieldValue("phone").length()>0)
		sbjo.append("\"phone\":").append("\"").append(o.getFieldValue("phone")).append("\"").append(",");
	if(o.getFieldValue("typeName").length()>0)
		sbjo.append("\"typeName\":").append("\"").append(o.getFieldValue("typeName")).append("\"").append(",");
	if(o.getFieldValue("typeCode").length()>0)
		sbjo.append("\"typeCode\":").append("\"").append(o.getFieldValue("typeCode")).append("\"").append(",");

	if(o.getFieldValue("latitude").length()>0 && o.getFieldValue("longitude").length()>0)
		sbjo.append("\"point\":").append("\"").append(o.getFieldValue("latitude")).append(",").append(o.getFieldValue("longitude")).append("\"").append(",");
	/**
	if(o.getFieldValue("latitude").length()>0)
		sbjo.append("\"latitude\":").append("\"").append(o.getFieldValue("latitude")).append("\"").append(",");
	if(o.getFieldValue("longitude").length()>0)
		sbjo.append("\"longitude\":").append("\"").append(o.getFieldValue("longitude")).append("\"").append(",");
	**/
	if(o.getFieldValue("cityName").length()>0)
		sbjo.append("\"district\":").append("\"").append(o.getFieldValue("district")).append("\"").append(",");
	if(o.getFieldValue("tag").length()>0)
		sbjo.append("\"tag\":").append("\"").append(o.getFieldValue("tag")).append("\"").append(",");
	if(o.getFieldValue("rank").length()>0)
		sbjo.append("\"rank\":").append("\"").append(o.getFieldValue("rank")).append("\"").append(",");
	if(o.getFieldValue("photo").length()>0)
		sbjo.append("\"photo\":").append("\"").append(o.getFieldValue("photo")).append("\"").append(",");

//	if(o.getFieldValue("info").length()>0)
//		sbjo.append("\"info\":").append("\"").append(o.getFieldValue("info")).append("\"").append(",");
	if(o.getFieldValue("tbegin").length()>0)
		sbjo.append("\"tbegin\":").append("\"").append(o.getFieldValue("tbegin")).append("\"").append(",");
	if(o.getFieldValue("tend").length()>0)
		sbjo.append("\"tend\":").append("\"").append(o.getFieldValue("tend")).append("\"").append(",");

//	if(o.getFieldValue("brand").length()>0)
//		sbjo.append("\"brand\":").append("\"").append(o.getFieldValue("brand")).append("\"").append(",");
	if(o.getFieldValue("traffic").length()>0)
		sbjo.append("\"traffic\":").append("\"").append(o.getFieldValue("traffic")).append("\"").append(",");
	if(o.getFieldValue("des").length()>0)
		sbjo.append("\"des\":").append("\"").append(o.getFieldValue("des").replaceAll("@@", "\n").replaceAll("\"", "\\\\\"")).append("\"").append(",");
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
		sbjo.append("\"des\":").append("\"").append(o.getFieldValue("intro").replaceAll("\"", "\\\\\"")).append("\"").append(",");
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

	
//	System.out.println(jo.toString());
//	out.write(jo.toString());

	out.print(sbjo);
    out.flush();
%> 
