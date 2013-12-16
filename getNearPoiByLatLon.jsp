<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%><%@
page import="com.ctbri.srhcore.pojo.POIObject"%><%@
page import="com.ctbri.srcapi.SearchResult"%><%@
page import="com.ctbri.srhcore.pojo.MapPoint"%><%@
page import="com.ctbri.srcapi.tool.Tool"%><%@
page import="java.util.LinkedList"%><%@
page import="com.ctbri.srcapi.POISearcher"%> <%@
page import="org.json.JSONArray"%><%@
page import="org.json.JSONObject"%><%@
page import="com.ctbri.srhcore.U"%><%@ 
page import="com.ctbri.srhcore.parsedata.Cinema"%><%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String poiStrLatLon = Tool.getInitialValue(request, "strlatlon","");
    String poiStrLat = Tool.getInitialValue(request, "lat","");
    String poiStrLon = Tool.getInitialValue(request, "lon","");
	String strCity = Tool.getInitialValue(request, "city","");
    String poiType = Tool.getInitialValue(request, "poitype","").trim();  
    String querykey = Tool.getInitialValue(request, "querykey","").trim();
		String movieName = Tool.getInitialValue(request, "moviename","").trim();
	String tag = Tool.getInitialValue(request, "channel","10").trim();
	
//    String strQuery = Tool.getInitialValue(request, "otherquery","");
    String strRange = Tool.getInitialValue(request, "range","");  
    String strPage = Tool.getInitialValue(request, "pn","1");
    String strRowNum = Tool.getInitialValue(request, "rn","10");
    String strLimit = Tool.getInitialValue(request, "nlimit","100");
    int limitEnd = Tool.getIntFormString(strLimit,100);
    String strWidth = Tool.getInitialValue(request, "width","");
	String strHeight = Tool.getInitialValue(request, "height","");
//	String strLicenseKey = Tool.getInitialValue(request, "key","");
    String strEncode = Tool.getInitialValue(request, "encode","GBK").toUpperCase();
    String method = Tool.getInitialValue(request, "method","").toUpperCase();
    String strCustomer = Tool.getInitialValue(request, "customer","0");  
	String strforshow = Tool.getInitialValue(request, "forshow","false"); 
	String strsortby = Tool.getInitialValue(request,"sortby","0");

	String district = Tool.getInitialValue(request, "district",""); 
	boolean forshow = strforshow.equals("true")?true:false;//放弃使用了
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
            poiType = new String(poiType.getBytes("ISO8859_1"),strEncode);
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
    int nRange = Tool.getIntFormString(strRange,1000);
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



    double poiLat = 0;
    double poiLon = 0;
    if( poiStrLat.length()>0 && poiStrLon.length()>0 ) {
        poiLat = Tool.getDoubleFormString(poiStrLat, 0D);
        poiLon = Tool.getDoubleFormString(poiStrLon, 0D);
	}
//	else if(poiStrLatLon.length()>0) {
//        double[] poidLatLon = MapCodec.decode(LatLonCustomerToStatic(poiStrLatLon, strCustomer), strLicenseKey);
//        poiLat = poidLatLon[0];
//        poiLon = poidLatLon[1];
//    }
	MapPoint pt = new MapPoint( poiLon , poiLat);
    double minlat = poiLat;
    double minlon = poiLon;
    double maxlat = poiLat;
    double maxlon = poiLon;

	String usrQuery = "tag:"+tag+" +tag:"+tag;
	if(movieName.contains("imax") || movieName.contains("IMAX"))
		usrQuery += " +brand:imax ";
	int mnameIndex = movieName.indexOf("(");
	if(mnameIndex>0)
	{
		movieName = movieName.substring(0,mnameIndex);
		U.log.info("change moviename 2 "+ movieName);
	}

        

    if(/**strCity.length()>0 && **/( poiStrLatLon.length()>0 ||(poiStrLat.length()>0 && poiStrLon.length()>0))){
        try{
            //search
            SearchResult sr = null;
            if( querykey.length()>0 || poiType.length()>0 ||usrQuery.length()>0) {
//                sr = com.mapbar.GeoService.search.Search.searchNearby(strCity, keyType + " " + poiType, pt, "",strQuery, nRange, iStart, iEnd);
				U.log.info("receive para:");
				U.log.info("city: "+ strCity);
				U.log.info("district: "+ district);
				U.log.info("querykey: "+ querykey);
				U.log.info("poiType: "+ poiType);
				U.log.info("lon: "+ poiLon);
				U.log.info("lat: "+ poiLat);
				U.log.info("nrange: "+ nRange);
				U.log.info("movieName: "+ movieName);
				U.log.info("channel: "+ tag);
				U.log.info("start: "+ iStart);
				U.log.info("end: "+ iEnd);
				U.log.info("sortby: "+ sortby);
				U.log.info("== para end==");
				if(movieName != null && movieName.length()>0)
					usrQuery += " +brand:\""+movieName+"\"";
				if(district != null && district.length()>0)
				{
					String disCode = Cinema.regbcode.get(district);
					usrQuery += " +district:\""+disCode +"\"";
				}
				sr = POISearcher.searchNearby(strCity, querykey , poiType,  pt,                 nRange, usrQuery ,iStart,iEnd, false,sortby);
//				sr = POISearcher.searchNearby("北京市", "影院" ,"",new MapPoint(116.46644,39.94167),2000,  "" ,1,100, false);
U.log.debug("==========nTotadasdlPoiCount===========  "+ sr.getTotalCount());
            }

            sr = (sr==null)?new SearchResult():sr;

            if(sr != null && sr.getPOIs() != null && !sr.getPOIs().isEmpty()) {
                nTotalPoiCount = sr.getTotalCount();
				U.log.debug("==========nTotalPoiCount===========  "+ nTotalPoiCount);
                vPois = sr.getPOIs();
                nNumOfPoisCurrPage = vPois.size();
                strTime = ((double)sr.getTime())/1000;
            }
        }catch(Exception e){
            e.printStackTrace();
        }
   }
