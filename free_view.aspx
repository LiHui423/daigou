<%@ Page Language="C#" AutoEventWireup="true" CodeFile="free_view.aspx.cs" Inherits="free_view" %>

<%@ Register Src="TopHeader.ascx" TagName="TopHeader" TagPrefix="uc1" %>
<%
    LS_J.CheckPost();
    System.Data.DataTable dt = new System.Data.DataTable();
    System.Data.DataTable dt1 = new System.Data.DataTable();
    System.Data.DataTable dt2 = new System.Data.DataTable();
    System.Data.DataTable dt8 = new System.Data.DataTable();
    System.Data.DataTable dtlove = new System.Data.DataTable();

    int page = LS_J.Loadpage();
    int pagesize = 12;  //一页显示多少条

    int memberid = LS_J.Loadlng(LS_J_ForCookies.GetMemberIdCookies());
    //时间对象定义
    DateTime now = System.DateTime.Now;

    string todaynow = System.DateTime.Now.ToString("yyyy-MM-dd");
    string NowTime = LS_J_Global.NowTime();

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

    //判断商品是否下架
    if (dr["state"].ToString() != "0")
    {
        Response.Write("<script>window.location.href='Sp_invalid.aspx';</script>");//若商品下架则跳转
        Response.End();
    }
    //若商品所属商店关闭则跳转
    if (LS_J_SQL.GetDataCount("select top 1 Count(*) from shop where id=@id and(ZTState=2 or ZTState=3)", "@id", dr["shopid"].ToString()) > 1)
    {
        Response.Write("<script>window.location.href='shop_invalid.aspx';</script>");
        Response.End();
    }

    if (LS_J_SQL.GetDataCount("select Count(*) from [ShangPinSee] where UserId=@memberid and SeeId='" + dr["Number"].ToString() + "' and Type=0 ", "@memberid", memberid.ToString()) == 0)
    {
        LS_J_SQL.ExecuteSQL("insert into [ShangPinSee] (UserId,SeeId,Type,addtime,uptime)values(@memberid,'" + dr["Number"].ToString() + "',0,'" + NowTime + "','" + NowTime + "')", "@memberid", memberid.ToString());
        LS_J_SQL.ExecuteSQL("update [ShangPin] set sSeeNum =sSeeNum+1 where id='" + dr["id"].ToString() + "'");
    }
    else
    {
        LS_J_SQL.ExecuteSQL("update [ShangPinSee] set uptime ='" + NowTime + "' where UserId=@memberid and SeeId='" + dr["Number"].ToString() + "' and Type=0 ", "@memberid", memberid.ToString());
        LS_J_SQL.ExecuteSQL("update [ShangPin] set sSeeNum =sSeeNum+1 where id='" + dr["id"].ToString() + "'");
    }

    string CheckHuanNum = dr["h_surplus"].ToString();

    int mop = LS_J.Loadlng(dr["mop"].ToString());
    int integral = LS_J.Loadlng(dr["integral"].ToString());

    //商品搭配
    shangpinLS shangpinL = new shangpinLS();
    String[] ChooseS = LS_J.Split(dr["guige"].ToString(), ",");

    String ModelA = "";
    String ModelB = "";
    String ModelC = "";
    String ModelD = "";
    String ModelE = "";
    String ModelF = "";

    string OSS = LS_J_ForPic.OssPath();
    string NoPic = OSS + LS_J_ForPic.GetNoPhoto();

    for (int i = 0; i < ChooseS.Length; i++)
    {
        String[] ChooseSS = LS_J.Split(ChooseS[i], "|");
        if (i == 0)
        {
            ModelA += ChooseSS[0];
            ModelB += ChooseSS[1];
            ModelC += ChooseSS[2];
            ModelD += ChooseSS[3];
            ModelE += ChooseSS[4];
            ModelF += ChooseSS[5];
        }
        else
        {
            ModelA += "," + ChooseSS[0];
            ModelB += "," + ChooseSS[1];
            ModelC += "," + ChooseSS[2];
            ModelD += "," + ChooseSS[3];
            ModelE += "," + ChooseSS[4];
            ModelF += "," + ChooseSS[5];
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
    <link rel="stylesheet" href="css/special_tips.css" />
    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/jquery.nailthumb.1.1.min.js"></script>
    <script type="text/javascript" src="js/jquery.infinitescroll.min.js"></script>
    <script src="js/idangerous.swiper-2.1.min.js"></script>
    <script src="js/transit.min.js"></script>
	<script src="js/special_tips.js"></script>
    <script>
        $(function () {

            var $container = $('#frelist');

            if (totalpage == 1) {//如果总共只有一页，那就不需要滚动加载效果了  
                $("#navs").remove();
            }

            $container.infinitescroll({
                navSelector: '#navs',    // selector for the paged navigation 
                nextSelector: '#navs a',  // selector for the NEXT link (to page 2)
                itemSelector: '.fritem',     // selector for all items you'll retrieve
                loading: {
                    img: 'images/6RMhx.gif',
                }

            },
                // trigger Masonry as a callback
                function (newElements) {
                    $('.thumbwrapper').nailthumb({method:'resize',fitDirection: 'top left', replaceAnimation: null });
                    $('.thumbwrapper1').nailthumb({method:'resize',fitDirection: 'left center', replaceAnimation: null });
                    $('#frelist1 .fritem:nth-child(2n+0)').addClass('fr')
                    readedpage++;//当前页滚动完后，定位到下一页  
                    if (readedpage >= totalpage) {//如果滚动到超过最后一页，置成不要再滚动。  
                        $("#navs").remove();
                        $container.infinitescroll({ state: { isDone: true } });
                    } else {
                        //'#page-nav a置成下一页的值  
                        $("#navs a").attr("href", "?id=<%=id %>&page=" + readedpage);
                    }
                });
       
            $('#frelist1 .fritem:nth-child(2n+0)').addClass('fr')

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

        });
    </script>
    <script>
        $(function () {
                      
            $('.thumbwrapper').nailthumb({method:'resize',fitDirection: 'top left', replaceAnimation: null });
            $('.thumbwrapper1').nailthumb({method:'resize',fitDirection: 'left center', replaceAnimation: null });
            $('.thumbwrapper4').nailthumb({method:'resize',fitDirection: 'center center', replaceAnimation: null });
            $("#pcflt li").click(function(){
                var index = $(this).index();
                $(this).addClass("current").siblings().removeClass("current");
                $("#pfbox li").eq(index).show().siblings().hide();
            })
				
        });
        var ChooeseGuige = "";
    </script>
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

            $('#nppsh').click(function () {
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
                temp = curVal.html()
                if (temp <= 1) {
                    return false;
                }
                if (testNum(temp)) {
                    curVal.html(--temp); //数量减1  
                    hidVal.val(temp);
                     $('#MoneyShow').html(temp * window.sinplePrice);
                } else {
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
                } else {
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
            };

            $("#pvbw").click(function () {
                //ModelSelected();
                $('#dialogbg').show();
                $('#iwtts').show();
            });

            $('#iwtts .closethick').click(function () {
                $('#dialogbg').hide();
                $('#iwtts').hide();

            });

            $iwtex1 = $('#iwtts .iwbdt2 span:eq(0)')
            $iwtex2 = $('#iwtts .iwbdt2 span:eq(1)')
            $iwbten1 = $('#iwtts ul:eq(0) li')
            $iwbten2 = $('#iwtts ul:eq(1) li')

            $("#ppin li").click(function () {
                var index = $(this).index();
                $(this).addClass("current").siblings().removeClass("current");
                $("#ppbox li").eq(index).show().siblings().hide();
            })

            $('#ppuser .skillbar').each(function () {
                $(this).find('.skillbar-bar').css({
                    width: $(this).attr('data-percent')
                });
            });

            $("#pplev .rateit").bind('rated', function (event, value) { $(this).attr('title', value); })

            $("#pcflt li").click(function () {
                var index = $(this).index();
                $(this).addClass("current").siblings().removeClass("current");
                $("#pfbox li").eq(index).show().siblings().hide();
            })		
            
        })

        //商品心动
        function Love(k) {
            var qe_memberid=<%=memberid%>;
            if(qe_memberid==0){
                noLoginAlert('請先會員登錄哦！',function(){
					window.location.href='login.aspx';
				});
            }
            else{                   
                if($("#ShangPinId"+k).attr("class")=="mag mg3"){//心动
                    $.getJSON("Love.aspx", { "ShangPinId": k,"xindong": "jia", "rand": new Date() }, function (result) {
                        if (result.isOk == 1) {
                            $("#ShangPinId"+k).attr("class","mag current mg3");
                            $("#ShangPinId"+k).html(parseInt($("#ShangPinId"+k).html())+1);
                        }                    
                    });
                }
                else{//取消心动
                    $.getJSON("Love.aspx", { "ShangPinId": k,"xindong": "jian", "rand": new Date() }, function (result) {
                        if (result.isOk == 1) {
                            $("#ShangPinId"+k).attr("class","mag mg3");
                            $("#ShangPinId"+k).html(parseInt($("#ShangPinId"+k).html())-1);
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
                            
                            intervalo = setTimeout(function (x) {
                                $tp.hide();
                            }, 2000);
                            $("#poptit").html("已心動");
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
                            
                            intervalo = setTimeout(function (x) {
                                $tp.hide();
                            }, 2000);
                            $("#poptit").html("未心動");
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
        var PicTupianArray = new Array();
         <%

        String[] PicTupianTeam = LS_J.Split(dr["Tupian"].ToString(), ",");
        for (int i = 0; i < PicTupianTeam.Length; i++)
        {
            Response.Write("PicTupianArray[" + i.ToString() + "]=\"" + PicTupianTeam[i].Replace("\\", "/") + "\";\n");
        }
           %>
        
        var PicTupianArray = "<%=dr["Tupian"]%>";
        
        PicTupianArray=PicTupianArray.split(",");
        var Choose = "<%=dr["guige"]%>";
        var Money = "<%=dr["jiage"]%>";
        var Inventory = "<%=dr["kucun"]%>";

        ChooseArray = Choose.split(",");
        MoneyArray = Money.split(",");
        InventoryArray = Inventory.split(",");

        var Modela = new Array();
        var Modelb = new Array();
        var Modelc = new Array();
        var Modeld = new Array();
        var Modele = new Array();
        var Modelf = new Array();

        for (var i = 0; i < ChooseArray.length; i++) {
            ChooseArrayS = ChooseArray[i].toString().split("|");
            Modela[i] = ChooseArrayS[0];
            Modelb[i] = ChooseArrayS[1];
            Modelc[i] = ChooseArrayS[2];
            Modeld[i] = ChooseArrayS[0];
            Modele[i] = ChooseArrayS[1];
            Modelf[i] = ChooseArrayS[2];
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

        var ModelaTitle = "<%=ModelaTitle%>";
        var ModelbTitle = "<%=ModelbTitle%>";
        var ModelcTitle = "<%=ModelcTitle%>";
        var ModeldTitle = "<%=ModeldTitle%>";
        var ModeleTitle = "<%=ModeleTitle%>";
        var ModelfTitle = "<%=ModelfTitle%>";

    </script>
    <style type="text/css" media="screen">
        .square {
            width: 296px;
            height: 296px;
        }

        .square1 {
            width: 144px;
            height: 144px;
        }


        .square2 {
            width: 72px;
            height: 72px;
        }

        .square3 {
            width: 48px;
            height: 48px;
            float: left;
        }

        .square4 {
            width: 126px;
            height: 26px;
        }

        @media screen and (min-width: 768px) {
            .square {
                width: 306px;
                height: 305px;
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

        .pptjc p {
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 7; /* 控制显示的行数 */
            line-height: 1.5em; /* 对不支持浏览器的 */
            max-height: 10.5em; /* 对不支持浏览器的弥补 */
        }
        .ppint_eachBox{
        	overflow: hidden;
        	border-bottom: #b3b3b3 solid 1px;
        }
        .ppint_eachBox .ppint_eachTitle{
        	width: 20%;
        	float: left;
        	text-align: center;
        	height: 30px;
		    line-height: 30px;
		    font-size: 14px;	
		    font-weight: bold;
        }
        .ppint_eachBox .ppint_eachMain{
        	width: 80%;
        	float: left;
        }
        .ppint_eachBox .ppint_eachMain dd{
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
    <div class="container">
        <div id="pvcenter">
            <%                                           
                if (memberid > 0)
                {
            %>
            <div class="pcbox">
                <div class="fcc clearfix">
                    <dl class="fd1">
                        <dt class="fcci1 ffzf1"></dt>
                        <dd class="fcci3">mop<%=LS_J_SQL.GetUserMop(memberid.ToString()) %></dd>
                        <dd class="fcci2">您的宜買紅包餘額：</dd>
                        <dd class="fcci2b">有效期至<%=LS_J_SQL.GetLastDate() %></dd>
                    </dl>
                    <dl class="fd1">
                        <dt class="fcci1 ffzf2"></dt>
                        <dd class="fcci3"><%=LS_J_SQL.GetUserIntegral(memberid.ToString()) %>分</dd>
                        <dd class="fcci2">您的宜買積分餘額：</dd>
                        <dd class="fcci2b">有效期至<%=LS_J_SQL.GetLastDate() %></dd>
                    </dl>
                </div>
            </div>
            <%
                }
            %>
            <div class="pvbr">

                <div class="pvbox">
                    <div class="ppic" id="ppic">
                        <div class="thumbwrapper4 square">
                            <img src="<%=OSS+dr["Pic2"]/*+OSS_Tail.oss414*/%>" alt="" onerror="this.src='<%=LS_J_ForPic.GetNoPhoto() %>"/>
                        </div>
                    </div>

                    <div class="nppil">
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
            </div>

            <div class="pvbox pvf">
                <div class="pptjp ppthp1">
                    <div class="pptjt">商品編號：<%=dr["Number"] %></div>
                    <div class="pptjc">
                        <h1><%=dr["title"]%></h1>
                        <p><%=dr["intro"]%></p>
                    </div>
                    <div class="pptjcl"></div>
                    <div class="ppbig"><span><%=Math.Round(LS_J.LoadDouble(dr["Price"].ToString())/ LS_J.LoadDouble(dr["CostPrice"].ToString())*10,1)%>折</span></div>
                </div>
                <div class="npriceb clearfix fvnh">
                    <span class="npr1 fvw">
                        <h3>原價</h3>
                        <em>mop</em><del class="npvw"><%=dr["Price"]%></del>
                    </span><span class="npr2 fvw1">
                        <h3>mop<%=(int.Parse(dr["Price"].ToString())-int.Parse(dr["mop"].ToString()))%></h3>
                    </span>
                    <div class="fvw2"><span class="rijzb">紅包抵</span><span class="rijzy">mop<%= dr["mop"] %></span></div>
                </div>
                <div class="ppact">
                    <div class="device">
                        <a class="arrow-left" href="#"></a>
                        <a class="arrow-right" href="#"></a>
                        <div class="swiper-container">
                            <div class="swiper-wrapper">
                                <div class="swiper-slide">
                                    <ul class="ssitem">
                                        <% string[] a = dr["shangpinlabel"].ToString().Split(',');
                                            int Check = 0;
                                            for (int i = 0; i < a.Length; i++)
                                            {
                                                System.Data.DataTable dt10 = LS_J_SQL.GetDataTable("select id,picture,content from shangpinLabel where id= '" + a[i] + "'");
                                                if (dt10.Rows.Count > 0)
                                                {
                                                    Check += 1;
                                                    if (Check > 0)
                                                    {
                                        %>
                                        <li class="pannd">
                                            <img src="<%=dt10.Rows[0]["picture"] %>" alt="Alternate Text" />
                                            <div class="pitem" style="display: none">
                                                <div class="row ptop"></div>
                                                <div class="row pcenter">
                                                    <img src="<%=dt10.Rows[0]["picture"] %>" alt="" />
                                                    <p><%=dt10.Rows[0]["content"] %></p>
                                                </div>
                                                <div class="row pbottom"></div>
                                            </div>
                                        </li>
                                        <% }
                                                }
                                            }%>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%
                        if (Check == 0)
                        {
                    %>
                    <div class="ppctt">此商品沒有推出任何著數券哦</div>
                    <%} %>
                </div>
            </div>

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
                            dt = LS_J_SQL.GetDataTable("select id,pic from ProductPic where ProductId=@id order by theorder desc,id desc", "@id", id.ToString());
                            if (dt.Rows.Count > 0)
                            {
                        %>
                        <li>
                            <div class="ppiimg">
                                <%   
                                    for (int i = 0; i < dt.Rows.Count; i++)
                                    {
                                        string bgcolor = "ppifr";
                                        if (System.Math.IEEERemainder(i, 2) == 0) { bgcolor = "ppifl"; }
                                %>
                                <img src="<%=OSS+dt.Rows[i]["pic"]/*+OSS_Tail.oss828*/%>" alt="" class="<%=bgcolor%>" />
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
                        <li>
                            <div class="nava"></div>
                        </li>
                        <%
                            }
                        %>

                        <%
                            //商品說明
                            dt8 = LS_J_SQL.GetDataTable("select * from [productfigure] where ProductId='" + dr["Number"] + "' ");
                            if (dt8.Rows.Count > 0)
                            {
                        %>
                        <li class="clearfix" style="display: none">
                            <div class="ppint">
                                <%
                                    if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName1"].ToString()))
                                    {
	                                %>
	                                <!--<dl>
	                                    <dt><%=dt8.Rows[0]["FigureName1"]%></dt>
	                                    <%=dt8.Rows[0]["Figure1"]%>
	                                </dl>-->
	                                <div class="ppint_eachBox">
	                                	<div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName1"]%></div>
	                                	<div class="ppint_eachMain"><%=dt8.Rows[0]["Figure1"]%></div>
	                                </div>
	                                <% 
                                    }
                                    if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName2"].ToString()))
                                    {
                                %>
                                <!--<dl>
                                    <dt><%=dt8.Rows[0]["FigureName2"]%></dt>
                                    <%=dt8.Rows[0]["Figure2"]%>
                                </dl>-->
                                <div class="ppint_eachBox">
                                	<div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName2"]%></div>
                                	<div class="ppint_eachMain"><%=dt8.Rows[0]["Figure2"]%></div>
                                </div>
                                <%
                                    }
                                    if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName3"].ToString()))
                                    {
                                %>
                                <!--<dl>
                                    <dt><%=dt8.Rows[0]["FigureName3"]%></dt>
                                    <%=dt8.Rows[0]["Figure3"]%>
                                </dl>-->
                                <div class="ppint_eachBox">
                                	<div class="ppint_eachTitle"><%=dt8.Rows[0]["FigureName3"]%></div>
                                	<div class="ppint_eachMain"><%=dt8.Rows[0]["Figure3"]%></div>
                                </div>
                                <%
                                    }
                                    if (!string.IsNullOrWhiteSpace(dt8.Rows[0]["FigureName4"].ToString()))
                                    {
                                %>
                                <!--<dl>
                                    <dt><%=dt8.Rows[0]["FigureName4"]%></dt>
                                    <%=dt8.Rows[0]["Figure4"]%>
                                </dl>-->
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
                        %>

                        <% 
                            //用戶評價
                            dt8 = LS_J_SQL.GetDataTable("select top 11 A.id,A.userid,A.shangpinid,A.orderid,A.comment,A.miao,A.jia,A.shang,A.standard,A.addtime,B.pic,B.sex,B.name,C.Modela,C.Modelb,C.Modelc from ShangPinComment A left outer join [user] B on(A.userid=B.id) left join ShangPin C on A.shangpinid=C.Number where A.shangpinid='" + dr["Number"].ToString() + "' order by A.addtime desc,A.id desc");
                            if (dt8.Rows.Count > 0)
                            {
                                dt = LS_J_SQL.GetDataTable("select Sum(Miao)Miao,Sum(Jia)Jia,Sum(Shang)Shang,Count(ShangPinId) shangpinshu from ShangPinComment where ShangPinId='" + dr["Number"].ToString() + "'");
                                decimal Miao = Math.Round(Convert.ToDecimal(dt.Rows[0]["Miao"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString()), 1);
                                decimal Jia = Math.Round(Convert.ToDecimal(dt.Rows[0]["Jia"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString()), 1);
                                decimal Shang = Math.Round(Convert.ToDecimal(dt.Rows[0]["Shang"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString()), 1);
                                int Totle = Convert.ToInt32(Math.Round((Miao + Jia + Shang) / 15, 1) * 100);

                                dt2 = LS_J_SQL.GetDataTable("select top 1  Miao,Jia,Shang from ShangPinComment where ShangPinId='" + dr["Number"].ToString() + "' order by addtime desc");
                                decimal Miao2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Miao"].ToString()) / Convert.ToDecimal(1), 1);
                                decimal Jia2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Jia"].ToString()) / Convert.ToDecimal(1), 1);
                                decimal Shang2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Shang"].ToString()) / Convert.ToDecimal(1), 1);
                                int Totle2 = Convert.ToInt32(Math.Round((Miao2 + Jia2 + Shang2) / 15, 1) * 100);

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
                                            <div class="usper imgru"><%=Miao %> <span class="<%=MiaoS %>">升</span></div>
                                            <div class="uspt">描述相符</div>
                                        </div>
                                    </section>
                                    <section class="ueva">
                                        <div class="ueitem">
                                            <div class="usper imgru"><%=Jia %>  <span class="<%=JiaG %>">升</span></div>
                                            <div class="uspt">價格合理</div>
                                        </div>
                                    </section>
                                    <section class="ueva">
                                        <div class="ueitem">
                                            <div class="usper imgru"><%=Shang %>  <span class="<%=ShangP %>">升</span></div>
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
                                        int CheckCount = dt8.Rows.Count;
                                        if (CheckCount > 10)
                                        {
                                            CheckCount = 10;
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
                                                    string pic = null;
                                                    if (dt8.Rows[i]["Pic"] == "" || dt8.Rows[i]["Pic"] == null)
                                                    {
                                                        pic = LS_J_ForPic.GetUserNoPhoto();
                                                    }
                                                    else
                                                    {
                                                        pic = dt8.Rows[i]["Pic"].ToString();
                                                    } %><%=OSS+ pic +OSS_Tail.oss150%>"
                                                    alt="" class="mepic imgru" />
                                            </a>
                                        </dt>
                                        <dd class="ppll1t"><span class="mysx"><%=LS_J.cutstr(dt8.Rows[i]["Name"].ToString(),6) %></span><em class="<%=sex %>"></em></dd>
                                        <dd class="ppll1"><%=dt8.Rows[i]["Comment"] %></dd>
                                        <dd class="ppll2">
                                            <%
                                                if (ModelaTitle != "")
                                                {
                                                    if (Chooses.Length>0)
                                                    {
                                                    %>
                                                    <span><%=ModelaTitle %>：<%=Chooses[0] %></span>
                                                    <%
                                                    }
                                                }
                                                if (ModelbTitle != "")
                                                {
                                            if (Chooses.Length>1)
                                                    {
                                                    %>
                                                    <span><%=ModelaTitle %>：<%=Chooses[1] %></span>
                                                    <%
                                                    }
                                                }
                                                if (ModelcTitle != "")
                                                {
                                            if (Chooses.Length>2)
                                                    {
                                                    %>
                                                    <span><%=ModelaTitle %>：<%=Chooses[2] %></span>
                                                    <%
                                                    }
                                                }
                                            %>
                                        </dd>
                                        <dd class="ppll2"><%=dt8.Rows[i]["addtime"] %></dd>
                                        <!--用户回复-->
                                        <%
                                            System.Data.DataTable PinLun = LS_J_SQL.GetDataTable("select id,respone,ResponeAddTime,respone from [ShangPinComment] where id=" + dt8.Rows[i]["id"] + " and respone<>''");
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
                                    %>

                                    <%  if (dt8.Rows.Count >= 10)
                                        {
                                    %>
                                    <div class="ulbtn"><a href="pview_message.aspx?ShangPinId=<%=dr["Number"].ToString() %>" class="pvbtn">點擊查看更多</a> </div>
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
                        %>

                        <%
                            //查看用户
                            dt = LS_J_SQL.GetDataTable("select top 16 B.id,B.pic,B.sex,B.account,B.name from [ShangPinSee] A left outer join [user] B on(A.userid=B.id) where A.Type=0 and b.id is not null and A.SeeId='" + dr["Number"].ToString() + "' order by A.uptime desc");
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
                                        <li><a href="mypro_jou.aspx?userid=<%=dt.Rows[i]["id"]%>">

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
                                                alt="" class="chpic imgru" />

                                        </a><span class="clearfix"><em class="<%=sex%>"></em><%=LS_J.cutstr(dt.Rows[i]["Name"].ToString(), 3)%></span></li>
                                        <%
                                            }
                                        %>
                                        <li>
                                            <div class="fpyk imgru chpic">
                                                <%
                                                    int Look = LS_J.Loadlng(dr["SeeNum"].ToString()) + LS_J.Loadlng(dr["sSeeNum"].ToString()) - dt.Rows.Count;
                                                    if (Look<0)
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
                            <div class="ulbtn"><a href="pview_user.aspx?SeeId=<%=dr["Number"].ToString() %>" class="pvbtn">點擊查看更多</a> </div>
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

            <div class="fflist">
                <div id="pcflt" class="pwflt">
                    <ul>
                        <li class="current"><span>今日換領</span></li>
                        <li><span>即將上架</span></li>
                        <li><span>關於換領</span></li>
                    </ul>
                </div>

                <div class="frbox" id="pfbox">

                    <ul>
                        <!--今日换领-->
                        <li id="frelist1">
                            <%                             
                                int NowP = 0;
                                int Mop = 0;
                                dt = LS_J_SQL.GetItem("shangpin", "id,shopid,pic,title,costprice,price,h_surplus,mop,buynum,sbuynum", "mian=1 and state=0 and reg_date<='" + todaynow + "'", "mianid desc,id desc", pagesize, page);

                                int pagecount = db.pagecount;
                                int rscount = db.recordcount;

                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    NowP = Convert.ToInt32(dt.Rows[i]["price"].ToString());
                                    Mop = Convert.ToInt32(dt.Rows[i]["mop"].ToString());
                                    dt1 = LS_J_SQL.GetDataTable("select * from [shop] where id=" + dt.Rows[i]["shopid"] + " order by theorder desc,id desc");
                            %>
                            <div class="fritem">
                                <div class="ilbox">
                                    <div class="thumbwrapper square1">
                                        <a href="free_view.aspx?id=<%=dt.Rows[i]["id"] %>">
                                            <img src="<%=OSS+dt.Rows[i]["pic"]+OSS_Tail.oss414 %>" alt="" onerror="this.src='<%=LS_J_ForPic.GetNoPhoto() %>'"/></a>
                                    </div>
                                    <div class="filogo">
                                        <div class="thumbwrapper1 square4">
                                            <a href="yeeper_col.aspx?shopid=<%=dt1.Rows[0]["id"] %>">
                                                <img src="<%=OSS+dt1.Rows[0]["logo"] %>" alt="" /></a>
                                        </div>
                                    </div>
                                </div>
                                <div class="irbox">
                                    <div class="irtil"><%=dt.Rows[i]["title"] %></div>
                                    <div class="irjz">
                                        <div class="irjzl"><del class="irjzd">mop<%=NowP %></del><span class="rijzy">mop <%= (NowP - Mop)%></span></div>
                                        <div class="irjzr"><span class="irjzd">已換<%=(Convert.ToInt32(dt.Rows[i]["buynum"].ToString()) + Convert.ToInt32(dt.Rows[i]["sbuynum"].ToString())) %></span>
                                            <span class="rijzy">剩<%=dt.Rows[i]["h_surplus"]%>件</span></div>
                                    </div>
                                    <div class="irbq"><span class="rijzb">紅包抵</span><span class="rijzy">mop<%=Mop %></span></div>
                                </div>
                            </div>
                            <%
                                }
                            %>
                            <div id="navs" style="display: none;"><a href="?id=<%=id %>&page=1"></a></div>
                        </li>
                        <script>
                            var totalpage = <%=pagecount%>;//这里是从服务端得到总共分页数  
                            var readedpage = 1;//当前滚动到的页数
                        </script>
                        <!--今日换领-->

                        <!--即将开始-->
                        <% 
                            dt1 = LS_J_SQL.GetDataTable("select reg_date from [shangpin] where mian=1 and state=0 group by reg_date");
                            if (dt1.Rows.Count > 0)
                            {
                        %>
                        <li style="display: none;">
                            <%            
                                for (int i = 0; i < dt1.Rows.Count; i++)
                                {
                                    dt = LS_J_SQL.GetDataTable("select id,pic,title from [shangpin] where mian=1 and state=0 and reg_date='" + dt1.Rows[i]["reg_date"] + "' and reg_date>'" + todaynow + "' order by mianid desc,id desc");
                                    if (dt.Rows.Count > 0)
                                    {
                            %>

                            <div class="thuph"><%=dt1.Rows[i]["reg_date"]%> 即將開團</div>
                            <div id="Div1">
                                <%
                                    for (int j = 0; j < dt.Rows.Count; j++)
                                    {
                                %>
                                <div class="thitme">
                                    <a href="###">
                                        <div class="thumbwrapper square1">
                                            <img src="<%=OSS+dt.Rows[j]["Pic"] %>" alt="" onerror="this.src='images/npbuy.png'"/>
                                        </div>
                                    </a><span class="thit"><%=dt.Rows[j]["title"] %></span>
                                </div>
                                <%  
                                    }
                                %>
                            </div>
                            <%
                                    }
                                }
                            %>
                        </li>
                        <%
                            }
                            else
                            {
                        %>
                        <div class="nava"></div>
                        <%
                            }
                        %>

                        <!--即将开始-->
                        <% 
                            dt = LS_J_SQL.GetDataTable("select id,chuncontent from messclass where id=10132");
                            if (dt.Rows.Count > 0)
                            {
                        %>
                        <li style="display: none">
                            <%=dt.Rows[0]["chuncontent"] %>                          
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
        </div>

        <div class="row ftiele ">
            <p>"OH!　已經沒有其他內容了～"</p>
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
                        //如果是限量商品则判断限量是否足够
                        if (dr["mian"].ToString() == "1")
                        {
                            int HuanLess = Convert.ToInt32(dr["h_surplus"].ToString());
                            if (HuanLess <= 0)
                            {%>
                    <li class="bnow cur gr"><a href="###">已售完</a></li>
                    <%}
                            else
                            {%>
                    <li id="pvbw" class="bnow cur"><a href="###">我要買</a></li>
                            <%}
                        }
                        else if (shangpinL.GrossKucun(dr["kucun"].ToString()) == 0)
                        {
                    %>
                    <li class="bnow cur gr"><a href="###">已售完</a></li>
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
            <img src="<%=OSS+ dr["Pic"] %>" alt="" class="iwimg" id="selectPic" />

            <dl class="iwbh">
                <dt class="iwbdt1"><%=dr["title"] %></dt>
                <dt class="iwbdd3">此商品共已售<span><%=dr["BuyNum"] %>件</span></dt>
            </dl>
            <dl class="iwbd">
                <dt class="iwbdd1">mop<span id="MoneyShow"></span></dt>
                <dt class="iwbdd2">庫存<span id="InvShow"></span></dt>
            </dl>
        </div>
        <%if (ModelaTitle != "")
            {
        %>
        <div class="iwtsel">
            <h1><%=ModelaTitle%></h1>
            <ul id="model1">
                <%
                    for (int i = 0; i < ModelATeam.Length; i++)
                    {
                %>
                <li id="Modela<%= i %>" onclick="SelectedModela(<%=i %>);" title="<%=ModelATeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelATeam[i] %></li>
                <%
                    }
                %>
            </ul>
        </div>
        <%
            }
        %>

        <%if (ModelbTitle != "")
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
        %>
        <%if (ModeleTitle != "")
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
        %>
        <%if (ModelfTitle != "")
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
            <input type="hidden" name="spid" id="spid" value="<%= id %>" />
            <input type="hidden" name="ispost" id="ispost" value="1" />
            <input type="hidden" id="ShopId" name="ShopId" value="<%= dr["shopid"] %>" />

            <div class="iwtsel">
                <h1>購買數量</h1>
                <div id="winput" class="vgbar">
                    <a href="javascript:void(0)" class="redu" id="btn-reduc">减</a>
                    <div class="rain" contenteditable="false" id="buy-number">1</div>
                    <input type="hidden" name="buynum" id="buynum" value="1" />
                    <a href="javascript:void(0)" class="radd" id="btn-ad">加</a>
                </div>
            </div>
            <%
                System.Data.DataTable userInfo = LS_J_SQL.GetDataTable("select id,phone from [User] where id=@id", "@id", memberid.ToString());
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
            <div class="iwss"><a href="####" class="iwbtn1" onclick="checkbuy('cart')">加入購物籃</a><a href="####" class="iwbtn2" <% if (result) { Response.Write("onclick=\"checkbuy('now')\""); } else { Response.Write("onclick=\"bing()\""); } %>>立即購買</a></div>
        </form>
    </div>
    <script src="js/spec.js"></script>
    <script type="text/javascript">
        //加入購物籃
        function checkbuy(str) {
            var $tp=$('#ttp');
            var BuyNum=document.getElementById("buynum").value;
            var qe_memberid="<%=memberid%>";
            var CheckHuanNum=<%=CheckHuanNum%>;
            if(qe_memberid==0){
                noLoginAlert('請先會員登錄哦！',function(){
					window.location.href='login.aspx';
				});
            }
            else{
                if (ChooeseGuige == "") {
                    $tp.html('請選選完規格再購買或添加到購物籃！').show();
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
                else if (CheckHuanNum<=0) {
                    $tp.html('該商品已被全部換領！').show();
                    intervalo = setTimeout(function (x) {
                        $tp.hide();
                    }, 3000);
                    return false;
                }
                    //检查换领余量
                else if (BuyNum>CheckHuanNum) {
                    $tp.html('該商品換領數量不足！').show();
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
                        var Choose=$("#ModelaChar").val()+"|"+$("#ModelbChar").val()+"|"+$("#ModelcChar").val();
                        var ShopId = $("#ShopId").val();
                        //alert(ShopId);
                        $.getJSON("buy_cart.aspx", { "ShopId":ShopId, "ProductId": ProductId,"Num": Num, "Choose": Choose,"rand": new Date() }, function (result) {
                            //$tp.html(result.isOk).show();
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
                    <img src="images/pview_49.jpg" alt="" /></dt>
                <dd><em>敏敏</em>
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
                <li class="tsl3"><a href="http://service.weibo.com/share/share.php?title=澳门商城&url=http://mbuy.820.cn/free_view.aspx">新浪微博</a></li>
                <li class="tsl4"><a href="###">Facebook</a></li>
                <li class="tsl5"><a href="###">Whatsapp</a></li>
                <li class="tsl6"><a href="###">微信朋友圈</a></li>
                <li class="tsl7"><a href="###">微信</a></li>
                <li class="tsl8"><a href="###">LINE</a></li>
            </ul>
        </div>
    </div>
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
                        string loveText = "未心動";
                        if (LS_J_SQL.GetDataCount("select Count(*) from [Love] where UserId=@memberid and LoveId=@id and Type=0", "@memberid", memberid.ToString(), "@id", id.ToString()) > 0) { loveclass = "popbtn palh"; loveText = "已心動"; }
                    %>
                    <li class="ppw1"><a href="fengxiang?id=<%=id %>&type=0&title=<%=dr["title"] %>&img=<%=dr["Pic2"]%>"><span class="popbtn sha"></span><span class="poptit">分享好友</span></a></li>
                    <li class="ppw2"><a href="###"><span class="<%=loveclass %>" onclick="LoveProduct(<%=id %>)" id='ShangPinId<%=id  %>'></span><span class="poptit" id="poptit">
                        <!--心動收藏-->
                        <%=loveText %></span></a></li>
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
        <div class="pop-content pmdc" id="tpop-content">
        </div>

    </div>

    <div class="pop-overlay" id="pobg"></div>

    <script>
        $(function () {

            function mobilecheck() {

                var check = false;
                (function (a) { if (/(android|ipad|playbook|silk|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true })(navigator.userAgent || navigator.vendor || window.opera);
                return check;
            }

            var touchEvent = mobilecheck() ? 'touchstart' : 'click', $modal = $('#pop-modal'), $pobg = $('#pobg'), $istar = $('#istar'),$tmodal = $('#tpop-modal'),$pannd = $('.pannd'), $popcon = $('#tpop-content');


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

            } else {

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
        }
        clearModel();
    </script>
</body>
</html>
