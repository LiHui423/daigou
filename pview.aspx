<%@ Page Language="C#" AutoEventWireup="true" CodeFile="pview.aspx.cs" Inherits="pview" %>

<%@ Register Src="TopHeader.ascx" TagName="TopHeader" TagPrefix="uc1" %>
<%
    LS_J.CheckPost();
    System.Data.DataTable dt = new System.Data.DataTable();
    System.Data.DataTable dt2 = new System.Data.DataTable();
    System.Data.DataTable dt8 = new System.Data.DataTable();
    System.Data.DataTable dtlove = new System.Data.DataTable();
    System.Data.DataTable dtmop = new System.Data.DataTable();
    System.Data.DataTable dt1 = new System.Data.DataTable();

    int page = LS_J.Loadpage();
    int pagesize = 20;  //一页显示多少条

    int id = LS_J.Loadlng(Request.QueryString["id"]);
    if (id == 0)
    {
        Response.Write("<script language=javascript>var resultString;alert('链接参数错误');window.location.href='/';</script>");
        Response.End();
    }

    System.Data.DataRow dr = shangpinlei.GetRow(id.ToString());
    if (dr == null)
    {
        Response.Write("<script language=javascript>var resultString;alert('此商品不存在!');window.location.href='index.aspx';</script>");
        Response.End();
    }
    else
    {
        //如果通过扫二维码进入页面则记录
        string QRCodeType = Request.QueryString["QRCodeType"];
        if (QRCodeType == "1")
        {
            LS_J_SQL.QRcodePageCheck(Convert.ToInt32(QRcode_Type.商品), id.ToString());
        }
    }

    //若商品所属商店关闭则跳转
    if (LS_J_ForCount.CheckShopState(dr["shopid"].ToString()))
    {
        Response.Write("<script>window.location.href='shop_invalid.aspx';</script>");
        Response.End();
    }
    //判断商品是否下架
    if (dr["state"].ToString() == "0")
    {

    }
    else
    {
        Response.Write("<script>window.location.href='Sp_invalid.aspx';</script>");//若商品下架则跳转
        Response.End();
    }

    int memberid = LS_J.Loadlng(LS_J_ForCookies.GetMemberIdCookies());
    if (memberid != 0)
    {
        if (LS_J_SQL.GetDataCount("select Count(*) from [ShangPinSee] where UserId=@memberid and SeeId='" + dr["Number"].ToString() + "' and Type=0 ", "@memberid", memberid.ToString()) == 0)
        {
            LS_J_SQL.ExecuteSQL("insert into [ShangPinSee] (UserId,SeeId,Type,addtime,uptime)values(@memberid,'" + dr["Number"].ToString() + "',0,'" + System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "','" + System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "')", "@memberid", memberid.ToString());
            LS_J_SQL.ExecuteSQL("update [ShangPin] set sSeeNum =sSeeNum+1 where id='" + dr["id"].ToString() + "'");
        }
        else
        {
            LS_J_SQL.ExecuteSQL("update [ShangPinSee] set uptime ='" + System.DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "' where UserId=@memberid and SeeId='" + dr["Number"].ToString() + "' and Type=0 ", "@memberid", memberid.ToString());
            LS_J_SQL.ExecuteSQL("update [ShangPin] set sSeeNum =sSeeNum+1 where id='" + dr["id"].ToString() + "'");
        }
    }
    else
    {
        LS_J_SQL.ExecuteSQL("update [ShangPin] set SeeNum =SeeNum+1 where id='" + dr["id"].ToString() + "'");
    }
    //Response.Write("update [ShangPin] set SeeNum =SeeNum+1 where id='" + dr["id"].ToString() + "'");
    LS_J_SQL.Updateshangpinclicktime(memberid.ToString());

    string OSS = LS_J_ForPic.OssPath();
    //商品搭配
    shangpinLS shangpinL = new shangpinLS();
    String[] ChooseS = dr["guige"].ToString().Split(',');

    String ModelA = "";
    String ModelB = "";
    String ModelC = "";
    String ModelD = "";
    String ModelE = "";
    String ModelF = "";

    for (int i = 0; i < ChooseS.Length; i++)
    {
        String[] ChooseSS = ChooseS[i].Split('|');
        if (i == 0)
        {
            ModelA += ChooseSS[0];
            ModelB += ChooseSS[1];
            ModelC += ChooseSS[2];
            if (ChooseSS.Length >= 4)
            {
                ModelD += ChooseSS[3];
                ModelE += ChooseSS[4];
                ModelF += ChooseSS[5];
            }
        }
        else
        {
            ModelA += "," + ChooseSS[0];
            ModelB += "," + ChooseSS[1];
            ModelC += "," + ChooseSS[2];
            if (ChooseSS.Length >= 4)
            {
                ModelD += "," + ChooseSS[3];
                ModelE += "," + ChooseSS[4];
                ModelF += "," + ChooseSS[5];
            }
        }
    }

    String[] ModelATeam = LS_J.Split(ModelA, ",");
    String[] ModelBTeam = LS_J.Split(ModelB, ",");
    String[] ModelCTeam = LS_J.Split(ModelC, ",");
    String[] ModelDTeam = LS_J.Split(ModelD, ",");
    String[] ModelETeam = LS_J.Split(ModelE, ",");
    String[] ModelFTeam = LS_J.Split(ModelF, ",");


    ModelATeam = LS_J.ClearRepeat(ModelATeam);
    ModelBTeam = LS_J.ClearRepeat(ModelBTeam);
    ModelCTeam = LS_J.ClearRepeat(ModelCTeam);
    ModelDTeam = LS_J.ClearRepeat(ModelDTeam);
    ModelETeam = LS_J.ClearRepeat(ModelETeam);
    ModelFTeam = LS_J.ClearRepeat(ModelFTeam);

    String ModelaTitle = "";
    String ModelbTitle = "";
    String ModelcTitle = "";
    String ModeldTitle = "";
    String ModeleTitle = "";
    String ModelfTitle = "";
    if (LS_J.Loadlng(dr["Modela"].ToString()) != 0) { ModelaTitle = LS_J_SQL.GetModelTitle(dr["Modela"].ToString()); }
    if (LS_J.Loadlng(dr["Modelb"].ToString()) != 0) { ModelbTitle = LS_J_SQL.GetModelTitle(dr["Modelb"].ToString()); }
    if (LS_J.Loadlng(dr["Modelc"].ToString()) != 0) { ModelcTitle = LS_J_SQL.GetModelTitle(dr["Modelc"].ToString()); }
    if (LS_J.Loadlng(dr["Modeld"].ToString()) != 0) { ModeldTitle = LS_J_SQL.GetModelTitle(dr["Modeld"].ToString()); }
    if (LS_J.Loadlng(dr["Modele"].ToString()) != 0) { ModeleTitle = LS_J_SQL.GetModelTitle(dr["Modele"].ToString()); }
    if (LS_J.Loadlng(dr["Modelf"].ToString()) != 0) { ModelfTitle = LS_J_SQL.GetModelTitle(dr["Modelf"].ToString()); }


    DateTime NowTime = DateTime.Now;
    DateTime FinishTime = DateTime.Now;
    TimeSpan Distance = FinishTime - NowTime;
