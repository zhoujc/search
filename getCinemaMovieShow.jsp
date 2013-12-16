<%@ 
page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@ 
page import="com.ctbri.srhcore.pojo.POIObject"%><%@ 
page import="com.ctbri.srcapi.SearchResult"%><%@ 
page import="com.ctbri.srcapi.tool.Tool"%><%@ 
page import="com.ctbri.srcapi.tool.ParserReviews"%><%@ 
page import="com.ctbri.srcapi.tool.Review"%><%@ 
page import="com.ctbri.srhcore.parsedata.zhizhu.ZhizhuCinema"%><%@ 
page import="com.ctbri.srhcore.parsedata.wpw.WpwCinema"%><%@ 
page import="java.util.LinkedList"%><%@ 
page import="java.util.Set"%><%@
page import="java.util.HashSet"%><%@
page import="java.util.HashMap"%><%@ 
page import="java.util.Map"%><%@
page import="java.util.Comparator"%><%@
page import="java.util.List"%><%@ 
page import="com.ctbri.srcapi.POISearcher"%><%@ 
page import="org.json.JSONArray"%><%@ 
page import="org.json.JSONObject"%><%@ 
page import="com.ctbri.srhcore.parsedata.UPara"%><%@ 
page import="com.ctbri.srhcore.U"%><%@ 
page import="java.util.Collections"%><%@
page import="com.ctbri.srhcore.parsedata.Cinema"%><%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String cinemaId = Tool.getInitialValue(request, "cinemaId","");
	String movieId = Tool.getInitialValue(request, "movieId","");
	String timestr = Tool.getInitialValue(request, "time","0");
	int time = 0;
	try {
		time = Integer.parseInt(timestr);
	} catch (NumberFormatException e) {
		// TODO Auto-generated catch block
		time =0;
	}
	
   
    POIObject o = null;

	U.log.info("receive para:");
	U.log.info("cinemaId: "+ cinemaId);
	U.log.info("movieId: "+ movieId);
	U.log.info("time: "+ time);
	U.log.info("== para end==");

	
	String result = "";
	
	String[] cinemaIds = cinemaId.split(";");
	String[] movieIds = movieId.split(",");
	
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
		else if(movie[0].equals("1") && c_id!= null)
		{
			U.log.debug("1 "+c_id+"  "+ m_id+"  "+time);
			re = WpwCinema.loadShows(c_id, m_id, time);
			U.log.debug("======1=======");
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

	StringBuffer sb = new StringBuffer();
		
	if(list.size()>0)
	{
		for (int j = 0; j < list.size(); j++) {
			sb.append(list.get(j)).append(",");
		}
	}
	StringBuffer codestr = new StringBuffer();
	if(code1.length()>0)
		codestr.append(code1);
	if(code2.length()>0)
	{
		if(codestr.length()>0)
			codestr.append(",").append(code2);
		else
			codestr.append(code2);
	}
	if(sb.length()>0)
		result= "{\"code\":\""+codestr.toString()+"\",\"shows\":["+sb.substring(0, sb.length()-1)+"]}";
	else
	    result= "{\"code\":\""+codestr.toString()+"\",\"shows\":["+sb.toString()+"]}";
/**
	if(sb.length()>0)
		result= "{\"code\":\""+code1+","+code2+"\",\"shows\":["+sb.substring(0, sb.length()-1)+"]}";
	else
	  result= "{\"code\":\""+code1+","+code2+"\",\"shows\":["+sb.toString()+"]}";
	  */

	/*
	else
	{
		result="{\"code\":505}";
	}
	*/
	out.print(result);
    out.flush();


%> 