/**
	JSONObject jo = new JSONObject(); 	
	jo.put("city",strCity);
	jo.put("keyType",keyType);
	jo.put("potType",poiType);
	jo.put("range",nRange);
**/

	StringBuffer sbjo = new StringBuffer();
	sbjo.append("{");
	sbjo.append("\"city\":").append("\"").append(strCity).append("\"").append(",");
	sbjo.append("\"querykey\":").append("\"").append(querykey).append("\"").append(",");
	sbjo.append("\"poiType\":").append("\"").append(poiType).append("\"").append(",");
	sbjo.append("\"range\":").append("\"").append(nRange).append("\"").append(",");
	sbjo.append("\"centerpoint\":").append("\"").append(poiLon).append(",").append(poiLat).append("\"").append(",");


/**
	JSONObject pois = new JSONObject(); 	
	pois.put("total",nTotalPoiCount);
	pois.put("nPage",nPage);
	pois.put("count",nNumOfPoisCurrPage);
	pois.put("time",strTime);
**/

	StringBuffer sbpois = new StringBuffer();
	sbpois.append("{");
	sbpois.append("\"total\":").append("\"").append(nTotalPoiCount).append("\"").append(",");
	sbpois.append("\"nPage\":").append("\"").append(nPage).append("\"").append(",");
	sbpois.append("\"count\":").append("\"").append(nNumOfPoisCurrPage).append("\"").append(",");
	sbpois.append("\"time\":").append("\"").append(strTime).append("\"").append(",");

