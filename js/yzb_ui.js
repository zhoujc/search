// JavaScript Document
$(document).ready(function(){
//===========基础数值==============
	//页面宽度高度
	yzb_width=$(window).width();
	yzb_height=$(window).height();
	var isOs23=false;//系统版本是否是安卓2.3
	//判断是否是2.3的安卓手机
	if(window.navigator.userAgent.toLowerCase().indexOf("applewebkit/533.1")!=-1){
		isOs23=true;
	}
//==========表单列表样式(yzb_formlist)==============
	//清除浮动
	$("div.yzb_formlist a.list").addClass("fn-clear");
	//针对每一个表单列表
	$("div.yzb_formlist").each(function(){
	    //列表中的所有行
		yzb_formlistdiv=$(this).children("div");
	    //清除浮动
		yzb_formlistdiv.addClass("fn-clear");
	    //对首行和末行加圆角
		yzb_formlistdiv.first("div").addClass("top");
		yzb_formlistdiv.last("div").addClass("bottom");
	});
//==========列表样式(yzb_list)==============
    //清除浮动
	$("ul.yzb_list a.list").addClass("fn-clear");
	//针对每一个表单列表
	$("ul.yzb_list").each(function(){
		//列表中的所有行
		yzb_listdiv=$(this).children("li");
		//清除浮动
		yzb_listdiv.addClass("fn-clear");
		//对首行和末行加圆角
		yzb_listdiv.first("li").addClass("top");
		yzb_listdiv.last("li").addClass("bottom");
	});
//===========input text样式==============
	//获得焦点时改变样式
	$(".yzb_text input").focus(function(){
		$(this).parent().addClass("focus");
	});
	//失去焦点时改变样
	$(".yzb_text input").blur(function(){
		$(this).parent().removeClass("focus");
	});
//===========菜单栏样式(yzb_toolbar)==============
	//点击时改变图标的图片地址，改显示带有_press的PNG图片。
	$("div.yzb_toolbar a.button").on("touchstart",function(){
		//alert("1");
		//取到图标
		iconimg=$(this).children("img")
		//图标地址
		imgsrc=iconimg.attr("src");
		//截取后10位，用于检查是不是_press.png图片
		aa=imgsrc.substr(imgsrc.length-10,imgsrc.length);
		if(aa=="_press.png"){
		}else{
			//换图标，让同名并带有_press.png的图标显示出来
			imgsrc=imgsrc.replace(".png","_press.png");
			iconimg.attr("src",imgsrc);
		}
		//换样式
		$(this).addClass("press");
	});
	//释放点击时改变图标的图片地址，改显示不带有_press的PNG图片。
	$("div.yzb_toolbar a.button").on("touchend",function(){
		//alert("2");
		//取到图标
		iconimg=$(this).children("img")
		//图标地址
		imgsrc=iconimg.attr("src");
		//换图标，让同名并不带_press.png的图标显示出来
		imgsrc=imgsrc.replace("_press.png",".png");
		iconimg.attr("src",imgsrc);
		//换样式
		$(this).removeClass("press");
	});
	//由touch变成move时，释放点击时改变图标的图片地址，改显示不带有_press的PNG图片。
	$("div.yzb_toolbar a.button").on("touchmove",function(){
		//取到图标
		iconimg=$(this).children("img")
		//图标地址
		imgsrc=iconimg.attr("src");
		//截取后10位，用于检查是不是_press.png图片
		aa=imgsrc.substr(imgsrc.length-10,imgsrc.length);
		if(aa=="_press.png"){
			//换图标，让同名并不带_press.png的图标显示出来
			imgsrc=imgsrc.replace("_press.png",".png");
			iconimg.attr("src",imgsrc);
		}		
		//换样式
		$(this).removeClass("press");
	});
//===========按钮(btn)============
	$(".yzb_btn").on("touchstart",function(){
		$(this).addClass("press");
	}).on("touchend",function(){
		$(this).removeClass("press");
	}).on("touchmove",function(){
		$(this).removeClass("press");
	});
//=======================================================================
});