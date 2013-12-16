<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
                    <c:forEach items="${showList}" var="item" varStatus="status">
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
//        $("#priceDiv"+index).removeClass();
//        if(flag=="true"){
//            alert("取消被点击了.")
//            $("#priceDiv"+index).addClass("chose");
//            $('#chooseFlag'+index).val(false);
//            $('#cinemaId').val('');
//            $('#movieId').val('');
//            $('#showId').val('');
//            $('#hallId').val('');
//        }else{
//            alert("选中被点击了.")
//            var priceDiv='priceDiv'+rowId;
//            $("div[id^=priceDiv]").removeClass();
//            $("#priceDiv"+index).addClass("chose press");
//            $("div[id^=priceDiv]").addClass("chose");
//            $('#chooseFlag'+index).val(true);
//            $('#refer').val(refer);
//            $('#cinemaId').val(cinemaId);
//            $('#movieId').val(movieId);
//            $('#showId').val(showId);
//            $('#hallId').val(hallId);
//        }
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
