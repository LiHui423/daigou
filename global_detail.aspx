<%@ Page Language="C#" AutoEventWireup="true" CodeFile="global_detail.aspx.cs" Inherits="global_detail" %>
<%@ Register Src="TopHeader.ascx" TagName="TopHeader" TagPrefix="uc1" %>
<%@ Register Src="~/header.ascx" TagPrefix="uc1" TagName="header" %>

<%
    LS_J.CheckPost();
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

    System.Data.DataTable ShopInfo = LS_J_SQL.GetDataTable("select id,shopname,Shoppic,ZTState,recycle from [shop] where id=" + dr["shopid"].ToString() + "");
    //若商品所属商店关闭则跳转
    if (ShopInfo.Rows.Count > 0)
    {
        int ZTState = LS_J.Loadlng(ShopInfo.Rows[0]["ZTState"].ToString());
        int recycle = LS_J.Loadlng(ShopInfo.Rows[0]["recycle"].ToString());
        if (ZTState == 1 || ZTState == 3 || ZTState == 4 || recycle == -1)
        {
            Response.Write("<script>window.location.href='shop_invalid.aspx';</script>");
            Response.End();
        }
    }
    else
    {
        Response.Write("<script>window.location.href='shop_invalid.aspx';</script>");
        Response.End();
    }
    //若商品所属商店关闭则跳转
    //if (LS_J_ForCount.CheckShopState(dr["shopid"].ToString()))
    //{
    //    Response.Write("<script>window.location.href='shop_invalid.aspx';</script>");
    //    Response.End();
    //}

    //判断商品是否下架
    if (dr["state"].ToString() != "0")
    {
        Response.Write("<script>window.location.href='Sp_invalid.aspx';</script>");//若商品下架则跳转
        Response.End();
    }

    int memberid = LS_J.Loadlng(LS_J_ForCookies.GetMemberIdCookies());
    string NowTime = LS_J_Global.NowTime();

    if (memberid != 0)
    {
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
    }
    else
    {
        LS_J_SQL.ExecuteSQL("update [ShangPin] set SeeNum =SeeNum+1 where id='" + dr["id"].ToString() + "'");
    }
    LS_J_SQL.Updateshangpinclicktime(memberid.ToString());

    //商品搭配
    shangpinLS shangpinL = new shangpinLS();
    String[] ChooseS = LS_J.Split(dr["guige"].ToString(), ",");

    String ModelA = "";
    String ModelB = "";
    String ModelC = "";
    String ModelD = "";
    String ModelE = "";
    String ModelF = "";

    for (int i = 0; i < ChooseS.Length; i++)
    {
        String[] ChooseSS = LS_J.Split(ChooseS[i], "|");
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


    int count = LS_J_SQL.GetDataCount("select Count(*) from [shangpin] A left join [user] B on A.StartFor=B.id left join [shop] S on A.shopid=S.id left join ExchangeTable E on A.ExchangeId=E.id where A.dai=1 and A.id<>" + id + " and S.id=" + dr["shopid"] + "");
    string jiangjia = "";
    if (dr["jiang"].ToString() == "1")
    {
        jiangjia = "-" + dr["depreciate"].ToString();
    }

    //取得代购相关汇率计算
    System.Data.DataTable SetTable = LS_J_SQL.GetDataTable("select percentage,KGmutliple from SetTable");

    //计算汇率（取得对应汇率计算）
    System.Data.DataTable HuiLvTable = LS_J_SQL.GetDataTable("select currency,exchange from ExchangeTable where id=" + dr["ExchangeId"] + "");

    string HuiLvName = "暫無數據";
    decimal HuiLv = 0;
    decimal Price = 0;

    if (!string.IsNullOrWhiteSpace(dr["ExchangeId"].ToString()) && dr["ExchangeId"].ToString() != "0")
    {
        HuiLvName = HuiLvTable.Rows[0]["currency"].ToString();//货币名称
        HuiLv = Convert.ToDecimal(HuiLvTable.Rows[0]["exchange"].ToString());
        Price = Convert.ToDecimal(dr["Price"].ToString());
    }
    //价钱×汇率
    decimal FinallyPrice = Price * HuiLv;
    //向上取整
    FinallyPrice = Math.Ceiling(FinallyPrice);

    //计算汇率（取得对应汇率计算）
    System.Data.DataTable KuaiDiTable = LS_J_SQL.GetDataTable("select currency,exchange from ExchangeTable where id=" + dr["YunFeiExId"] + "");

    string KuaiDiName = "暫無數據";
    decimal KuaiDi = 0;
    decimal KuaiDiPrice = 0;

    if (!string.IsNullOrWhiteSpace(dr["YunFeiExId"].ToString()) && dr["YunFeiExId"].ToString() != "0")
    {
        KuaiDiName = KuaiDiTable.Rows[0]["currency"].ToString();//货币名称
        KuaiDi = Convert.ToDecimal(KuaiDiTable.Rows[0]["exchange"].ToString());
        KuaiDiPrice = Convert.ToDecimal(dr["YunFei"].ToString());
    }
    //運費×汇率
    decimal FinallyKuaiDi = KuaiDiPrice * KuaiDi;
    //向上取整
    FinallyKuaiDi = Math.Ceiling(FinallyKuaiDi);

    string OSS = LS_J_ForPic.OssPath();
    string OssLast = OSS_Tail.oss70;

    System.Data.DataTable dt;
    System.Data.DataTable dt1;
    System.Data.DataTable dt2;
    System.Data.DataTable dt8;

    System.Data.DataTable UserMsg = LS_J_SQL.GetDataTable("select id,name,pic from [user] where id=" + dr["StartFor"] + "");
    string userName = UserMsg.Rows[0]["name"].ToString();
    string userPic = UserMsg.Rows[0]["pic"].ToString();
%>

<!DOCTYPE html>
<html>

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="apple-mobile-web-app-capable" content="yes">
		<meta name="apple-mobile-web-app-status-bar-style" content="white">
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
		<meta content="telephone=no" name="format-detection">
		<meta content="email=no" name="format-detection">
		<title>
			<%=LS_J_Global.AppTitle() %>
		</title>
		<link rel="stylesheet" type="text/css" href="styles.css" />
		<link rel="stylesheet" type="text/css" href="globalPurchasing/css/global_common.css" />
		<link rel="stylesheet" type="text/css" href="globalPurchasing/css/global_detail.css" />
		<link href="css/special_tips.css" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="css/swiper4.0.min.css">
		
		<script src="publish/publishjs/plug/setRem.js"></script>
		<script src="js/waterFall.js"></script>
		<script src="js/jquery-3.2.1.min.js"></script>
		
		<script src="js/special_tips.js"></script>
		<script src="js/swiper4.0.min.js"></script>

		
		<!--规格核心代码-->
		<script language="javascript">
			<%
            // 图片数组
            String[] PicTupianTeam = null;
            if (!string.IsNullOrWhiteSpace(dr["Tupian"].ToString()))
            {
                PicTupianTeam = dr["Tupian"].ToString().Split(',');
            }
			%>
            var PicTupianArray = "<%=dr["Tupian"].ToString().Replace("\\","/")%>";
            PicTupianArray=PicTupianArray.split(",");
            if(PicTupianArray[PicTupianArray.length-1] === ""){
                PicTupianArray.pop();
            }
            $.each(PicTupianArray,function(key,value){
                if(value === ""){
				    PicTupianArray[key] = "<%=dr["pic"] %>";
			    }
            })
            console.log(PicTupianArray);
            //主图（规格图组为空时展示主图）
            var MainPic = "<%=dr["pic"].ToString().Replace("\\","/")%>";
			//规格数组
            var Choose = "<%=dr["guige"]%>";
            //重量数组
            var Weight = "<%=dr["Weight"]%>";
            //源价钱数组
            var oldMoney = "<%=dr["ChengBen"]%>";
			//价钱数组
			var Money = "<%=dr["jiage"]%>";
			//库存数组
            var Inventory = "<%=dr["kucun"]%>";

            //运费
            var YF =<%=dr["YunFei"]%>;
            //价格汇率
            var HuiLv =<%=HuiLv%>;
            //运费汇率
            var YFHuiLv =<%=KuaiDi%>;

            //代購收取百分比
            var Percentage =<%=SetTable.Rows[0]["Percentage"]%>;
            //公斤倍數
            var KGmutliple =<%=SetTable.Rows[0]["KGmutliple"]%>;


            ChooseArray = Choose.split(",");
            oldMoneyArray = oldMoney.split(",");
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
			var ModelaTitle = "<%=ModelaTitle%>";
			var ModelbTitle = "<%=ModelbTitle%>";
			var ModelcTitle = "<%=ModelcTitle%>";
			var ModeldTitle = "<%=ModeldTitle%>";
			var ModeleTitle = "<%=ModeleTitle%>";
			var ModelfTitle = "<%=ModelfTitle%>";
            var ChooeseGuige = "";

            //去除用戶評價中两位后的點
            $(function () {
                $(".ppcomc .ueva .imgru").each(function () {
                    var ueva_float = Number($(this).find(".ueva_float").text());
                    $(this).find(".ueva_float").html(ueva_float.toFixed(2));
                })
            })
		</script>
	</head>

	<body class="scrollBar_0">
		<!-- 模態框 (大框)-->
		<div class="pop-overlay" id="pobg" style="display:none"></div>
		<!-- 模態框 (小框)-->
		<div class="md-modal" id="tpop-modal" style="visibility: hidden; transform: translateX(-50%) translateY(-50%); opacity: 0;">
			<div class="pop-content pmdc" id="tpop-content">
				<div class="row ptop"></div>
				<div class="row pcenter">
					<img src="images/20170307033451636244976919235000.png" alt="">
					<p class="row pan01">免收訂金</p>
					<p>此商品貼上了「免收訂金」標籤，表示購買此商品一件，將不需收取任何訂金或預購金，讓您能夠免取先付訂金的麻煩手續，您只需要在確認下單的商品及聯絡資料無誤後，等待來自店家的收貨通知便可。</p>
				</div>
				<div class="row pbottom"></div>
			</div>
		</div>

		<uc1:TopHeader ID="TopHeader1" runat="server" />

		<!--內容-->
		<div class="container scrollBar_0">
			
			<div>
			<!--第一部分-->
				<div class="shop_banner">
					<!--大图-->
					<div id="banner_box" class="banner_box" >
						<img src="<%=dr["Pic"].ToString()==""?LS_J_ForPic.GetNoPhoto():dr["Pic"].ToString() %>"/>
						<div class="openBig"></div>
					</div>
				</div>
				<div class="shop_dynamic">
					<!--商品动态-->
					<ul class="clearfloat">
						<li>
							<div class="dynamicBox">
								<span class="dynamic_heart"><%=LS_J.Loadlng(dr["LoveNum"].ToString())+LS_J.Loadlng(dr["sLoveNum"].ToString())%></span>
								<span>心動</span>
							</div>
						</li>
						<li>
							<div class="dynamicBox">
								<span class="dynamic_check"><%=LS_J.Loadlng(dr["SeeNum"].ToString())+LS_J.Loadlng(dr["sSeeNum"].ToString())%></span>
								<span>查看</span>
							</div>

						</li>
						<li>
							<div class="dynamicBox">
								<span class="dynamic_inventory"><%=shangpinL.GrossKucun(dr["kucun"].ToString())%></span>
								<span>庫存</span>
							</div>

						</li>
						<li>
							<div class="dynamicBox">
								<span class="dynamic_buyed"><%=LS_J.Loadlng(dr["BuyNum"].ToString())+LS_J.Loadlng(dr["sBuyNum"].ToString())%></span>
								<span>已購</span>
							</div>

						</li>
					</ul>
				</div>
				<div class="shop_detail">
					<!--商品各种价钱-->
					<div class="shop_box">
						<div class="detail_introduction"><%=dr["Title"] %></div>
						<div class="detail_number">商品編號：<%=dr["Number"] %></div>
                        
						<div class="detail_price">
							<%--<span class="pubi">MOP <%=FinallyPrice %></span>--%>
                            <span class="pubi">MOP <%=dr["Price"] %></span>
							<span class="rmb"><%=HuiLvName %> <%=dr["rChengPrice"] %></span>

						</div>
						<!--<div class="detail_courier">
							<span class="courier">快遞 :</span>
							<sapn class="courPrice">MOP <%=FinallyKuaiDi %></span>&nbsp/&nbsp
							<span class="rmbPrice"><%=KuaiDiName %> <%=dr["YunFei"] %></span>
						</div>-->
					</div>
					
                    <%
                        string[] a = dr["shangpinlabel"].ToString().Split(',');

                        string aId = null;
                        for (int i = 0; i < a.Length; i++)
                        {
                            if (!string.IsNullOrWhiteSpace(a[i]))
                            {
                                aId += a[i] + ",";
                            }
                            else
                            {
                                aId += "0,";
                            }
                        }
                        if (aId.Length>0)
                        {
                            aId = aId.Substring(0, aId.Length - 1);
                        }
                        dt1 = LS_J_SQL.GetDataTable("select id,picture,LabelName,content from shangpinLabel where id in (" + aId + ")");
                        if (dt1.Rows.Count>0)
                        {%>
                    <!-- 后增代金券部分 (需要從後台取數據)-->
                    <div class="ppact">
						<div class="device">
							<a class="arrow-left" href="#"></a>
							<a class="arrow-right" href="#"></a>
							<div class="swiper-container" style="cursor: -webkit-grab; float:none !important;">
								<div class="swiper-wrapper" >
									<div class="swiper-slide swiper-slide-visible swiper-slide-active">
										<ul class="ssitem">
										<% 
                                                for (int i = 0; i < dt1.Rows.Count; i++)
                                                {
                                                
                                                if (dt1.Rows.Count > 0)
                                                {
                                            %>
                                            <li class="pannd">
                                                <img src="<%=OSS + dt1.Rows[i]["picture"]+OssLast %>" alt="Alternate Text" />
                                                <div class="pitem" style="display: none">
                                                    <div class="row ptop"></div>
                                                    <div class="row pcenter">
                                                        <img src="<%=OSS + dt1.Rows[i]["picture"] %>" alt="" />
                                                        <p class="row pan01"><%=dt1.Rows[i]["LabelName"] %></p>
                                                        <p><%=dt1.Rows[i]["content"] %></p>
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
					</div>
                        <%}
                            if (!string.IsNullOrWhiteSpace(dr["intro"].ToString()))
                            {%>
                    <div class="detail_advertist">
						<p>
						<%=LS_J.cutstr(dr["intro"].ToString(),97)%>
						</p>
					</div>
                            <%}
                        %>
				</div>
				<!-- change -->
                

                <!--新增代购者-->
                <div class="whoDG">
                    <div class="whoUser"></div>
                    <div class="whoName">
                        <div class="richUp"></div>
                        <div class="richTime"><%=dr["addtime"] %></div>
                    </div>
                    <div class="whatDG"><span class="whatLG"><%=ShopInfo.Rows[0]["shopname"] %></span></div>
                </div>

				<!--第二部分-->
				<div class="detail_menu">
					<ul class="clearfloat menuu">
						<li class="onlyOne">
							<span class="menu_current">商品圖片</span>
						</li>
						<li>
							<span class="menu_current">商品說明</span>
						</li>
						<li>
							<span class="menu_current">用戶評價</span>
						</li>
						<li>
							<span class="menu_current">查看用戶</span>
						</li>
                        <div class="menu_line"></div>
					</ul>				
				</div>

				<div class="menu_boss">
					<!--商品圖片-->
					<div class="menu_pic itemCount" id="long_img">
                        <%
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
                                    <img src="<%=dt.Rows[i]["pic"].ToString() %>" alt="" class="<%=bgcolor %>" />
                                    <%}%>
                                </div>
                            </li>
                            <%
                                }
                            %>
					</div>
					<!--商品說明-->
					<div class="menu_explain itemCount">
                        <%
                            //商品說明
                            dt8 = LS_J_SQL.GetDataTable("select * from [productfigure] where ProductId='" + dr["Number"] + "'");
                            if (dt8.Rows.Count > 0)
                            {
                            %>
                            <li class="clearfix">
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
                                    <div class="ppint_eachBox">
                                        <div class="ppint_eachTitle">商品說明</div>
                                        <div class="ppint_eachMain"><%=dr["explain"]%></div>
                                    </div>
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
                                }%>
					</div>
					<!--用戶評價-->
					<div class="menu_lever itemCount">
						<%
                            //用戶評價                            
                            dt8 = LS_J_SQL.GetDataTable("select top 10 A.id,A.userid,A.shangpinid,A.orderid,A.comment,A.miao,A.jia,A.shang,A.standard,A.addtime,A.ThirdUserName,C.Modela,C.Modelb,C.Modelc from ShangPinComment A left join ShangPin C on A.shangpinid=C.Number where A.shangpinid='" + dr["Number"].ToString() + "' and A.State=0 order by A.addtime desc,A.id desc");
                            if (dt8.Rows.Count > 0)
                            {
                                dt = LS_J_SQL.GetDataTable("select Sum(Miao)Miao,Sum(Jia)Jia,Sum(Shang)Shang,Count(ShangPinId) shangpinshu from ShangPinComment where ShangPinId='" + dr["Number"].ToString() + "'");
                                decimal Miao = Convert.ToDecimal(dt.Rows[0]["Miao"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString());
                                decimal Jia = Convert.ToDecimal(dt.Rows[0]["Jia"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString());
                                decimal Shang = Convert.ToDecimal(dt.Rows[0]["Shang"].ToString()) / Convert.ToDecimal(dt.Rows[0]["shangpinshu"].ToString());
                                int Totle = Convert.ToInt32((Miao + Jia + Shang) / 15 * 100);

                                dt2 = LS_J_SQL.GetDataTable("select top 1 Miao,Jia,Shang from ShangPinComment where ShangPinId='" + dr["Number"].ToString() + "' order by addtime desc");
                                decimal Miao2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Miao"].ToString()) / Convert.ToDecimal(1), 1);
                                decimal Jia2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Jia"].ToString()) / Convert.ToDecimal(1), 1);
                                decimal Shang2 = Math.Round(Convert.ToDecimal(dt2.Rows[0]["Shang"].ToString()) / Convert.ToDecimal(1), 1);
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
                        <li>
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

                                                string[] Chooses = LS_J.Split(dt8.Rows[i]["standard"].ToString(), "|");
                                                if (LS_J.Loadlng(dt8.Rows[i]["Modela"].ToString()) != 0) { ModelaTitle = LS_J_SQL.GetModelTitle(dt8.Rows[i]["Modela"].ToString()); }
                                                if (LS_J.Loadlng(dt8.Rows[i]["Modelb"].ToString()) != 0) { ModelbTitle = LS_J_SQL.GetModelTitle(dt8.Rows[i]["Modelb"].ToString()); }
                                                if (LS_J.Loadlng(dt8.Rows[i]["Modelc"].ToString()) != 0) { ModelcTitle = LS_J_SQL.GetModelTitle(dt8.Rows[i]["Modelc"].ToString()); }
                                        %>
                                        <dl>
                                            <dt>
                                                <a href="mypro_jou.aspx?userid=<%=dt8.Rows[i]["userid"]%>">
                                                    <img src="<%
                                                        string pic = LS_J_ForPic.GetUserNoPhoto();
                                                        %>
                                                        <%=OSS + pic%>"
                                                        alt="" class="mepic imgru" /></a>
                                            </dt>
                                            <dd class="ppll1t">
                                                <span class="mysx"><%=dt8.Rows[i]["ThirdUserName"].ToString() %></span>
                                                <%
                                                    if (dr["dai"].ToString() != "1")
                                                    {%>
                                                <em class="<%=sex %>"></em>
                                                    <%}
                                                    %>
                                            </dd>
                                            <dd class="ppll1"><%=dt8.Rows[i]["Comment"] %></dd>
                                            <dd class="ppll2">
                                                <%
                                                    //代购商品网站爬取的评论数据需要按照特定的格式展示出来
                                                    if (dr["dai"].ToString() == "1")
                                                    {%>
                                                <span><%=dt8.Rows[i]["standard"] %></span>
                                                    <%}
                                                    else
                                                    {
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
                                                <span><%=ModelbTitle %>：<%=useChoose.Substring(0, useChoose.Length - 1) %></span>
                                                <%
                                                            }
                                                        }
                                                    }
                                                %>
                                            </dd>
                                            <%
                                                if (dr["dai"].ToString() != "1")
                                                {%>
                                            <dd class="ppll2"><%=dt8.Rows[i]["addtime"] %></dd>
                                                <%}
                                                %>

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
                                }else
                                {
                            %>
                            <li>
                                <div class="nava"></div>
                            </li>
                            <%
                                }%>
					</div>
					<!--查看用户-->
					<div class="menu_look itemCount">
						<%
                                    //查看用户
                                dt = LS_J_SQL.GetDataTable("select top 16 B.id,B.pic,B.sex,B.account,B.name from [ShangPinSee] A left outer join [user] B on(A.userid=B.id) where A.Type=0 and B.id is not null and A.SeeId='" + dr["Number"].ToString() + "' order by A.uptime desc");
                                if (dt.Rows.Count > 0)
                                {
                            %>
                            <li>
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
                            <li>
                                <div class="nava"></div>
                            </li>
                            <%
                                }
                            %>
					</div>
				</div>
				<div class="detail_otherBuy">
					<div class="otherBuy_vertical"></div>
					<div class="otherBuy_text">其他<%=ShopInfo.Rows[0]["shopname"] %>代購 ：</div>
				</div>

				<!--分页请求-->
				<div id="global_list">
					<div class="global_listContent paddingCol">
						<div id="global_lister" class="clearfloat global_lister select"></div>
						<div class="no_more">沒有更多了~</div>
                        <div class="no_moreDown" style="width:100%;height:0.8rem;"></div>
					</div>
				</div>
		</div>
			
		</div>

		<!--右側導航-->
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

        

		<!--底部我要~買-->
		<div class="Bottom_wantBuy clearfloat">
            <div class="whatLGs">
               <a href="javascript:void(0)">
                    <%
                        string ShopPic = OSS + ShopInfo.Rows[0]["Shoppic"].ToString() + OssLast;
                        if (string.IsNullOrWhiteSpace(ShopInfo.Rows[0]["Shoppic"].ToString()))
                        {
                            ShopPic = OSS + LS_J_ForPic.GetNoPhoto() + OssLast;
                        }
                        %>
                    <img src="<%=ShopPic %>" alt="">
                </a>
            </div>
            <div class="LGname clearfloat"><%=ShopInfo.Rows[0]["shopname"] %><div>代購</div></div>
			
			<div class="wantBuy_rightNow">
				<span>我要買</span>
			</div>
		</div>

		<!--選擇規格-->
		<div class="black_mu"></div>
		</div>
		
        <!--规格核心html-->
		<div id="iwtts">
            <span class="closethick">close</span>
            <div class="iwbox">
                <div class="thumbwrapper1 square2 header_pic ture">
                    <img src="<%=dr["pic"] %>" alt="" id="selectPic" onerror="this.src='<%=dr["pic"] %>'" />
                </div>
                <dl class="iwbh">
                    <%--<dt class="iwbdt1"><span id="preMoneyShow">MOP</span><span id="MoneyShow"><%=FinallyPrice %></span><!--<span class="fastMoney"><%if (LS_J.Loadlng(dr["YunFei"].ToString())!=0) {%> (含快遞費 <%=KuaiDiName %> <%=dr["YunFei"] %>) <%} %></span>--></dt>--%>
                    <dt class="iwbdt1"><span id="preMoneyShow">MOP</span><span id="MoneyShow"><%=dr["Price"] %></span><!--<span class="fastMoney"><%if (LS_J.Loadlng(dr["YunFei"].ToString())!=0) {%> (含快遞費 <%=KuaiDiName %> <%=dr["YunFei"] %>) <%} %></span>--></dt>
                    <dt class="iwbdd3"><%=HuiLvName %> <span> <%=dr["ChengBen"].ToString().Split(',')[0] %></span></dt>
                </dl>
                <dl class="iwbd">
                    <dt class="iwbdd2">庫存<span id="InvShow"></span>件</dt>
                </dl>
            </div>
            <%
                if (ModelaTitle != "")
                {
			%>
			<div class="iwBox scrollBar_0">
				<div class="iwBoxs">
			
            <div class="iwtsel">
                <h1><%=ModelaTitle%></h1>
                <ul id="model1">
                    <%
                        for (int i = 0; i < ModelATeam.Length; i++)
                        {
                    %>
                    <li style="cursor:pointer" id="Modela<%=i %>" onclick="SelectedModela(<%=i %>);" title="<%=ModelATeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional1\""); } %>><%=ModelATeam[i] %></li>
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
                    <li style="cursor:pointer"  id="Modelb<%=i %>" onclick="SelectedModelb(<%=i %>);" title="<%=ModelBTeam[i] %>" value="0" <%if (i == 0) { Response.Write("class=\"current\""); } else { Response.Write("class=\"optional\""); } %>><%=ModelBTeam[i] %></li>
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
			
			<input type="hidden" name="ispost" id="ispost" value="1" />
			<input type="hidden" name="spid" id="spid" value="<%=id%>" />
			<input type="hidden" id="ShopId" name="ShopId" value="<%= dr["shopid"] %>" />
			<div class="iwtsel newbuyNumber">
				<h1 class="vgbars">購買數量</h1>
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
		</form>
		</div>
		
        <div class="dg_detail scrollBar_0" >
				<div class="dg_close"></div>
				<div class="dg_detail_box">
				<!--<div class="dg_header">					
					<div class="pack_weight"><span>重量 ：</span><span>5kg</span></div>
					<div class="pack_mop"><span>代購費 :</span><span> MOP 0</span></div>
                    <div class="pack_num"><div class="tan">!</div><span>以上代購費僅供參考，實際將以實物參數作為計算依據</span></div>
				</div>-->

				<div class="dg_body">
                    <img src="images/代購費說明.jpg" alt="">
                    <div class="grayLine"></div>	
                    <img src="images/代购第一张.jpg" alt="">
				</div>
				</div>
			</div>
        
		</div>
		<div class="iwss clearfloat">
			<div id="price_look">說明</div>
			<a href="#" class="iwbtn1" id="iwbOne" style="font-weight:none" onclick="checkbuy('cart')">加入購物籃</a>
			<a href="#" class="iwbtn2" id="iwbTwo"  style="font-weight:none" <% if (result) { Response.Write("onclick=\"checkbuy('now')\""); } else { Response.Write("onclick=\"bing()\""); } %>>立即購買</a>
		</div>
		<!-- 未选择规格提示 -->
		<div class="tooltip-content" id="ttp" style="display: none;">請選擇完規格再購買或添加到購物籃！</div>
		

		<script src="js/osURL.js"></script>
		<script src="publish/publishjs/plug/fastclick.min.js"></script>
		<script src="publish/publishjs/plug/template-native.js"></script>
		<script src="globalPurchasing/js/global_common.js"></script>
		<script>
			var count = <%=count%>;
			var ys = "<%=OSS_Tail.oss70%>";
			var osURL = "<%=LS_J_ForPic.OssPath()%>";
            var errorUrl = "<%=LS_J_ForPic.GetNoPhoto()%>";
            var userName = '<%=userName%>';
            var userPic = '<%=userPic.Replace("\\","/")%>';
		</script>
		
		<script src="globalPurchasing/js/global_detail.js"></script>
		<script src="js/spec.js"></script>
		

		<!--规格核心代码-->
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
                            console.log(buyform);
	                        buyform.submit();
	                    }
	                    else { 
	                        var ProductId=$("#spid").val();
	                        var Num=$("#buy-number").html();
							var Choose=$("#ModelaChar").val()+"|"+$("#ModelbChar").val()+"|"+$("#ModelcChar").val()+"|"+$("#ModeldChar").val()+"|"+$("#ModeleChar").val()+"|"+$("#ModelfChar").val();
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
                        $modal.css({ visibility: 'hidden', transform: 'scale(0)', opacity: '0' })
                        $tmodal.css({ visibility: 'hidden',opacity: '0' })
                        $(this).hide()
                    })
                } 
                else {
                    $modal.css({ display: 'none' })
                    $istar.on(touchEvent, function (e) {
                        if ($(this).hasClass("cur")) {
                            e.preventDefault;
                            $modal.css({ display: 'none', transform: 'scale(0)', opacity: '0' })
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
                        $tmodal.css({ display: 'block',opacity: '1',visibility: 'visible' })
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
            var rmbSingle=$(".iwbdd3 span").html();
            var temp; //得到文本框当前的数据  

            $("#btn-reduc").click(function () {
                temp = curVal.html();
                if (temp <= 1) {
                    return false;
                }
                if (testNum(temp)) {
                    curVal.html(--temp); //数量减1  
                    hidVal.val(temp);
                    $('#MoneyShow').html(location.href.indexOf('global_detail')==-1?(temp * window.sinplePrice):(Math.ceil((temp * window.sinplePrice)*HuiLv+YF*YFHuiLv)));
                    $('.iwbdd3 span').html(temp * rmbSingle);
                }
                else {
                    curVal.html(1);
                    hidVal.val(1);
                }
            });
            $("#btn-ad").click(function () {
                var $tp = $('#ttp');
                if(ChooeseGuige==""){
                    $tp.html('請選擇完規格再購買或添加到購物籃！').show();
                    intervalo = setTimeout(function (x) {
                        $tp.hide();
                    }, 3000);
                }else{
                    var temp = curVal.html();
                    var kucun = parseInt($("#InvShow").html());
                    if (testNum(temp)) {
                        if (temp < kucun) {
                            curVal.html(++temp); //数量加1  
                            hidVal.val(temp);
                            $('#MoneyShow').html(location.href.indexOf('global_detail')==-1?(temp * window.sinplePrice):(Math.ceil((temp * window.sinplePrice)*HuiLv+YF*YFHuiLv)));
                            $('.iwbdd3 span').html(temp * rmbSingle);
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
      
            // $('.thumbwrapper').nailthumb({ fitDirection: 'center center', replaceAnimation: null });
  

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
                                $modal.css({ visibility: 'hidden', transform: 'scale(0)', opacity: '0' });
                                $pobg.hide();
                            }else{
                                $modal.css({ display: 'none', transform: 'scale(0)', opacity: '0' })
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
                                $modal.css({ visibility: 'hidden', transform: 'scale(0)', opacity: '0' });
                                $pobg.hide();
                            }else{
                                $modal.css({ display: 'none', transform: 'scale(0)', opacity: '0' })
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
    
		<!-- 模板 -->
		<script id="list_template" type="text/html">
        <$for(var i=0;i<list.length;i++){$>
            <div class="list_item" id="<$=list[i].Aid$>">
                <div class="item_img" style="background-image:url(<$=list[i].Pic$>);"></div>
                <div class="item_info">
                    <div class="item_title"><$=list[i].Title$></div>
                    <div class="item_price">
                        <span class="easyColor">MOP</span>
                        <span class="easyColor"><$=formatNum(countPrice(list[i].Price,list[i].exchange))$></span>                   
                    </div>
                    <p><$=list[i].currency$><$=formatNum(list[i].Price)$></p>
                    <p><$=list[i].shopname$></p>
                    <!-- change -->
                    <div class="item_user">
					<span>
						<img src="<$=list[i].UserPic$>">
						<span><$=list[i].name$></span>發起代購
					</span>
					<!-- 原本这里是心动的，后来去掉了 -->
					<!-- <span>123</span>
					<i class="global_noLove"></i> -->
				</div>
                </div>
            </div>
            <$}$>
		</script>

		<script>
			$("#btop").on('click',function(){
					$(".container").animate({scrollTop:0},500)
			})		
        </script>
	</body>

</html>