%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="white" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title><%=LS_J_Global.AppTitle() %></title>

    <link href="styles.css" rel="stylesheet" type="text/css" />
    <link href="stylesm.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/jquery.nailthumb.1.0.min.css" />
    <link href="css/idangerous.swiper.css" rel="stylesheet" />
	<link href="css/special_tips.css" rel="stylesheet" type="text/css" />
    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/jquery.nailthumb.1.1.min.js"></script>
    <script src="js/jquery.lazyload.min.js"></script>
    <script src="js/jquery.masonry.min.js"></script>
    <script src="js/idangerous.swiper-2.1.min.js"></script>
    <script src="js/transit.min.js"></script>
    <script src="js/special_tips.js"></script>
    <script>
        $(function () {

            $("#ppcu").click(function () {
                $('#dialogbg').show();
                $('#dialog').show();
            });
            $('#dialog .closethick').click(function () {
                $('#dialogbg').hide();
                $('#dialog').hide();
            });

            $("#nppsh").click(function () {
                $('#dialogbg').show();
                $('#tshare').show();
            });
            $('#tshare .closethick').click(function () {
                $('#dialogbg').hide();
                $('#tshare').hide();
            });

            var curVal = $("#buy-number");
            var hidVal = $("#buynum");
            var temp; //得到文本框当前的数据  

            $("#btn-reduc").click(function () {
                temp = curVal.html();
                if (temp <= 1) {
                    return false;
                }
                if (testNum(temp)) {
                    curVal.html(--temp); //数量减1  
                    hidVal.val(temp);
                    $('#MoneyShow').html(temp * window.sinplePrice);
                }
                else {
                    curVal.html(1);
                    hidVal.val(1);
                }
            });
            $("#btn-ad").click(function () {
                var $tp = $('#ttp');
                var temp = curVal.html();
                var kucun = parseInt($("#InvShow").html());
                if (testNum(temp)) {
                    if (temp < kucun) {
                        curVal.html(++temp); //数量加1  
                        hidVal.val(temp);
                        $('#MoneyShow').html(temp * window.sinplePrice);
                    }
                    else {
                        $tp.html('存貨不足哦').show();
                        intervalo = setTimeout(function (x) {
                            $tp.hide();
                        }, 3000);
                    }
                }
                else {
                    curVal.html(1);
                    hidVal.val(1);
                }
            });

            //得到购买数量，并判断是否是正确格式  
            function testNum(tempNum) {
                if (/^[0-9]+$/.test(tempNum)) {

                    return true;
                } else {

                    temp = curVal.html(1)
                }
            }

            $("#pvbw").click(function () {
                //ModelSelected();
                $('#dialogbg').show();
                $('#iwtts').show();
                $('body').addClass('overflowflow');
            });
            $('#iwtts .closethick').click(function () {
                $('#dialogbg').hide();
                $('#iwtts').hide();
                $('body').removeClass('overflowflow');
            });


            $("#ppin li").click(function () {
                var index = $(this).index();
                $(this).addClass("current").siblings().removeClass("current");
                $("#ppbox li").eq(index).show().siblings().hide();
            })
      
            $('.thumbwrapper').nailthumb({ fitDirection: 'center center', replaceAnimation: null });
  

            var mySwiper = new Swiper('.swiper-container', {
                pagination: false,
                grabCursor: true,
                paginationClickable: true
            })
            $('.arrow-left').on('click', function (e) {
                e.preventDefault()
                mySwiper.swipePrev()
            })
            $('.arrow-right').on('click', function (e) {
                e.preventDefault()
                mySwiper.swipeNext()
            })
        })

        //商品心动
        function Love(k) {
            var $tp=$('#ttp');
            var qe_memberid="<%=memberid%>";
            if(qe_memberid==0){
				noLoginAlert('請先會員登錄哦！',function(){
					window.location.href='login.aspx';
				});
            }
            else{                   
                if($("#ShangPinId"+k).attr("class")=="fa"){//心动
                    $.getJSON("Love.aspx", { "ShangPinId": k,"xindong": "jia", "rand": new Date() }, function (result) {
                        if (result.isOk == 1) {
                            $("#ShangPinId"+k).attr("class","fa cur");                           
                            $("#ShangPinId"+k).find('em').html(parseInt($("#ShangPinId"+k).find('em').html())+1);
                            $tp.html('已成功收藏在您的心動頁了').show();
                            $(".p").html("已心動");
                            intervalo = setTimeout(function (x) {
                                $tp.hide();
                            }, 3000);
                        }                    
                    });
                }
                else{//取消心动
                    $.getJSON("Love.aspx", { "ShangPinId": k,"xindong": "jian", "rand": new Date() }, function (result) {
                        if (result.isOk == 1) {
                            $("#ShangPinId"+k).attr("class","fa");
                            $("#ShangPinId"+k).find('em').html(parseInt($("#ShangPinId"+k).find('em').html())-1);
                            $tp.html('您已取消心動').show();
                            $(".p").html("未心動");
                            intervalo = setTimeout(function (x) {
                                $tp.hide();
                            }, 3000);
                        }                    
                    });
                }
            }            
        }

        //单个商品心动
        function LoveProduct(k) {

            $modal = $('#pop-modal'), $pobg = $('#pobg'), $istar = $('#istar');
            var $tp=$('#ttp');
            var qe_memberid="<%=memberid%>";
            if(qe_memberid==0){
				noLoginAlert('請先會員登錄哦！',function(){
					window.location.href='login.aspx';
				});
            }
            else{                   
                if($("#ShangPinId"+k).attr("class")=="popbtn pal"){//心动
                    $.getJSON("Love.aspx", { "ShangPinId": k,"xindong": "jia", "rand": new Date() }, function (result) {
                        if (result.isOk == 1) {
                            if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)) {
                                $modal.css({ visibility: 'hidden', transform: 'scale(0.1)', opacity: '0' });
                                $pobg.hide();
                            }else{
                                $modal.css({ display: 'none', transform: 'scale(0.1)', opacity: '0' })
                                $pobg.hide()
                            }
                            $("#ShangPinId"+k).attr("class","popbtn palh");                            
                            $("#xdnum").html(parseInt($("#xdnum").html())+1);                         
                            $tp.html('已成功收藏在您的心動頁了').show();
                            $(".p").html("已心動");
                            intervalo = setTimeout(function (x) {
                                $tp.hide();
                            }, 2000);
                        }                    
                    });
                }
                else{//取消心动
                    $.getJSON("Love.aspx", { "ShangPinId": k,"xindong": "jian", "rand": new Date() }, function (result) {
                        if (result.isOk == 1) {
                            if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)) {
                                $modal.css({ visibility: 'hidden', transform: 'scale(0.1)', opacity: '0' });
                                $pobg.hide();
                            }else{
                                $modal.css({ display: 'none', transform: 'scale(0.1)', opacity: '0' })
                                $pobg.hide()
                            }
                            $("#ShangPinId"+k).attr("class","popbtn pal");                           
                            $("#xdnum").html(parseInt($("#xdnum").html())-1);
                            $tp.html('您已取消心動').show();
                            $(".p").html("未心動");
                            intervalo = setTimeout(function (x) {
                                $tp.hide();
                            }, 2000);
                        }                    
                    });
                }
            }            
        }
        function bing(){
            var c = confirm("購買前需綁定手機！");
            if (c == true) {
                window.location.href = "phone_bing.aspx";
            }
        }
    </script>

    <script language="javascript">
        
         <%
        // 先把数据里的值赋值到js里，然后在JS数组里做拆分
        // js变量  ChooseArray = 规格数组   '红|32|'
        // Modela,Modelb,Modelc  = 规格数组拆分后的每列模型内容，去重后的数组
        // PicTupianArray  图片数组
        // MoneyArray  价格数组
        // InventoryArray  库存数组
        // 图片字段里的内容太长，不能直接转到JS，所以这里先转成数组PicTupianTeam，然后从数组里逐个赋值到JS
        String[] PicTupianTeam = dr["Tupian"].ToString().Split(',');
        for (int i = 0; i < PicTupianTeam.Length; i++)
        {
            PicTupianTeam[i] = LS_J.getphoto(PicTupianTeam[i]);
            //Response.Write("PicTupianArray[" + i.ToString() + "]=\"" + PicTupianTeam[i].Replace("\\", "/") + "\";\n");
        }
           %>

        // 图片数组
        // var PicTupianArray = new Array();
        var PicTupianArray = "<%=dr["Tupian"].ToString().Replace("\\", "/")%>";
        
        PicTupianArray=PicTupianArray.split(",");
        //规格数组
        var Choose = "<%=dr["guige"]%>";
        //价钱数组
        var Money = "<%=dr["jiage"]%>";
        //库存数组
        var Inventory = "<%=dr["kucun"]%>";

        

        ChooseArray = Choose.split(",");
        MoneyArray = Money.split(",");
        InventoryArray = Inventory.split(",");

        //声明对应的model
        var Modela = new Array();
        var Modelb = new Array();
        var Modelc = new Array();
        var Modeld = new Array();
        var Modele = new Array();
        var Modelf = new Array();

        //循环给对应的每个model赋值
        for (var i = 0; i < ChooseArray.length; i++) {
            ChooseArrayS = ChooseArray[i].toString().split("|");
            Modela[i] = ChooseArrayS[0];
            Modelb[i] = ChooseArrayS[1];
            Modelc[i] = ChooseArrayS[2];
            Modeld[i] = ChooseArrayS[3];
            Modele[i] = ChooseArrayS[4];
            Modelf[i] = ChooseArrayS[5];
        }
        Modela = distinctArrayImprove(Modela);
        Modelb = distinctArrayImprove(Modelb);
        Modelc = distinctArrayImprove(Modelc);
        Modeld = distinctArrayImprove(Modeld);
        Modele = distinctArrayImprove(Modele);
        Modelf = distinctArrayImprove(Modelf);
        function distinctArrayImprove(arr) {
            var obj = {}, temp = [];
            for (var i = 0; i < arr.length; i++) {
                if (!obj[typeof (arr[i]) + arr[i]]) {
                    temp.push(arr[i]);
                    obj[typeof (arr[i]) + arr[i]] = true;
                }
            }
            return temp;
        }

        //对应的规格标题
        var ModelaTitle = "<%=ModelaTitle%>";
        var ModelbTitle = "<%=ModelbTitle%>";
        var ModelcTitle = "<%=ModelcTitle%>";
        var ModeldTitle = "<%=ModeldTitle%>";
        var ModeleTitle = "<%=ModeleTitle%>";
        var ModelfTitle = "<%=ModelfTitle%>";
        var ChooeseGuige = "";
    </script>

    <script>
        function See(id){
            $.ajax({
                type: 'GET',
                url: "ShangPinSee.ashx",
                async: false,
                dataType: 'json',
                // data to be added to query string:
                data: {
                    "Number":id,
                },
                success: function (data) {
                    console.log(data);
                }
            })
        } 
        //动态显示时间
        var interval = 10;

        function ShowCountDown(year,month,day,Hour,Minute,Second,Millisecond,days,hours,minutes,seconds,milliseconds) 
        { 
            var now = new Date(); 
            var endDate = new Date(year, month - 1, day,Hour,Minute,Second,Millisecond);
            var leftTime=endDate.getTime()-now.getTime();
            var leftsecond = parseInt(leftTime/1000);                       

            var day1=Math.floor(leftTime/(60*60*24*1000)); 
            var hour=Math.floor((leftsecond-day1*24*60*60)/3600); 
            var minute=Math.floor((leftsecond-day1*24*60*60-hour*3600)/60); 
            var second=Math.floor(leftsecond-day1*24*60*60-hour*3600-minute*60); 
            var millisecond = Math.floor(((leftTime%1000)/10));

            var days = document.getElementById(days); 
            days.innerHTML =day1 ;

            var hours = document.getElementById(hours); 
            hours.innerHTML =hour;

            var minutes = document.getElementById(minutes); 
            minutes.innerHTML =minute;

            var seconds = document.getElementById(seconds); 
            seconds.innerHTML =second;

            var milliseconds = document.getElementById(milliseconds);
            milliseconds.innerHTML = millisecond;


            if(day1 == 0  && hour == 0 && minute == 0 && second == 0 && millisecond == 0)
            {
                clearInterval(timer);
            }
        } 

        $(function () {
            var $container = $('#fsb1');
            var currPage = 0;
            var pagesize =<%=pagesize %>;
            var count = <%=LS_J_SQL.GetDataCount("select Count(*) from shangpin where id<>" + id + " and state=0 and shopid=" + dr["shopid"].ToString() + "")%>;
            $(window).on('scroll',function () {
                if (count / pagesize > currPage) {
                    $(".jzmore").hide()
                    Ajax(); 
                }
                else
                {
                    $(".jzmore").show();
                }
                    
                
            });
            function Ajax() {
                var windowHeight = $(window).height();
                var scrollTop = $(window).scrollTop();
                var scrollHeight = $(document).height();
                if(scrollTop + windowHeight >= scrollHeight * 0.8){
                    $(window).off('scroll');
                    stoploading = true;
                    currPage++;
 
                    $.ajax({
                        type: 'GET',
                        url: "page.ashx",
                        // data to be added to query string:
                        data: {
                            "pagesize": pagesize,
                            "shopid":"<%=dr["shopid"].ToString() %>",
                            "id":<%=id%>,
                            "pageno":currPage
                        },
                        // type of data we are expecting in return:
                        async: false,
                        dataType: 'json',
                        timeout: 10000,
                        success: function (data) {
                            $(window).on('scroll',function () {
                                if (count / pagesize > currPage) {
                                    $(".jzmore").hide()
                                    Ajax(); 
                                }
                                else
                                {
                                    $(".jzmore").show();
                                }
                            });
				            
                            $.each(data, function (i, item) {
                                count = item.Count;
                                var div = "";
                                if (item.kucun == 0) {
                                    //div = "<div class='puout'><a href='pview.aspx?id="+item.id+"'>已售完</a></div>"
                                }
                                var img = ""
                                if (item.expertlable != "0") {
                                    img =   "<img src="+item.Pic+">"
                                }
                                if(item.Pic == ''||item.Pic == 'http://mbuy.oss-cn-hongkong.aliyuncs.com' ){
                                    item.Pic = 'images/npbuy.png'
                                }else{
                                    item.Pic = item.Pic
                                }
                                var $app = $("<div class='htbbg'>"+
		                              "<div class='item'>"+
		                              "<div class='mpic'>"+
		                                "<a href='"+item.Address+".aspx?id="+item.id+"'onclick=\"See('"+item.Number+"')\">"+
		                                  "<img src='images/loadimg.jpg' width='154' class='lazy' data-original="+item.Pic+"></a>"+
		
		                              "</div>"+
		                              "<div class='mjt'>"+
		                                "<a href='javascript:void(0)' class='"+item.current+"' onclick='Love("+item.id+")' id='ShangPinId"+item.id+"'><i class='heart'></i><em>"+item.LoveNum+"</em></a>"+
		                                "<div class='mmjt'><em>MOP"+item.Price+"</em></div>"+
		                              "</div>"+
		                              "<div class='ppen'>"+
		                                "<h1>"+item.Title+"</h1>"+
		                              "</div>"+
		                                   div+
		                            "</div>"+
		                          "</div>"+
		                          "<div id='navs' style='display: none;'><a href='?id="+item.id+"&page=1'></a></div>")
                                $container.append($app).masonry('reload')
                                $container.masonry({
                                    itemSelector: '.htbbg',
                                    columnWidth: 160,
                                    transitionDuration: 0
                                });
                                lazy () 
                            });
                        },
                        error: function (xhr, type) {
                            
                        }
                    });
                }
                else
                {

                }
            }
            Ajax();
            function lazy (){
                $(".lazy").lazyload({
                    load: function () {
                        $container.masonry({
                            itemSelector: '.htbbg',
                            columnWidth: 160,
                            transitionDuration: 0
                        });
                    }
                });
            }
            lazy ()    
        });
    </script>
    <style type="text/css" media="screen">
        .square {
            width: 296px;
            height: 296px;
        }

        .mimg {
            width: 142px;
            height: 130px;
        }

        .square1 {
            width: 60px;
            height: 60px;
        }

        .square2 {
            width: 80px;
            height: 80px;
            float: left;
        }

            .square2 img {
                display: block;
                vertical-align: inherit;
            }

        .square4 {
            width: 48px;
            height: 48px;
            float: left;
        }

        @media screen and (min-width: 768px) {
            .square {
                width: 306px;
                height: 304px;
            }
        }

        .swiper-container {
            height: 86px;
            width: 100%;
            float: left;
            position: relative;
        }

        .device .arrow-left {
            background: url(images/arrows.png) no-repeat left top;
            background-size: 8px 30px;
            position: absolute;
            left: 4px;
            top: 50%;
            margin-top: -10px;
            width: 10px;
            height: 15px;
        }

        .device .arrow-right {
            background: url(images/arrows.png) no-repeat left bottom;
            background-size: 8px 30px;
            position: absolute;
            right: 4px;
            top: 50%;
            margin-top: -10px;
            width: 10px;
            height: 15px;
        }

        .ppint_eachBox {
            overflow: hidden;
            border-bottom: #b3b3b3 solid 1px;
        }

            .ppint_eachBox .ppint_eachTitle {
                width: 20%;
                float: left;
                text-align: center;
                height: 30px;
                line-height: 30px;
                font-size: 14px;
                font-weight: bold;
            }

            .ppint_eachBox .ppint_eachMain {
                width: 80%;
                float: left;
            }

                .ppint_eachBox .ppint_eachMain dd {
                    padding: 0px 5px;
                    height: 30px;
                    line-height: 30px;
                    font-size: 14px;
                    text-align: center;
                    font-weight: bold;
                    display: inline-block;
                    color: #FF527C;
                }
    </style>
