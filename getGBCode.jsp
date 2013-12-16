<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="GBK"%>
<%@ page import="com.ctbri.srhcore.parsedata.UPara"%>
<%@ page import="com.ctbri.srhcore.U"%>
<%@ page import="com.ctbri.srcapi.tool.Tool"%>

<%
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Pragrma", "no-cache");
    response.setDateHeader("Expires", 0);
	U.fileLog.fatal(request.getRemoteAddr()+" "+request.getRequestURL()+" "+request.getQueryString());

	String key = Tool.getInitialValue(request, "key","");
	String type = Tool.getInitialValue(request, "type","0");
	String strEncode = Tool.getInitialValue(request, "encode","GBK").toUpperCase();
    key = new String(key.getBytes("ISO8859_1"),strEncode);

	if(UPara.gbcode.size() ==0 || UPara.regbcode.size()==0)
		UPara.loadGBCityCode();

	U.log.info("receive para:");
	U.log.info("key: "+ key);
	U.log.info("type: "+ type);
	U.log.info("== para end==");
	String value = "no value";
	if(type.equals("0"))
		value = UPara.gbcode.get(key);
	else
		value = UPara.regbcode.get(key);



	out.print(value);
    out.flush();
%> 