//	JSONArray jsonArray = new JSONArray();
	StringBuffer jsonarray = new StringBuffer();
	jsonarray.append("[");
	U.log.info("nNumOfPoisCurrPage   " +   nNumOfPoisCurrPage);
    for (int i = 0; i < nNumOfPoisCurrPage; i++) {
//		JSONObject p = new JSONObject();
		StringBuffer tempp = new StringBuffer();
		POIObject obj = (POIObject)vPois.get(i);
		String poiNid = obj.getId();
		String infotype = obj.getType();
		String strName = obj.getName();
        String limitHighName = strName;
        if(limitHighName.length()>limitEnd) {
            limitHighName = limitHighName.substring(0, limitEnd) + "...";
        }
        String strAddress = obj.getAddr();
		String strPhone = obj.getPhone();
		String strContext = obj.getContext().replaceAll("null","").replaceAll(",,",",");

        String strDetail = obj.getDetail();
        String strDist = obj.getDist();
		String distance = obj.getDistance()+"";
		String brand = obj.getBrand();

        int nDir = (obj.getDir());
        int nDoc = (obj.getDoc());
        int nStyle = (obj.getStyle());
        double dScore = (obj.getScore());


        
        double dLat = obj.getLat();
		double dLon = obj.getLon();

			minlat = Math.min(minlat, dLat);
            minlon = Math.min(minlon, dLon);
            maxlat = Math.max(maxlat, dLat);
            maxlon = Math.max(maxlon, dLon);
		tempp.append("{");
		tempp.append("\"index\":").append("\"").append(i).append("\"").append(",");
		tempp.append("\"nid\":").append("\"").append(poiNid).append("\"").append(",");
		tempp.append("\"cid\":").append("\"").append(obj.getFieldValue("cid")).append("\"").append(",");
		tempp.append("\"name\":").append("\"").append(strName).append("\"").append(",");
		tempp.append("\"limitHighName\":").append("\"").append(limitHighName).append("\"").append(",");
		tempp.append("\"point\":").append("\"").append(obj.getLon()).append(",").append(obj.getLat()).append("\"").append(",");
		tempp.append("\"address\":").append("\"").append(strAddress.replaceAll("\"", "\\\\\"")).append("\"").append(",");
		tempp.append("\"phone\":").append("\"").append(strPhone).append("\"").append(",");
		tempp.append("\"distance\":").append("\"").append(distance).append("\"").append(",");
		tempp.append("\"price\":").append("\"").append(obj.getFieldValue("confidenceLevel")).append("\"").append(",");
		tempp.append("\"rank\":").append("\"").append(obj.getFieldValue("rank")).append("\"").append(",");
		tempp.append("\"typeName\":").append("\"").append(obj.getFieldValue("typeName")).append("\"").append(",");
		tempp.append("\"typeCode\":").append("\"").append(obj.getFieldValue("typeCode")).append("\"").append(",");
		
		if(obj.getFieldValue("photo").length()>0)
			tempp.append("\"photo\":").append("\"").append(obj.getFieldValue("photo")).append("\"").append(",");
		
		if(obj.getFieldValue("avePerCost").length()>0)
			tempp.append("\"price\":").append("\"").append(obj.getFieldValue("avePerCost")).append("\"").append(",");
		if(obj.getFieldValue("trafficRoute").length()>0)
			tempp.append("\"traffic\":").append("\"").append(obj.getFieldValue("trafficRoute").replaceAll("\"", "\\\\\"")).append("\"").append(",");
		if(obj.getFieldValue("intro").length()>0)
			tempp.append("\"des\":").append("\"").append(obj.getFieldValue("intro").replaceAll("\"", "\\\\\"")).append("\"").append(",");
		if(obj.getFieldValue("headPic").length()>0)
			tempp.append("\"photo\":").append("\"").append(obj.getFieldValue("headPic")).append("\"").append(",");
		if(obj.getFieldValue("specialty").length()>0)
			tempp.append("\"favorite\":").append("\"").append(obj.getFieldValue("specialty")).append("\"").append(",");

		if(obj.getFieldValue("isPark").length()>0)
			tempp.append("\"is_park_vailable\":").append("\"").append(obj.getFieldValue("isPark")).append("\"").append(",");
		if(obj.getFieldValue("ispack").length()>0)
			tempp.append("\"is_room_available\":").append("\"").append(obj.getFieldValue("ispack")).append("\"").append(",");
		if(obj.getFieldValue("source").length()>0)
			tempp.append("\"refer\":").append("\"").append(obj.getFieldValue("source")).append("\"").append(",");
		if(obj.getFieldValue("isBookingStatus").length()>0)
			tempp.append("\"isBookingStatus\":").append("\"").append(obj.getFieldValue("isBookingStatus")).append("\"").append(",");

		if(obj.getFieldValue("recommendValue").length()>0)
			tempp.append("\"recommendValue\":").append("\"").append(obj.getFieldValue("recommendValue")).append("\"").append(",");
		if(obj.getFieldValue("zcDiscount").length()>0)
			tempp.append("\"zcDiscount\":").append("\"").append(obj.getFieldValue("zcDiscount")).append("\"").append(",");
		if(obj.getFieldValue("ftDiscount").length()>0)
			tempp.append("\"ftDiscount\":").append("\"").append(obj.getFieldValue("ftDiscount")).append("\"").append(",");
		if(obj.getFieldValue("area").length()>0)
			tempp.append("\"area\":").append("\"").append(obj.getFieldValue("area")).append("\"").append(",");
		if(obj.getFieldValue("msId").length()>0)
			tempp.append("\"msId\":").append("\"").append(obj.getFieldValue("msId")).append("\"").append(",");

		if(obj.getFieldValue("msDiscount").length()>0)
			tempp.append("\"msDiscount\":").append("\"").append(obj.getFieldValue("msDiscount")).append("\"").append(",");
		if(obj.getFieldValue("msIsfree").length()>0)
			tempp.append("\"msIsfree\":").append("\"").append(obj.getFieldValue("msIsfree")).append("\"").append(",");


        if(obj.getFieldValue("info").length()>0) //tuangou 用来存储团购的信息信息
			tempp.append("\"info\":").append("\"").append(obj.getFieldValue("info").replaceAll("\"", "\\\\\"")).append("\"").append(",");
		if(obj.getFieldValue("description").length()>0) //团购用来存储关联的团购id
			tempp.append("\"description\":").append("\"").append(obj.getFieldValue("description")).append("\"").append(",");
		tempp.append("\"brand\":").append("\"").append(brand).append("\"");
		


		tempp.append("}");
		jsonarray.append(tempp.toString()).append(",");
/**		
		p.put("index",i);
		p.put("pid",poiNid);
		p.put("name",strName);
		p.put("limitHighName",limitHighName);
		p.put("address",strAddress);
		p.put("phone",strPhone);
		p.put("type",infotype);
		p.put("distance",distance);
		p.put("brand",brand);
		jsonArray.put(p);

		
**/	
	}
	if(nNumOfPoisCurrPage>0)
		jsonarray.deleteCharAt(jsonarray.length()-1);
	jsonarray.append("]");
	sbpois.append("\"result\":").append(jsonarray);
	sbpois.append("}");
	sbjo.append("\"pois\":").append(sbpois);
	sbjo.append("}");
//	U.log.debug(jsonarray+"________zhoujcmark");
	
//	System.out.println(jo.toString());
//	out.write(jo.toString());

	out.print(sbjo);
    out.flush();
%> 