</head>
<body>
    <uc1:TopHeader ID="TopHeader1" runat="server" />
    <div class="container pv">

            <div class="tooltip-content" id="ttp" style="display: none"></div>
        <div class="popnav wtop" id="popnav">
            <span class="pfbtn shoc" id="istar"></span>
            <span class="pfbtn btop" id="btop"></span>
        </div>
        <div class="pop-modal pmww" id="pop-modal">
            <div class="pop-content" id="pop-content">
                <div class="pop-nav">
                    <ul>
                        <%
                            string loveclass = "popbtn pal";
                            if (LS_J_SQL.GetDataCount("select Count(*) from [Love] where UserId=@memberid and LoveId=@id and Type=0", "@memberid", memberid.ToString(), "@id", id.ToString()) > 0) { loveclass = "popbtn palh"; }
                        %>
                        <li class="ppw1" id="easy_share"><a href="fengxiang?id=<%=id %>&type=0&title=<%=dr["title"] %>&img=<%=dr["Pic2"]%>"><span class="popbtn sha"></span><span class="poptit">分享好友</span></a></li>

                        <li class="ppw2"><a href="###"><span class="<%=loveclass %>" onclick="LoveProduct(<%=id %>)" id='ShangPinId<%=id  %>'></span><span class="poptit p">
                            <!--心動收藏-->
                            <%=loveclass=="popbtn pal"?"未心動":"已心動" %></span></a></li>
                        <li class="ppw3"><a id="reportGoPage" href="new-report.aspx?id=<%=id %>&title=<%=dr["title"]%>&i=7"><span class="popbtn tip"></span><span class="poptit">違規舉報</span></a></li>
                        <script>
	                    	myReportURL = encodeURI(encodeURI($('#reportGoPage').attr('href')));
                    		$('#reportGoPage').attr('href',myReportURL);
	                    </script>
                        <li class="pnitem10">心動商品後，有任何優惠可馬上通知您！</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="md-modal" id="tpop-modal">
            <div class="pop-content pmdc" id="tpop-content"></div>
        </div>
        <div class="pop-overlay" id="pobg"></div>



        <div id="pvcenter">
            <% 
                string jiangjia = "";
                if (dr["jiang"].ToString() != "1")
                {
            %>
            <div class="pvbox">

                <div class="ppic" id="ppic">
                    <div class="thumbwrapper square">
                        <img src="<%=dr["Pic2"].ToString()==""?"images/npbuy.png":LS_J.getphoto(dr["Pic2"].ToString())/*+ OSS_Tail.oss414*/ %>" alt="" onerror="this.src='images/npbuy.png'" />
                    </div>
                </div>
                <div class="nppil clearfix">
                    <dl>
                        <dt>心動</dt>
                        <dd id="xdnum"><%=LS_J.Loadlng(dr["LoveNum"].ToString())+LS_J.Loadlng(dr["sLoveNum"].ToString())%></dd>
                    </dl>
                    <dl>
                        <dt>查看</dt>
                        <dd><%=LS_J.Loadlng(dr["SeeNum"].ToString())+LS_J.Loadlng(dr["sSeeNum"].ToString())%></dd>
                    </dl>
                    <dl>
                        <dt>庫存</dt>
                        <dd><%=shangpinL.GrossKucun(dr["kucun"].ToString())%></dd>
                    </dl>
                    <dl class="npu">
                        <dt class="npu1">已購</dt>
                        <dd><%=LS_J.Loadlng(dr["BuyNum"].ToString())+LS_J.Loadlng(dr["sBuyNum"].ToString())%></dd>
                    </dl>
                </div>
            </div>

            <div class="pvbox pvf">
                <div class="pptjp">
                    <div class="pptjt">商品編號：<em class="mecf"><%=dr["Number"] %></em></div>
                    <div class="pptjc pptxh">
                        <h1><%=dr["title"]%></h1>
                        <p><%=LS_J.cutstr(dr["intro"].ToString(),97)%></p>
                    </div>
                    <div class="pptjcl"></div>
                    <%
                        if (memberid > 0)
                        {
                            int pricesum = LS_J_SQL.GetMemberMoney(memberid.ToString());
                    %>
                    <div class="pptc"><em>mop</em><span></span></div>
                    <% 
                        }
                    %>
                </div>

                <%
                    if (dr["xian"].ToString() == "1")
                    {%>
                <div class="npriceb clearfix">
                    <div class="item1">
                        <p>原價</p>
                        <p><del>MOP<%=dr["CostPrice"]%></del></p>
                    </div>
                    <div class="item2">
                        <div class="dep_down limited">
                            <p style="color: #ff527d; font-size: 15px;">限量價</p>
                            <p style="line-height: 1; font-size: 15px; color: #ff527d;">MOP<%=dr["Price"] %></p>
                        </div>
                    </div>
                    <div class="item1">
                        <p style="color: #000000; font-size: 14px;">只剩<span class="limited_span"><%=dr["x_surplus"] %></span>件</p>
                        <p style="color: #010101; font-size: 12px;">限量價僅推<%=dr["x_only"] %>件</p>
                    </div>

                    <%}
                        else
                        {%>
                    <div class="npriceb clearfix">
                        <span class="npr1">
                            <h3>原價</h3>
                            <em>mop</em><del><%=dr["CostPrice"]%></del>
                            <em class="npr1l">00</em>
                        </span>
                        <span class="npr2">
                            <img src="images/pview_07.jpg" alt=""><em>mop</em>
                            <%
                                if (dr["jiang"].ToString() == "1")
                                { %>
                            <h3><%=dr["depreciate"]%> </h3>
                            <em class="npr1l">00</em>
                            <%
                                }
                                else
                                {
                            %>
                            <h3><%=dr["Price"]%></h3>
                            <em class="npr1l">00</em>
                            <%
                                }
                            %>
                        </span>
                        <%}
                        %>
                    </div>
                    <div class="ppact">
                        <div class="device">
                            <a class="arrow-left" href="#"></a>
                            <a class="arrow-right" href="#"></a>
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide">
                                        <ul class="ssitem">
                                            <% 
                                                string[] a = dr["shangpinlabel"].ToString().Split(',');

                                                for (int i = 0; i < a.Length; i++)
                                                {
                                            %>
                                            <%
                                                dt1 = LS_J_SQL.GetDataTable("select id,picture,LabelName,content from shangpinLabel where id= '" + a[i] + "'");
                                                if (dt1.Rows.Count > 0)
                                                {
                                            %>
                                            <li class="pannd">
                                                <img src="<%=OSS + dt1.Rows[0]["picture"] %>" alt="Alternate Text" />
                                                <div class="pitem" style="display: none">
                                                    <div class="row ptop"></div>
                                                    <div class="row pcenter">
                                                        <img src="<%=OSS + dt1.Rows[0]["picture"] %>" alt="" />
                                                        <p class="row pan01"><%=dt1.Rows[0]["LabelName"] %></p>
                                                        <p><%=dt1.Rows[0]["content"] %></p>
                                                    </div>
                                                    <div class="row pbottom"></div>
                                                </div>
                                            </li>
                                            <%
                                                    }
                                                }
                                            %>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            int c = 0;
                            for (c = 0; c < a.Length; c++)
                            {
                                if (a[c].Count() > 0)
                                {
                                    break;
                                }
                            } %>
                        <%if (a.Length == c)
                        { %>
                        <div class="ppctt">此商品沒有推出任何著數券哦</div>
                        <%}%>
                    </div>
                </div>
                <% 

                    }
                    else
                    {
                        jiangjia = "-" + dr["depreciate"].ToString();
                %>

                <div class="pvbox">

                    <% 
                        NowTime = DateTime.Now;//当前的时间
                        FinishTime = DateTime.Parse(dr["JiangEnd"].ToString());//结束时间
                        Distance = FinishTime - NowTime;//距离团购结束时间（正数为团购已结束）
                    %>
                    <%--if (FinishTime < NowTime)
                    {%>
                <div class="puout"></div>
                <%} --%>
                    <div class="ppic" id="ppic">
                        <div class="thumbwrapper square">
                            <img src="<%=dr["Pic2"].ToString()==""?"images/npbuy.png":dr["Pic2"]%>" alt="" />
                        </div>
                    </div>
                    <div class="nppil clearfix">
                        <dl>
                            <dt>心動</dt>
                            <dd id="xdnum"><%=LS_J.Loadlng(dr["LoveNum"].ToString())+LS_J.Loadlng(dr["sLoveNum"].ToString())%></dd>
                        </dl>
                        <dl>
                            <dt>查看</dt>
                            <dd><%=LS_J.Loadlng(dr["SeeNum"].ToString())+LS_J.Loadlng(dr["sSeeNum"].ToString())%></dd>
                        </dl>
                        <dl>
                            <dt>庫存</dt>
                            <dd><%=LS_J.GrossKucun(dr["kucun"].ToString())%></dd>
                        </dl>
                        <dl class="npu">
                            <dt class="npu1">已購</dt>
                            <dd><%=LS_J.Loadlng(dr["BuyNum"].ToString())+LS_J.Loadlng(dr["sBuyNum"].ToString())%></dd>
                        </dl>
                    </div>
                </div>

                <div class="pvbox pvf">

                    <%--
                    if (FinishTime < NowTime)
                    {
                      %>
                <div class="puoutbg"></div>
                <%} --%>
                    <div class="pptjp ppdrh">
                        <div class="pptjt">商品編號：<em class="mecf"><%=dr["Number"] %></em></div>
                        <div class="pptjc ppdrm">
                            <h1><%=dr["title"]%></h1>
                            <p><%=LS_J.cutstr(dr["intro"].ToString(),60)%></p>
                        </div>
                        <div class="pptjcl ppdrph"></div>

                    </div>
                    <div class="npriceb clearfix">
                        <div class="item1">
                            <p>原價</p>
                            <p><del>MOP<%=dr["CostPrice"]%></del></p>
                        </div>
                        <div class="item2">
                            <div class="dep_down">
                                <p>只限今天</p>
                                <p style="line-height: 1; font-size: 15px;">MOP<%=xianjia(dr["Price"],dr["depreciate"]) %><%--=dr["depreciate"].ToString()--%></p>
                            </div>
                        </div>
                        <div class="item1">
                            <p>平日</p>
                            <p>MOP<%=dr["Price"]%></p>
                        </div>
                    </div>
                    <div class="row dr_tiem">
                        <% 
                            if (FinishTime >= NowTime)
                            {
                        %>
                    距離今天結束:<em id="days<%=dr["id"] %>"></em>天<em id="hours<%=dr["id"] %>"></em>小時<em id="minutes<%=dr["id"] %>"></em>分<em id="seconds<%=dr["id"] %>"></em>秒<em id="millisecond<%=dr["id"] %>"></em>
                        <% 
                            }
                            else
                            {
                        %>
                    距離今天結束:<em>0</em>天<em>0</em>小時<em>0</em>分<em>0</em>秒
                    <% 
                        }
                    %>

                        <script>                                                                                                                          
                            window.setInterval(function(){ShowCountDown(<%=FinishTime.Year%>,<%=FinishTime.Month%>,<%=FinishTime.Day%>,<%= FinishTime.Hour %>,<%= FinishTime.Minute %>,<%= FinishTime.Second %>,<%= FinishTime.Millisecond%>,'days<%=dr["id"] %>','hours<%=dr["id"] %>','minutes<%=dr["id"] %>','seconds<%=dr["id"] %>','millisecond<%=dr["id"] %>');}, interval);                                                 
                        </script>
                    </div>
                    <div class="ppact">
                        <div class="device">
                            <a class="arrow-left" href="#"></a>
                            <a class="arrow-right" href="#"></a>
                            <div class="swiper-container">
                                <div class="swiper-wrapper">
                                    <div class="swiper-slide">
                                        <ul class="ssitem">
                                            <%
                                                string[] a = dr["shangpinlabel"].ToString().Split(',');
                                                for (int i = 0; i < a.Length; i++)
                                                {
                                                    dt1 = LS_J_SQL.GetDataTable("select id,picture,LabelName,content from shangpinLabel where id= '" + a[i] + "'");
                                                    if (dt1.Rows.Count > 0)
                                                    {
                                            %>
                                            <li class="pannd">
                                                <img src="<%=dt1.Rows[0]["picture"] %>" alt="Alternate Text" />
                                                <div class="pitem" style="display: none">
                                                    <div class="row ptop"></div>
                                                    <div class="row pcenter">
                                                        <img src="<%=dt1.Rows[0]["picture"] %>" alt="" />
                                                        <p class="row pan01"><%=dt1.Rows[0]["LabelName"] %></p>
                                                        <p><%=dt1.Rows[0]["content"] %></p>
                                                    </div>
                                                    <div class="row pbottom"></div>
                                                </div>
                                            </li>
                                            <%
                                                    }
                                                }
                                            %>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%
                            int c = 0;
                            for (c = 0; c < a.Length; c++)
                            {
                                if (a[c].Count() > 0)
                                {
                                    break;
                                }
                            } %>
                        <%if (a.Length == c)
                        { %>
                        <div class="ppctt">此商品沒有推出任何著數券哦</div>
                        <%}%>
                        <div class="swsc" style="display: none;">
                            <div class="sitbg"></div>
                            <div class="switem">
                                <div class="sitbc">
                                    <span class="closew">close</span>

                                    <div class="stct">fasdfasdf</div>
                                    <div class="stcc">fasdfasdfadf</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>

                <div class="pvboxr">
                    <div id="ppin" class="clearfix">
                        <ul>
                            <li class="current"><span>商品圖片</span></li>
                            <li><span>商品說明</span></li>
                            <li><span>用戶評價</span></li>
                            <li class="ppinm"><span>查看用戶</span></li>
                        </ul>
                    </div>
                    <div id="ppbox" class="clearfix">
                        <ul>
                            <%
                                //商品圖片
                                dt = LS_J_SQL.GetDataTable("select pic from ProductPic where ProductId=" + dr["id"] + " order by theorder desc,id desc");
                                if (dt.Rows.Count > 0)
                                {
                            %>
                            <li>
                                <div class="ppiimg">
                                    <%for (int i = 0; i < dt.Rows.Count; i++)
                                        {
                                            string bgcolor = "ppifr";
                                            if (System.Math.IEEERemainder(i, 2) == 0) { bgcolor = "ppifl"; }
                                    %>
                                    <img src="<%=LS_J.getphoto(dt.Rows[i]["pic"].ToString())/*+ OSS_Tail.oss414*/ %>" alt="" class="<%=bgcolor %>" />
                                    <%}%>
                                </div>
                            </li>
                            <%
                                }
                                else
                                {
                            %>
                            <li>
                                <div class="nava"></div>
                            </li>
                            <%
                                }
                                //商品說明
                                dt8 = LS_J_SQL.GetDataTable("select * from [productfigure] where ProductId='" + dr["Number"] + "'");
                                if (dt8.Rows.Count > 0)
                                {
                            %>
                            <li class="clearfix" style="display: none;">
                                <div class="ppint">
                                    <%
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName1"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName1"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure1"]%></div>
                                    </div>
                                    <% 
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName2"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName2"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure2"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName3"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName3"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure3"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName4"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName4"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure4"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName5"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName5"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure5"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName6"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName6"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure6"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName7"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName7"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure7"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName8"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName8"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure8"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName9"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName9"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure9"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName10"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName10"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure10"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName11"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName11"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure11"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName12"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName12"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure12"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName13"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName13"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure13"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName14"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName14"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure14"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName15"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName15"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure15"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName16"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName16"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure16"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName17"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName17"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure17"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName18"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName18"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure18"]%></div>
                                    </div>
                                    <%}
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName19"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName19"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure19"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName20"].ToString()))
                                        {
                                    %>
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName20"]%></div>
                                        <div class="ppint_eachMain"><%=dt8.Rows[0]["Figure20"]%></div>
                                    </div>
                                    <%
                                        }
                                        if (dr["explain"].ToString().Length > 3)
                                        {
                                    %>
                                    <dl>
                                        <dd class="ppit6"><%=dr["explain"]%></dd>
                                    </dl>
                                    <%
                                        }
                                    %>
                                </div>
                            </li>
                            <%
                                }
                                else
                                {
                            %>
                            <li style="display: none;">
                                <div class="nava"></div>
                            </li>
                            <%
                                }

                                //用戶評價                            
                                dt8 = LS_J_SQL.GetDataTable("select top 10 A.id,A.userid,A.shangpinid,A.orderid,A.comment,A.miao,A.jia,A.shang,A.standard,A.addtime,B.pic,B.sex,B.name,C.Modela,C.Modelb,C.Modelc from ShangPinComment A left outer join [user] B on(A.userid=B.id) left join ShangPin C on A.shangpinid=C.Number where A.shangpinid='" + dr["Number"].ToString() + "' and A.State=0 order by A.addtime desc,A.id desc");
                                if (dt8.Rows.Count > 0)
                                {
                                    dt = LS_J_SQL.GetDataTable("select Sum(Miao)Miao,Sum(Jia)Jia,Sum(Shang)Shang,Count(ShangPinId) shangpinshu from ShangPinComment where ShangPinId='" + dr["Number"].ToString() + "'");
                                    decimal Miao = Convert.ToDecimal(dt.Rows[0]["Miao"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString());
                                    decimal Jia = Convert.ToDecimal(dt.Rows[0]["Jia"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString());
                                    decimal Shang = Convert.ToDecimal(dt.Rows[0]["Shang"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString());
                                    int Totle = Convert.ToInt32((Miao + Jia + Shang) / 15 * 100);

                                    dt2 = LS_J_SQL.GetDataTable("select top 1  Miao,Jia,Shang from ShangPinComment where ShangPinId='" + dr["Number"].ToString() + "' order by addtime desc");
                                    decimal Miao2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Miao"].ToString()) / Convert.ToDecimal(1), 1);
                                    decimal Jia2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Jia"].ToString()) / Convert.ToDecimal(1), 1);
                                    decimal Shang2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Shang"].ToString()) / Convert.ToDecimal(1), 1);
                                    //int Totle2 = Convert.ToInt32(Math.Round((Miao2 + Jia2 + Shang2) / 15, 1) * 100);
                                    int Totle2 = Convert.ToInt32((Miao2 + Jia2 + Shang2) / 15 * 100);

                                    string MiaoS = "usp_up";
                                    if (Miao2 < Miao) { MiaoS = "usp_do"; }
                                    string JiaG = "usp_up";
                                    if (Jia2 < Jia) { JiaG = "usp_do"; }
                                    string ShangP = "usp_up";
                                    if (Shang2 < Shang) { ShangP = "usp_do"; }
                                    string TotleS = "usp_up";
                                    if (Totle2 < Totle) { TotleS = "usp_do"; }
                            %>
                            <li style="display: none;">
                                <div class="ppcomc clearfix">
                                    <div class="row">

                                        <section class="ueva">
                                            <div class="ueitem">
                                                <div class="usper imgru"><span class="ueva_float"><%=Miao %></span> <span class="<%=MiaoS %>">升</span></div>
                                                <div class="uspt">描述相符</div>
                                            </div>
                                        </section>
                                        <section class="ueva">
                                            <div class="ueitem">
                                                <div class="usper imgru"><span class="ueva_float"><%=Jia %></span>  <span class="<%=JiaG %>">升</span></div>
                                                <div class="uspt">價格合理</div>
                                            </div>
                                        </section>
                                        <section class="ueva">
                                            <div class="ueitem">
                                                <div class="usper imgru"><span class="ueva_float"><%=Shang %></span>  <span class="<%=ShangP %>">升</span></div>
                                                <div class="uspt">商品質量</div>
                                            </div>
                                        </section>
                                        <section class="ueva">
                                            <div class="ueitem">
                                                <div class="usper no_uline"><%=Totle %>%<span class="<%=TotleS %>">升</span></div>
                                                <div class="uspt">近期好評率</div>
                                            </div>
                                        </section>

                                    </div>
                                    <div class="ppctl clearfix">
                                        <%                             
                                            int Check = dt8.Rows.Count;
                                            if (Check > 10)
                                            {
                                                Check = 10;
                                            }
                                            for (int i = 0; i < dt8.Rows.Count; i++)
                                            {
                                                string sex = "myw";
                                                if (dt8.Rows[i]["sex"].ToString() == "Boy") { sex = "mym"; }

                                                string[] Chooses = LS_J.Split(dt8.Rows[i]["standard"].ToString(), "|");
                                                if (LS_J.Loadlng(dt8.Rows[i]["Modela"].ToString()) != 0) { ModelaTitle = LS_J_SQL.GetModelTitle(dt8.Rows[i]["Modela"].ToString()); }
                                                if (LS_J.Loadlng(dt8.Rows[i]["Modelb"].ToString()) != 0) { ModelbTitle = LS_J_SQL.GetModelTitle(dt8.Rows[i]["Modelb"].ToString()); }
                                                if (LS_J.Loadlng(dt8.Rows[i]["Modelc"].ToString()) != 0) { ModelcTitle = LS_J_SQL.GetModelTitle(dt8.Rows[i]["Modelc"].ToString()); }
                                        %>
                                        <dl>
                                            <dt>
                                                <a href="mypro_jou.aspx?userid=<%=dt8.Rows[i]["userid"]%>">
                                                    <img src="<%
                                                        string pic = "";
                                                        if (dt8.Rows[i]["Pic"] == "" || dt8.Rows[i]["Pic"] == null)
                                                        {
                                                            pic = LS_J_ForPic.GetUserNoPhoto();
                                                        }
                                                        else
                                                        {
                                                            pic = dt8.Rows[i]["Pic"].ToString();
                                                        } %><%=OSS + pic%>"
                                                        alt="" class="mepic imgru" /></a>
                                            </dt>
                                            <dd class="ppll1t"><span class="mysx"><%=LS_J.cutstr(dt8.Rows[i]["Name"].ToString(),6) %></span><em class="<%=sex %>"></em></dd>
                                            <dd class="ppll1"><%=dt8.Rows[i]["Comment"] %></dd>
                                            <dd class="ppll2">
                                                <%
                                                    if (Chooses.Count() == 0)
                                                    {%>
                                                <span><%=ModelaTitle %>：未選擇</span>
                                                <%}
                                                    else
                                                    {
                                                        string useChoose = "";
                                                        for (int j = 0; j < Chooses.Count(); j++)
                                                        {
                                                            if (ModelbTitle != "")
                                                            {
                                                                useChoose += Chooses[j] + ",";
                                                            }
                                                        }
                                                        if (!string.IsNullOrWhiteSpace(useChoose))
                                                        {
                                                %>
                                                <span><%=ModelbTitle %>：<%=useChoose.Substring(0,useChoose.Length-1) %></span>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </dd>
                                            <dd class="ppll2"><%=dt8.Rows[i]["addtime"] %></dd>

                                            <!--用户回复-->
                                            <%
                                                System.Data.DataTable PinLun = LS_J_SQL.GetDataTable("select id,respone,ResponeAddTime from [ShangPinComment] where id=" + dt8.Rows[i]["id"] + " and respone<>''");
                                                if (PinLun.Rows.Count > 0)
                                                {
                                                    if (!string.IsNullOrWhiteSpace(PinLun.Rows[0]["respone"].ToString()))
                                                    {
                                                        System.Data.DataTable Store = LS_J_SQL.GetDataTable("select shopPic from [shop] where id=" + dr["shopid"] + "");
                                                        string Pic = "/images/noPhoto.png";
                                                        if (!string.IsNullOrWhiteSpace(Store.Rows[0]["shopPic"].ToString()))
                                                        {
                                                            Pic = "" + Store.Rows[0]["shopPic"] + "";
                                                        }
                                            %>
                                            <dd class="ppll2_reply">
                                                <dl>
                                                    <dt>
                                                        <a href="mypro_jou.aspx?userid=<%=dt8.Rows[i]["UserId"] %>">
                                                            <img src="<%=OSS+Pic %>" alt="" class="mepic imgru"></a>
                                                    </dt>
                                                    <dd class="ppll1t"><span class="mysx">店主有SAY:</span></dd>
                                                    <dd class="ppll1"><%=PinLun.Rows[0]["ResponeAddTime"] %></dd>
                                                    <dd class="ppll2"><%=PinLun.Rows[0]["respone"] %></dd>
                                                </dl>
                                            </dd>
                                            <%}
                                            } %>
                                            <!--用户回复 end-->

                                        </dl>
                                        <%
                                            }
                                            if (dt8.Rows.Count >= 10)
                                            {
                                        %>
                                        <div class="ulbtn"><a href="pview_message.aspx?ShangPinId=<%=dr["Number"].ToString() %>" class="ubtn">點擊查看更多</a> </div>
                                        <%
                                            }
                                        %>
                                    </div>
                                </div>
                            </li>
                            <%
                                }
                                else
                                {
                            %>
                            <li style="display: none;">
                                <div class="nava"></div>
                            </li>
                            <%
                                }

                                //查看用户
                                dt = LS_J_SQL.GetDataTable("select top 16 B.id,B.pic,B.sex,B.account,B.name from [ShangPinSee] A left outer join [user] B on(A.userid=B.id) where A.Type=0 and B.id is not null and A.SeeId='" + dr["Number"].ToString() + "' order by A.uptime desc");
                                if (dt.Rows.Count > 0)
                                {
                            %>
                            <li style="display: none">
                                <div class="ppfind">
                                    <div class="fscl pvcl">
                                        <ul>
                                            <%                                           
                                                for (int i = 0; i < dt.Rows.Count; i++)
                                                {
                                                    string sex = "mywf";
                                                    if (dt.Rows[i]["sex"].ToString() == "Boy") { sex = "mymf"; }
                                            %>
                                            <li>
                                                <%if (dt.Rows[i]["id"].ToString() == memberid + "")
                                                    {%>
                                                <a href="mypro_ck.aspx">
                                                    <%}
                                                        else
                                                        { %>
                                                    <a href="mypro_jou.aspx?userid=<%=dt.Rows[i]["id"]%>">
                                                        <%} %>
                                                        <img src="<%
                                                            string pic = null;
                                                            if (dt.Rows[i]["Pic"] == "" || dt.Rows[i]["Pic"] == null)
                                                            {
                                                                pic = LS_J_ForPic.GetUserNoPhoto();
                                                            }
                                                            else
                                                            {
                                                                pic = dt.Rows[i]["Pic"].ToString();
                                                            } %><%=OSS+ pic+OSS_Tail.oss200 %>"
                                                            alt="" class="imgru chpic" />

                                                    </a><span class="clearfix"><em class="<%=sex %>" style="width: 13px; height: 13px;"></em><%=LS_J.cutstr(dt.Rows[i]["Name"].ToString(),3) %></span>

                                            </li>
                                            <%
                                                }
                                            %>
                                            <li>
                                                <div class="fpyk imgru chpic">
                                                    <%
                                                        int Look = LS_J.Loadlng(dr["SeeNum"].ToString()) + LS_J.Loadlng(dr["sSeeNum"].ToString()) - dt.Rows.Count;
                                                        if (Look < 0)
                                                        {
                                                            Look = 0;
                                                        }
                                                    %>
                                                    <div class="row fpfc1"><%=Look%></div>
                                                    <div class="row fpfc2">遊客</div>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>

                                <% 
                                    if (dt.Rows.Count >= 16)
                                    {
                                %>
                                <div class="ulbtn"><a href="pview_user.aspx?SeeId=<%=dr["Number"].ToString() %>" class="ubtn">點擊查看更多</a> </div>
                                <%
                                    }
                                %>
                            </li>
                            <%
                                }
                                else
                                {
                            %>
                            <li style="display: none;">
                                <div class="nava"></div>
                            </li>
                            <%
                                }
                            %>
                        </ul>
                    </div>
                </div>
                <div id="pppu">
                    <div class="ppput">該店其他商品：</div>
                    <div id="fsb1" class="fsblist">
                    </div>
                    <div class="row ftiele jzmore">
                        <p>OH!　已經沒有其他內容了～</p>
                    </div>

                </div>
            </div>
        </div>
        <div class="tctrl">
            <div class="row tvbg">
                <div class="tvleft">
                    <div class="vtlog"></div>
                    <a href="yeeper_col.aspx?shopid=<%=dr["shopid"] %>" class="tvtitle">進店看看</a>
                </div>
                <div class="tvright">
                    <ul class="tvlnav">
                        <li class="tvbuy cur"><a href="buy_view.aspx">查看購物籃</a></li>
                        <%
                            if (shangpinL.GrossKucun(dr["kucun"].ToString()) == 0)
                            {
                        %>
                        <li class="bnow cur gr"><a href="###">已售完</a></li>
                        <%
                            }
                            //如果是限量商品则判断限量是否足够
                            else if (dr["xian"].ToString() == "1")
                            {
                                int XianLess = Convert.ToInt32(dr["x_surplus"].ToString());
                                if (XianLess == 0)
                                {%>
                        <li class="bnow cur gr"><a href="###">已售完</a></li>
                        <%}
                            else
                            {
                        %>
                        <li id="pvbw" class="bnow cur"><a href="###">我要買</a></li>
                        <%
                                }
                            }
                            else if (dr["jiang"].ToString() == "1" && FinishTime < NowTime)
                            {
                        %>
                        <li class="bnow cur gr"><a href="###">已過期</a></li>
                        <%
                            }
                            else
                            {
                        %>
                        <li id="pvbw" class="bnow cur"><a href="###">我要買</a></li>
                        <%
                            }
                        %>
                    </ul>
                </div>
            </div>
        </div>
        <div id="dialogbg" style="display: none"></div>
        <div id="iwtts" style="display: none">

            <span class="closethick">close</span>
            <div class="iwbox">
                <div class="thumbwrapper1 square2">
                    <img src="<%=PicTupianTeam[0] %>" alt="" id="selectPic" onerror="this.src='images/npbuy.png'" />
                    <script type="text/javascript">
                        $(function(){
                            $('.thumbwrapper1').nailthumb({ fitDirection: 'center center', replaceAnimation: null });
                        })
                    </script>
                </div>
                <dl class="iwbh">
                    <dt class="iwbdt1"><%=dr["title"] %></dt>
                    <dt class="iwbdd3">此商品共已售<span><%=(Convert.ToInt32(dr["BuyNum"].ToString())+Convert.ToInt32(dr["sBuyNum"].ToString())) %>件</span></dt>
                </dl>
                <dl class="iwbd">
                    <dt class="iwbdd1">mop<span id="MoneyShow"></span></dt>
                    <dt class="iwbdd2">庫存<span id="InvShow"></span></dt>

                </dl>
            </div>

            <%
                if (ModelaTitle != "")
                {
            %>
            <div class="iwtsel_gheight scrollBar_0">
            <div class="iwtselBox_zai">
            <div class="iwtsel">
                <h1><%=ModelaTitle%></h1>
                <ul id="model1">
                    <%
                        for (int i = 0; i < ModelATeam.Length; i++)
                        {
                    %>
                    <li id="Modela<%=i %>" onclick="SelectedModela(<%=i %>);" title="<%=ModelATeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelATeam[i] %></li>
                    <%
                        }
                    %>
                </ul>
            </div>
            <%
                }
            %>
            <%
                if (ModelbTitle != "")
                {
            %>
            <div class="iwtsel">
                <h1><%=ModelbTitle%></h1>
                <ul id="model2">
                    <%
                        for (int i = 0; i < ModelBTeam.Length; i++)
                        {
                    %>
                    <li id="Modelb<%=i %>" onclick="SelectedModelb(<%=i %>);" title="<%=ModelBTeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelBTeam[i] %></li>
                    <%
                        }
                    %>
                </ul>
            </div>
            <%
                }
            %>

            <%if (ModelcTitle != "")
                {
            %>
            <div class="iwtsel">
                <h1><%=ModelcTitle%></h1>
                <ul id="model3">
                    <%
                        for (int i = 0; i < ModelCTeam.Length; i++)
                        {
                    %>
                    <li id="Modelc<%=i %>" onclick="SelectedModelc(<%=i %>);" title="<%=ModelCTeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelCTeam[i] %></li>
                    <%
                        }
                    %>
                </ul>
            </div>
            <%
                }
            %>

            <%if (ModeldTitle != "")
                {
            %>
            <div class="iwtsel">
                <h1><%=ModeldTitle%></h1>
                <ul id="model4">
                    <%
                        for (int i = 0; i < ModelDTeam.Length; i++)
                        {
                    %>
                    <li id="Modeld<%=i %>" onclick="SelectedModeld(<%=i %>);" title="<%=ModelDTeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelDTeam[i] %></li>
                    <%
                        }
                    %>
                </ul>
            </div>
            <%
                }
                if (ModeleTitle != "")
                {
            %>
            <div class="iwtsel">
                <h1><%=ModeleTitle%></h1>
                <ul id="model5">
                    <%
                        for (int i = 0; i < ModelETeam.Length; i++)
                        {
                    %>
                    <li id="Modele<%=i %>" onclick="SelectedModele(<%=i %>);" title="<%=ModelETeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelETeam[i] %></li>
                    <%
                        }
                    %>
                </ul>
            </div>
            <%
                }
                if (ModelfTitle != "")
                {
            %>
            <div class="iwtsel">
                <h1><%=ModelfTitle%></h1>
                <ul id="model6">
                    <%
                        for (int i = 0; i < ModelFTeam.Length; i++)
                        {
                    %>
                    <li id="Modelf<%=i %>" onclick="SelectedModelf(<%=i %>);" title="<%=ModelFTeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelFTeam[i] %></li>
                    <%
                        }
                    %>
                </ul>
            </div>
            </div>
            </div>
            <%
                }
            %>
            <form action="pview.aspx" method="post" name="buyform">
                <input type="hidden" name="ModelaChar" id="ModelaChar" value="<%if (ModelaTitle != "") { Response.Write(ModelATeam[0].ToString()); } %>" />
                <input type="hidden" name="ModelbChar" id="ModelbChar" value="<%if (ModelbTitle != "") { Response.Write(ModelBTeam[0].ToString()); } %>" />
                <input type="hidden" name="ModelcChar" id="ModelcChar" value="<%if (ModelcTitle != "") { Response.Write(ModelCTeam[0].ToString()); } %>" />
                <input type="hidden" name="ModeldChar" id="ModeldChar" value="<%if (ModeldTitle != "") { Response.Write(ModelDTeam[0].ToString()); } %>" />
                <input type="hidden" name="ModeleChar" id="ModeleChar" value="<%if (ModeleTitle != "") { Response.Write(ModelETeam[0].ToString()); } %>" />
                <input type="hidden" name="ModelfChar" id="ModelfChar" value="<%if (ModelfTitle != "") { Response.Write(ModelFTeam[0].ToString()); } %>" />
                <input type="hidden" name="ispost" id="ispost" value="1" />
                <input type="hidden" name="spid" id="spid" value="<%=id%>" />
                <input type="hidden" id="ShopId" name="ShopId" value="<%= dr["shopid"] %>" />

                <div class="iwtsel">
                    <h1>購買數量</h1>
                    <div id="winput" class="vgbar">
                        <a href="javascript:void(0)" class="redu" id="btn-reduc">减</a>
                        <div class="rain" contenteditable="false" id="buy-number">1</div>
                        <a href="javascript:void(0)" class="radd" id="btn-ad">加</a>
                        <input type="hidden" name="buynum" id="buynum" value="1" />
                    </div>
                </div>
                <%
                    System.Data.DataTable userInfo = LS_J_SQL.GetDataTable("select phone from [User] where id=@id", "@id", memberid.ToString());
                    bool result = true;
                    if (userInfo.Rows.Count != 0)
                    {
                        string phone = LS_J.Loadchar(userInfo.Rows[0]["phone"].ToString());
                        if (phone == "")
                        {
                            result = false;
                        }
                        else
                        {
                            result = true;
                        }
                    }
                %>
                <div class="iwss">
                    <a href="#" class="iwbtn1" onclick="checkbuy('cart')">加入購物籃</a>
                    <a href="#" class="iwbtn2" <% if (result) { Response.Write("onclick=\"checkbuy('now')\""); } else { Response.Write("onclick=\"bing()\""); } %>>立即購買</a>
                </div>
            </form>
        </div>
        <script src="js/spec.js"></script>
        <script language="javascript">
	        //加入購物籃
	        function checkbuy(str) {
	            var $tp=$('#ttp');
	            var qe_memberid="<%=memberid%>";
	            if(qe_memberid==0){
					noLoginAlert('請先會員登錄哦！',function(){
						window.location.href='login.aspx';
					});
	            }
	            else{
	                //判断商品是否为限量
	                if (<%=dr["xian"].ToString()%>=="1") {
	                    var num= $("#buynum").val();
	                    //判断限量是否足够
	                    var LessNum=<%=Convert.ToInt32(dr["x_surplus"].ToString())%>;
	                    if (LessNum-num<0) {
	                        $tp.html('OH, 該商品暫時沒有貨了！').show();
	                        intervalo = setTimeout(function (x) {
	                            $tp.hide();
	                        }, 3000);
	                        return false;
	                    }
	                }
	                if (ChooeseGuige == "") {
	                    $tp.html('請選擇完規格再購買或添加到購物籃！').show();
	                    intervalo = setTimeout(function (x) {
	                        $tp.hide();
	                    }, 3000);
	                    return false;
	                }
	                else if (InvShow.innerHTML == "0" || InvShow.innerHTML == "0") {
	                    $tp.html('OH, 這規格暫時沒有貨了！').show();
	                    intervalo = setTimeout(function (x) {
	                        $tp.hide();
	                    }, 3000);
	                    return false;
	                }
	                else {
	                    if (str == "now") { 
	                        buyform.action = "buy_view_now.aspx";
	                        buyform.submit();
	                    }
	                    else { 
	                        var ProductId=$("#spid").val();
	                        var Num=$("#buy-number").html();
                            var Choose = $("#ModelaChar").val() + "|" + $("#ModelbChar").val() + "|" + $("#ModelcChar").val() + "|" + $("#ModeldChar").val() + "|" + $("#ModeleChar").val() + "|" + $("#ModelfChar").val();
	                        var ShopId = $("#ShopId").val();
	                        $.getJSON("buy_cart.aspx", { "ShopId":ShopId, "ProductId": ProductId,"Num": Num, "Choose": Choose,"rand": new Date() }, function (result) {
	                            if (result.isOk == 1) {
	                                $tp.html('已加入您的購物籃！').show();
	                                intervalo = setTimeout(function (x) {
	                                    $tp.hide();
	                                }, 3000);
	                            }
	                        });
	                    }
	                    return false;
	                }
	            }
	        }
	        
        </script>

        <div id="dialog" style="display: none">
            <span class="closethick">close</span>
            <div class="cdtop">
                <div class="cdlogin"></div>
                <div class="cdtr">
                    <h3>您的easyBuy專員現在狀態是：</h3>
                    <ul class="cdtd">
                        <li class="cdll"><a href="###" class="current">Online</a></li>
                        <li><a href="###">Away</a></li>
                        <li class="cdlr"><a href="###">Offline</a></li>
                    </ul>
                </div>
            </div>
            <div class="cdtl">
                <dl class="cddl">
                    <dt>
                        <img src="images/pview_49.jpg" alt="" />
                    </dt>
                    <dd>
                        <em>敏敏</em>
                        <h3>（easyBuy專員）:</h3>
                    </dd>
                    <dd>您好啊，有什麼可以幫到您呢？</dd>
                </dl>
                <dl class="cddr">
                    <dt>
                        <img src="images/pview_49.jpg" alt="" /></dt>
                    <dd><em>敏敏</em> </dd>
                    <dd>您好啊，有什麼可以幫到您呢？</dd>
                </dl>
            </div>
            <div class="cdtlb">
                <input type="text" name="s" value="" placeholder="宜買您好，我想問..." />
                <button type="submit" class="cdtls"></button>
            </div>
        </div>
        <div id="Div1" style="display: none"></div>
        <div id="tshare" style="display: none">
            <span class="closethick">close</span>
            <div class="tstop">
                <div class="tslogin"></div>
                <div class="cdtr">
                    <h1>分享並邀請您的好友：</h1>
                    <p>若您分享的朋友購買了此商品您將獲贈該商品售價的2%獎金</p>
                </div>
            </div>
            <div class="tslist">
                <ul>
                    <li class="tsl1"><a href="###">SMS 短訊</a></li>
                    <li class="tsl2"><a href="###">EMAIL</a></li>
                    <li class="tsl3"><a href="http://service.weibo.com/share/share.php?title=澳门商城&url=http://mbuy.820.cn/pview.aspx">新浪微博</a></li>
                    <li class="tsl4"><a href="###">Facebook</a></li>
                    <li class="tsl5"><a href="###">Whatsapp</a></li>
                    <li class="tsl6"><a href="###" onclick="WeiXinShareBtn();">微信朋友圈</a></li>
                    <li class="tsl7"><a href="###">微信</a></li>
                    <li class="tsl8"><a href="###">LINE</a></li>
                </ul>
            </div>
        </div>


        <script>
            $(function () {
                $(".ppcomc .ueva .imgru").each(function(){
                    var ueva_float = Number($(this).find(".ueva_float").text());
                    $(this).find(".ueva_float").html(ueva_float.toFixed(2));
                })
                function mobilecheck() {
                    var check = false;
                    (function (a) { if (/(android|ipad|playbook|silk|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true })(navigator.userAgent || navigator.vendor || window.opera);
                    return check;
                }
                var touchEvent = mobilecheck() ? 'touchstart' : 'click', $modal = $('#pop-modal'), $pobg = $('#pobg'), $istar = $('#istar'), $pannd = $('.pannd'), $popcon = $('#tpop-content'), $tmodal = $('#tpop-modal');
                if (/(iPhone|iPad|iPod|iOS)/i.test(navigator.userAgent)) {
                    $modal.css({ visibility: 'hidden' })
                    $istar.on(touchEvent, function (e) {
                        e.preventDefault;
                        $modal.css({ visibility: 'visible', transform: 'scale(1)', opacity: '1' })
                        $pobg.show();
                    });
                    $tmodal.css({ visibility: 'hidden' })
                    $pannd.on(touchEvent, function (e) {
                        e.preventDefault;
                        $tmodal.css({ visibility: 'visible', transform: 'translateX(-50%),translateY(-50%)', opacity: '1' })
                        var tex = $(this).find('.pitem').html()
                        $popcon.html(tex)
                        $pobg.show();
                    });
                    $pobg.on(touchEvent, function (e) {
                        e.preventDefault;
                        $modal.css({ visibility: 'hidden', transform: 'scale(0.1)', opacity: '0' })
                        $tmodal.css({ visibility: 'hidden',opacity: '0' })
                        $(this).hide()
                    })
                } 
                else {
                    $modal.css({ display: 'none' })
                    $istar.on(touchEvent, function (e) {
                        if ($(this).hasClass("cur")) {
                            e.preventDefault;
                            $modal.css({ display: 'none', transform: 'scale(0.1)', opacity: '0' })
                            $pobg.hide()
                            $(this).removeClass('cur');
                            return false;
                        };
                        e.preventDefault;
                        $modal.css({ display: 'block', transform: 'scale(1)', opacity: '1' })
                        $pobg.show();
                        $(this).addClass('cur');
                    });
                    $tmodal.css({ display: 'none' })
                    $pannd.on(touchEvent, function (e) {
                        if ($(this).hasClass("cur")) {
                            e.preventDefault;
                            $tmodal.css({ display: 'none', opacity: '0' })
                            $pobg.hide()
                            $(this).removeClass('cur');
                            return false;
                        };
                        e.preventDefault;
                        $tmodal.css({ display: 'block',opacity: '1' })
                        var tex = $(this).find('.pitem').html()
                        $popcon.html(tex)
                        $pobg.show();
                        $(this).addClass('cur');
                    });
                    $pobg.on(touchEvent, function (e) {
                        e.preventDefault;
                        $modal.css({ display: 'none', opacity: '0' })
                        $tmodal.css({ display: 'none', opacity: '0' })
                        $(this).hide()
                        $istar.removeClass('cur');
                    })
                }
                $('#btop').on(touchEvent, function (e) { $('html, body').stop(false, true).animate({ scrollTop: 0 }, 'fast'); e.preventDefault; })
            })

            function clearModel(){
                var $li = $("#model1 > li");
                for (var i = 0; i < $li.length; i++) {
                    $li[i].className = "optional";
                }
                var $li2 = $("#model2 > li");
                for (var i = 0; i < $li2.length; i++) {
                    $li2[i].className = "Unable";
                }
                var $li3 = $("#model3 > li");
                for (var i = 0; i < $li3.length; i++) {
                    $li3[i].className = "Unable";
                }
                var $li4 = $("#model4 > li");
                for (var i = 0; i < $li4.length; i++) {
                    $li4[i].className = "Unable";
                }
                var $li5 = $("#model5 > li");
                for (var i = 0; i < $li5.length; i++) {
                    $li5[i].className = "Unable";
                }
                var $li6 = $("#model6 > li");
                for (var i = 0; i < $li6.length; i++) {
                    $li6[i].className = "Unable";
                }
            }
            clearModel();
        </script>
</body>
<script type="text/javascript">
    $(function(){
        addHref()
    })
    function addHref(){
        var test = window.location.href;
        var newstring = test.split('?')
        sessionStorage.setItem("addhref",newstring[0])
    }
</script>
<script>
$(function(){
    if(!!navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)){
		iosScrollFix();
	}
})
function scrollFix(elem) {
    var startY, startTopScroll;
    elem.addEventListener('touchstart', function(event){
        startY = event.touches[0].pageY;
        startTopScroll = elem.scrollTop;
        //当滚动条在最顶部的时候
        if(startTopScroll <= 0)
            elem.scrollTop = 1;
        //当滚动条在最底部的时候
        if(startTopScroll + elem.offsetHeight >= elem.scrollHeight)
            elem.scrollTop = elem.scrollHeight - elem.offsetHeight - 1;
    }, false);
};
function iosScrollFix(){
	scrollFix($('body')[0]);
	scrollFix($('.iwBox')[0]);
	scrollFix($('.dg_detail')[0]);
}


</script>

</html>
