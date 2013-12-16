/**
 * Created with JetBrains WebStorm.
 * User: liyan
 * Date: 13-2-5
 * Time: 上午9:58
 * To change this template use File | Settings | File Templates.
 */
// 说明：Javascript 获取链接(url)参数的方法
// 整理：http://www.CodeBit.cn

function getQueryString(name)
{
    // 如果链接没有参数，或者链接中不存在我们要获取的参数，直接返回空
    if(location.href.indexOf("?")==-1 || location.href.indexOf(name+'=')==-1)
    {
        return '';
    }

    // 获取链接中参数部分
    var queryString = location.href.substring(location.href.indexOf("?")+1);

    // 分离参数对 ?key=value&key2=value2
    var parameters = queryString.split("&");

    var pos, paraName, paraValue;
    for(var i=0; i<parameters.length; i++)
    {
        // 获取等号位置
        pos = parameters[i].indexOf('=');
        if(pos == -1) { continue; }

        // 获取name 和 value
        paraName = parameters[i].substring(0, pos);
        paraValue = parameters[i].substring(pos + 1);

        // 如果查询的name等于当前name，就返回当前值，同时，将链接中的+号还原成空格
        if(paraName == name)
        {
            return unescape(paraValue.replace(/\+/g, " "));
        }
    }
    return '';
}
/**
 * 时间转换将2013/01/03字符串转换成2013-01-03
 * */
    function currentTimeType(time){
    var str = new Array();
    str = time.split('');
    var s = "";
    for(var i = 0;i<str.length;i++){

        if(str[i] == '/'){
            s = s + '-';
        }
        else{
            s = s + str[i];
        }
    }
    return s;
}
/*
 * 获取当前时间戳时间格式为2010-05-28 22:13:05
 * */
function nowDateTime(){
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth()+1;
    var days = date.getDate();
    var hours = date.getHours();
    var minutes = date.getMinutes();//获取分钟
    var seconds = date.getSeconds();//获取秒钟
    return (year+'-'+timeToFormat(month)+'-'+timeToFormat(days)+' '+timeToFormat(hours)+':'+timeToFormat(minutes)+':'+timeToFormat(seconds));
}
/*
* 时间加0，例如：2012-1-2 6:5:9 转换为2012-01-02 06:05:09,根据每个数字进行转换
* */
function timeToFormat(time){
    var str = '0';
    if(parseInt(time) < 10){
        str = str +time;
    }
    else{
        str = time;
    }
    return str;
}
/*
* 判断字母是否为大写字母，是返回true，否返回false
* */
function checkIsBF(trainNumber){
    var str = new Array();
    str =  trainNumber.split('');
    var ch = str[0];
    if(((ch.charCodeAt(0)>=65)&&(ch.charCodeAt(0)<=90)) || (parseInt(ch) >= 0 && parseInt(ch) <= 9)){
        return true;
    }
    else{
        return false;
    }
}
/**
 * 汉字和unicode 互转
 * */
function ToUnicode(str) {
    return escape(str).toLocaleLowerCase().replace(/%u/gi, '\\u');
}
function ToGB2312(str) {
    return unescape(str.replace(/\\u/gi, '%u'));
}

/**
 * 返回上一页
 * */
function goToBack(){
    try{
        runtime.os.goBack();
    }catch(e){
        history.go(-1);
    }
}
/**
 * 返回至地图页
 * */
function goToMapView(){
    ctmap.showAppMap();
}