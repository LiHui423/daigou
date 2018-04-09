<%@ Page Language="C#" AutoEventWireup="true" CodeFile="buy_rep.aspx.cs" Inherits="buy_rep" %>

<%@ Register Src="TopHeader.ascx" TagName="TopHeader" TagPrefix="uc1" %>

<%
    thefun.CheckPost();
    string memberid = thefun.GetCookies("qe_memberid");
    if (string.IsNullOrEmpty(memberid) || memberid == "0")
    {
        Response.Write("<script language=javascript>var resultString; alert('請先會員登錄'); window.location.href = 'reg.aspx';</script>");
        Response.End();
    }
    string id = Request["id"];
    if (string.IsNullOrEmpty(id) || string.IsNullOrWhiteSpace(id))
    {
        Response.Write("<script language=javascript>var resultString; alert('參數有誤！'); window.location.href = 'Index.aspx';</script>");
        Response.End();
    }
    //检查该商品是否已经执行过换货
    System.Data.DataTable Check = thefun.GetDataTable("select count(*) from Exchange where iShoppingId=" + id + " and iUserId=" + memberid + "");
    if (Check.Rows[0][0].ToString() != "0")
    {
        Response.Write("window.location.href = 'Index.aspx';</script>");
        Response.End();
    }
    if (thefun.CheckIsExchangeLost(id))
    {
        Response.Write("<script language=javascript>var resultString; alert('參數有誤！'); window.location.href = 'Index.aspx';</script>");
        Response.End();
    }
    string mop = "";
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="apple-mobile-web-app-capable" content="yes" />
    <meta name="apple-mobile-web-app-status-bar-style" content="white">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title><%=LS_J_Global.AppTitle() %></title>
    <link href="styles.css" rel="stylesheet" type="text/css">
    <link href="reg.css" rel="stylesheet" type="text/css" />
    <link href="stylesm.css" rel="stylesheet" type="text/css">
    <link href="css/jquery.nailthumb.1.0.min.css" rel="stylesheet" />
    <script src="js/jquery-1.8.3.min.js"></script>
    <script src="js/jquery.nailthumb.1.1.min.js"></script>
    <script src="js/spec.js"></script>
    <script>
        $(function () {
            $('.thumbwrapper').nailthumb({ fitDirection: 'center center', replaceAnimation: null });
        })
    </script>

    <style type="text/css" media="screen">
        .square {
            width: 80px;
            height: 80px;
            float: left;
        }
    </style>
</head>
<body class="bgc">
    <uc1:TopHeader ID="TopHeader1" runat="server" />
    <form name="listform" action="SubRepHandler.ashx" method="post">
        <div class="container clearfix bhy">
            <div class="f_title">
                <div class="ftbg btc vgbline">
                    <div class="ftbc">
                        <ul class="bknav">
                            <li><a href="buy_view.aspx"><span>購物藍</span><em>(<%= thefun.GetShoppingCartCount()%>)</em></a></li>
                            <li><a href="buy_loan.aspx"><span>待發貨</span><em>(<%= thefun.getCurrentUserWaitDeliveryCount() %>)</em></a></li>
                            <li class="cur"><a href="buy_sign.aspx"><span>待確認</span><em>(<%= thefun.getCurrentUserUnConfirmCount() %>)</em></a></li>
                            <li><a href="buy_eva.aspx"><span>待評價</span><em>(<%= thefun.getCurrentUserUnEvaluateCount()%>)</em></a></li>
                            <li><a href="buy_all.aspx"><span>已完成</span><em>(<%= thefun.getThreeMonthOrderCount() %>)</em></a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <div id="v_basket">
                <div class="bstop">
                    <div class="brep bbline">申請換貨</div>
                    <%
                        System.Data.DataTable CurrentShopping = thefun.GetDataTable("select * from Shopping where id=@id", "@id", id);
                        System.Data.DataTable CurrentShangpin = thefun.GetDataTable("select * from Shangpin where id=@id", "@id", CurrentShopping.Rows[0]["iGoodsId"].ToString());

                        //取得代购相关汇率计算
                        System.Data.DataTable SetTable = LS_J_SQL.GetDataTable("select percentage,KGmutliple from SetTable");

                        //计算汇率（取得对应汇率计算）
                        System.Data.DataTable HuiLvTable = LS_J_SQL.GetDataTable("select currency,exchange from ExchangeTable where id=" + CurrentShangpin.Rows[0]["ExchangeId"] + "");

                        string HuiLvName = "暫無數據";
                        decimal HuiLv = 0;

                        if (!string.IsNullOrWhiteSpace(CurrentShangpin.Rows[0]["ExchangeId"].ToString()) && CurrentShangpin.Rows[0]["ExchangeId"].ToString() != "0")
                        {
                            HuiLvName = HuiLvTable.Rows[0]["currency"].ToString();//货币名称
                            HuiLv = Convert.ToDecimal(HuiLvTable.Rows[0]["exchange"].ToString());
                        }

                        //计算汇率（取得对应汇率计算）
                        System.Data.DataTable KuaiDiTable = LS_J_SQL.GetDataTable("select currency,exchange from ExchangeTable where id=" + CurrentShangpin.Rows[0]["YunFeiExId"] + "");

                        string KuaiDiName = "暫無數據";
                        decimal KuaiDi = 0;

                        if (!string.IsNullOrWhiteSpace(CurrentShangpin.Rows[0]["YunFeiExId"].ToString()) && CurrentShangpin.Rows[0]["YunFeiExId"].ToString() != "0")
                        {
                            KuaiDiName = KuaiDiTable.Rows[0]["currency"].ToString();//货币名称
                            KuaiDi = Convert.ToDecimal(KuaiDiTable.Rows[0]["exchange"].ToString());
                        }

                        int kucun = 0;
                        int jiage = 0;
                        string OSS = LS_J_ForPic.OssPath();
                        string OssLast = OSS_Tail.oss70;
                        string NoPic = OSS + LS_J_ForPic.GetNoPhoto() + OssLast;
                        string tupian = NoPic;

                        string currentStandard = CurrentShopping.Rows[0]["sStandard"].ToString();
                        string[] sAllPrice = CurrentShangpin.Rows[0]["jiage"].ToString().Split(',');
                        string[] sAllStandard = CurrentShangpin.Rows[0]["guige"].ToString().Split(',');
                        string[] sAllKucun = CurrentShangpin.Rows[0]["kucun"].ToString().Split(',');
                        string[] sAllTupian = CurrentShangpin.Rows[0]["tupian"].ToString().Split(',');

                        for (int i = 0; i < sAllStandard.Length; i++)
                        {
                            if (sAllStandard[i] == currentStandard)
                            {
                                kucun = thefun.Loadlng(sAllKucun[i].ToString());
                                jiage = thefun.Loadlng(sAllPrice[i].ToString());
                                if (CurrentShangpin.Rows[0]["dai"].ToString() == "1")
                                {
                                    tupian = sAllTupian[i];
                                }
                                else
                                {
                                    tupian = OSS + sAllTupian[i] + OssLast;
                                }
                            }
                        }
                        LS_J LS = new LS_J();
                        string Address = LS.CheckView(CurrentShopping.Rows[0]["iGoodsId"].ToString());
                    %>
                    <div class="v_stop">
                        <div class="v_goods vrep">
                            <div class="vg_box l_box">

                                <a href="<%=Address %>.aspx?id=<%= CurrentShopping.Rows[0]["iGoodsId"] %>">
                                    <div class="thumbwrapper square">
                                        <img src="<%= tupian %>">
                                    </div>
                                </a>

                                <div class="vg_text l_text1">
                                    <h3 class="vg_title"><a href="#" class="vgl2" id="title"><%= CurrentShangpin.Rows[0]["title"] %></a></h3>
                                    <div class="vg_gg">
                                        <%
                                            mop = CurrentShopping.Rows[0]["fPrice"].ToString();
                                            foreach (var item in currentStandard.Split('|'))
                                            {
                                                if (!string.IsNullOrEmpty(item))
                                                {
                                        %>
                                        <p><%= item %></p>
                                        <input type="hidden" name="shopStandard" id="shopStandard" value="<%= item %>" />
                                        <%
                                                }
                                            }
                                        %>
                                        <p><%= CurrentShopping.Rows[0]["iCount"] %> 件</p>
                                        <p class="vtim1">mop <%= CurrentShopping.Rows[0]["fPrice"] %></p>
                                        <input type="hidden" name="sStandard" id="sStandard" value="<%= CurrentShangpin.Rows[0]["guige"].ToString() %>" />
                                        <input type="hidden" name="OrderId" id="OrderId" value="<%= CurrentShopping.Rows[0]["iOrderId"] %>" />
                                        <input type="hidden" name="ShoppingId" id="ShoppingId" value="<%= CurrentShopping.Rows[0]["id"] %>" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="brep br1 btline">請選擇換貨規格</div>
                    <div class="v_stop vnl">
                        <div class="v_goods vrep" id="PriceKuncunCountBox" style="display: block">
                            <div class="vg_box l_box">

                                <a href="<%=Address %>.aspx?id=<%=CurrentShopping.Rows[0]["iGoodsId"] %>">
                                    <div class="thumbwrapper square">
                                        <img src="<%= tupian %>" id="Img">
                                    </div>
                                </a>

                                <div class="vg_text l_text1">
                                    <h3 class="vg_title"><a href="#" class="vgl2"><%= CurrentShangpin.Rows[0]["title"] %></a></h3>
                                    <div class="vg_ti">
                                        <input type="hidden" name="NewMop" id="NewMop" value="" />
                                        <div class="vtim1" id="ChooesePrice">mop <span>0</span></div>
                                        <div class="vtim2" id="ChooeseKucun">库存：<span>0</span>件</div>
                                        <input type="hidden" name="LessKC" id="LessKC" value="0" />
                                        <input type="hidden" name="Surplus" id="Surplus" value="0" />
                                        <input type="hidden" name="Id" id="Id" value="<%= CurrentShopping.Rows[0]["iGoodsId"].ToString() %>" />
                                        <input type="hidden" name="OldMop" id="OldMop" value="<%= CurrentShopping.Rows[0]["fPrice"].ToString() %>" />
                                    </div>
                                    <input type="hidden" name="CheckStandard" id="CheckStandard" value="" />
                                </div>
                            </div>
                        </div>
                        <div id="Standard">
                            <%
                                Tools tools = new Tools(CurrentShangpin.Rows[0]["guige"].ToString());
                                List<string> guige1 = tools.CreateGuige1();
                            %>
                            <div class="vglist" id="One" style="display: block">
                                <h1 style="font-size:14px;color:#707070;padding:3px 0;"></h1>
                                <ul id="model1">
                                    <!-- <%
                                        foreach (var item in guige1)
                                        {
                                    %>
                                    <li><%= item %></li>
                                    <% 
                                        }
                                    %> -->
                                </ul>
                            </div>
                            <div class="vglist" id="Two" style="display: block">
                                <h1 style="font-size:14px;color:#707070;padding:3px 0;"></h1>
                                <ul id="model2">
                                </ul>
                            </div>
                            <div class="vglist" id="Three" style="display: block">
                                <h1 style="font-size:14px;color:#707070;padding:3px 0;"></h1>
                                <ul id="model3">
                                </ul>
                            </div>
                            <div class="vglist" id="Four" style="display: block">
                                <h1 style="font-size:14px;color:#707070;padding:3px 0;"></h1>
                                <ul id="model4">
                                </ul>
                            </div>
                            <div class="vglist" id="Five" style="display: block">
                                <h1 style="font-size:14px;color:#707070;padding:3px 0;"></h1>
                                <ul id="model5">
                                </ul>
                            </div>
                            <div class="vglist" id="Six" style="display: block">
                                <h1 style="font-size:14px;color:#707070;padding:3px 0;"></h1>
                                <ul id="model6">
                                </ul>
                            </div>
                        </div>
                        <div class="vg_ti titl1">
                            <div class="tvmnu">換貨數量：</div>
                            <div class="vgbar">
                                <a href="javascript:void(0)" onclick="Edu()" class="redu">减</a>
                                <div class="rain" id="rain" contenteditable="false">1</div>
                                <a href="javascript:void(0)" onclick="Add()" class="radd">加</a>
                                <%
                                    ArrayList minP = new ArrayList();
                                    minP.Add("@iShoppingId");
                                    minP.Add("@iOrderId");
                                    ArrayList minPv = new ArrayList();
                                    minPv.Add(CurrentShopping.Rows[0]["Id"]);
                                    minPv.Add(CurrentShopping.Rows[0]["iOrderId"]);
                                    System.Data.DataTable CheckTuiHuo = thefun.GetDataTable("select Count(*) from ReturnOfGoods where iShoppingId=@iShoppingId and iOrderId=@iOrderId", minP, minPv);
                                    int LessNum = Convert.ToInt32(CurrentShopping.Rows[0]["iCount"].ToString()) - Convert.ToInt32(CheckTuiHuo.Rows[0][0].ToString());
                                %>
                                <input type="hidden" value="<%= LessNum%>" name="maxCount" id="maxCount" />
                                <input type="hidden" value="1" name="UsemaxCount" id="UsemaxCount" />
                            </div>
                            <div class="tvmnu"><span>剩餘數量：</span><span id="lastCount"><%= LessNum %></span></div>
                        </div>
                        <div class="vg_ti vgco">
                            <select name="select" id="select" class="lselect1 slw">
                                <%
                                    System.Data.DataTable reason = thefun.GetDataTable("select * from Reason where iState=4");
                                    foreach (System.Data.DataRow item in reason.Rows)
                                    {
                                %>
                                <option value="<%= item["sValue"] %>"><%= item["sValue"] %></option>
                                <%
                                    }
                                %>
                                <option value="其他">其他</option>
                            </select>
                        </div>
                        <div class="vg_ti vgco">
                            <textarea placeholder="請填寫留言(最多120個字符)" name="textArea" id="textArea" class="vgtex" maxlength="120"></textarea>
                        </div>
                        <div class="vg_ti vgjy">
                            <a href="#" class="vsubtne" onclick="sub()">提交換貨單</a>
                            <%--<a href="###" class="jyfk" onclick="CheckAdd()">加入換貨單</a>--%>
                        </div>
                    </div>
                    <div id="hideDiv" style="display: none">
                        <div class="brep br1">請選擇換貨商品</div>
                        <div class="v_stop vnl" id="LastBox"></div>
                        <div class="vg_ti vgbtn"><a href="#" class="vsubtne" onclick="sub()">提交換貨單</a></div>
                    </div>
                </div>
            </div>
        </div>
        <input type="hidden" name="ModelaChar" id="ModelaChar" value />
        <input type="hidden" name="ModelbChar" id="ModelbChar" value />
        <input type="hidden" name="ModelcChar" id="ModelcChar" value />
        <input type="hidden" name="ModeldChar" id="ModeldChar" value />
        <input type="hidden" name="ModeleChar" id="ModeleChar" value />
        <input type="hidden" name="ModelfChar" id="ModelfChar" value />
    </form>
    <div class="tooltip-content" id="ttp" style="display: none"></div>
    <script type="text/javascript">
        <%
        String ModelaTitle = "";
        String ModelbTitle = "";
        String ModelcTitle = "";
        String ModeldTitle = "";
        String ModeleTitle = "";
        String ModelfTitle = "";
        if (LS_J.Loadlng(CurrentShangpin.Rows[0]["Modela"].ToString()) != 0) { ModelaTitle = LS_J_SQL.GetModelTitle(CurrentShangpin.Rows[0]["Modela"].ToString()); }
        if (LS_J.Loadlng(CurrentShangpin.Rows[0]["Modelb"].ToString()) != 0) { ModelbTitle = LS_J_SQL.GetModelTitle(CurrentShangpin.Rows[0]["Modelb"].ToString()); }
        if (LS_J.Loadlng(CurrentShangpin.Rows[0]["Modelc"].ToString()) != 0) { ModelcTitle = LS_J_SQL.GetModelTitle(CurrentShangpin.Rows[0]["Modelc"].ToString()); }
        if (LS_J.Loadlng(CurrentShangpin.Rows[0]["Modeld"].ToString()) != 0) { ModeldTitle = LS_J_SQL.GetModelTitle(CurrentShangpin.Rows[0]["Modeld"].ToString()); }
        if (LS_J.Loadlng(CurrentShangpin.Rows[0]["Modele"].ToString()) != 0) { ModeleTitle = LS_J_SQL.GetModelTitle(CurrentShangpin.Rows[0]["Modele"].ToString()); }
        if (LS_J.Loadlng(CurrentShangpin.Rows[0]["Modelf"].ToString()) != 0) { ModelfTitle = LS_J_SQL.GetModelTitle(CurrentShangpin.Rows[0]["Modelf"].ToString()); }
        // 图片数组
        String[] PicTupianTeam = null;
        if (!string.IsNullOrWhiteSpace(CurrentShangpin.Rows[0]["Tupian"].ToString()))
        {
            PicTupianTeam = CurrentShangpin.Rows[0]["Tupian"].ToString().Split(',');
        }
			%>
        var PicTupianArray = "<%=CurrentShangpin.Rows[0]["Tupian"].ToString().Replace("\\","/")%>";
        PicTupianArray = PicTupianArray.split(",");
        //为1表示代购商品，为0表示正常商品
        var dai = "<%=CurrentShangpin.Rows[0]["dai"]%>";
        //规格数组
        var Choose = "<%=CurrentShangpin.Rows[0]["guige"]%>";
        //重量数组
        var Weight = "<%=CurrentShangpin.Rows[0]["Weight"]%>";
        //源价钱数组
        var oldMoney = "<%=CurrentShangpin.Rows[0]["ChengBen"]%>";
        //价钱数组
        var Money = "<%=CurrentShangpin.Rows[0]["jiage"]%>";
        //库存数组
        var Inventory = "<%=CurrentShangpin.Rows[0]["kucun"]%>";

        //运费
        var YF =<%=CurrentShangpin.Rows[0]["YunFei"]%>;
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
        WeightArray = Weight.split(",");
        // 3.17添加**********
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

        var ModelaTitle = "<%=ModelaTitle%>";
        var ModelbTitle = "<%=ModelbTitle%>";
        var ModelcTitle = "<%=ModelcTitle%>";
        var ModeldTitle = "<%=ModeldTitle%>";
        var ModeleTitle = "<%=ModeleTitle%>";
        var ModelfTitle = "<%=ModelfTitle%>";

        $('#ModelaChar').value = Modela[0];
        $('#ModelbChar').value = Modelb[0];
        $('#ModelcChar').value = Modelc[0];
        $('#ModeldChar').value = Modeld[0];
        $('#ModeleChar').value = Modele[0];
        $('#ModelfChar').value = Modelf[0];

        if (Modelb.length === 1 && Modelb[0] === "") {
            $('#Two').css('display', 'none');
        }
        if (Modelc.length === 1 && Modelc[0] === "") {
            $('#Three').css('display', 'none');
        }
        if (Modeld.length === 1 && Modeld[0] === "") {
            $('#Four').css('display', 'none');
        }
        if (Modele.length === 1 && Modele[0] === "") {
            $('#Five').css('display', 'none');
        }
        if (Modelf.length === 1 && Modelf[0] === "") {
            $('#Six').css('display', 'none');
        }
        for (let i = 0; i < Modela.length; i++) {
            let liHtmla = `<li style="cursor:pointer" id="Modela${i}" onclick="SelectedModela(${i})" title=${Modela[i].replace(/\s/g,'')} value="0" class="optional">${Modela[i]}</li>`;
            $('#model1').append(liHtmla);
            $('#One h1').html(ModelaTitle);
        }
        for (let i = 0; i < Modelb.length; i++) {
            let liHtmlb = `<li style="cursor:pointer" id="Modelb${i}" onclick="SelectedModelb(${i})" title=${Modelb[i].replace(/\s/g,'')} value="0" class="Unable">${Modelb[i]}</li>`;
            $('#model2').append(liHtmlb);
            $('#Two h1').html(ModelbTitle);
        }
        for (let i = 0; i < Modelc.length; i++) {
            let liHtmlc = `<li style="cursor:pointer" id="Modelc${i}" onclick="SelectedModelc(${i})" title=${Modelc[i].replace(/\s/g,'')} value="0" class="Unable">${Modelc[i]}</li>`;
            $('#model3').append(liHtmlc);
            $('#Three h1').html(ModelcTitle);
        }
        for (let i = 0; i < Modeld.length; i++) {
            let liHtmld = `<li style="cursor:pointer" id="Modeld${i}" onclick="SelectedModeld(${i})" title=${Modeld[i].replace(/\s/g,'')} value="0" class="Unable">${Modeld[i]}</li>`;
            $('#model4').append(liHtmld);
            $('#Four h1').html(ModeldTitle);
        }
        for (let i = 0; i < Modele.length; i++) {
            let liHtmle = `<li style="cursor:pointer" id="Modele${i}" onclick="SelectedModele(${i})" title=${Modele[i].replace(/\s/g,'')} value="0" class="Unable">${Modele[i]}</li>`;
            $('#model5').append(liHtmle);
            $('#Five h1').html(ModeleTitle);
        }
        for (let i = 0; i < Modelf.length; i++) {
            let liHtmlf = `<li style="cursor:pointer" id="Modelf${i}" onclick="SelectedModelf(${i})" title=${Modelf[i].replace(/\s/g,'')} value="0" class="Unable">${Modelf[i]}</li>`;
            $('#model6').append(liHtmlf);
            $('#Six h1').html(ModelfTitle);
        }

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
        var ChooeseGuige = "";
        // ************

        var index = 1;

        function CheckAdd() {
            var checkStandard = $("#CheckStandard").prop("value");
            var c = parseInt($("#rain").html());
            if (checkStandard == "") {
                alert("請選擇完規格再添加！");
            }
            else if (c == 0) {
                alert("已沒有商品可以換,請刪除下方的臨時換貨單！");
            }
            else if (c > parseInt($("#Surplus").prop("value"))) {
                alert("超出庫存，無法換貨！");
            }
            else {
                var showLostCount = $("#lastCount");
                var title = $("#title").html();
                var context = "<div class='v_goods vrep' id='lastBox" + index + "' name='box' ><div class='vg_box l_box'>";
                context += "<div class='thumbwrapper square'><img src='" + $("#Img").prop("src") + "'></div>";
                context += "<div class='vg_text l_text2'><h3 class='vg_title'>" + title + "</h3>";
                var result = $("#CheckStandard").prop("value").split('|');
                var count = parseInt($("#rain").html());
                context += "<div class='vg_gg'><input type='hidden' name='index' value='" + index + "' />";
                if (!result[0] == "") {
                    context += "<p>" + result[0] + "</p>";
                }
                if (!result[1] == "") {
                    context += "<p>" + result[1] + "</p>";
                }
                if (!result[2] == "") {
                    context += "<p>" + result[2] + "</p>";
                }
                context += "<span>件數：</span><p id='Count" + index + "'>" + count + "</p><input type='hidden' name='RepStandard" + index + "' value='" + $("#CheckStandard").prop("value") + "' /><input type='hidden' name='RepCount" + index + "' value='" + count + "'/> </div></div>";
                var reason = $("#select").val();
                var msg = $("#textArea").prop("value");
                context += "<div class='delr' onclick='del(" + index + ")'>删除</div><div class='vg_ti vgco1'><div class='vg_ti vgcn'>原因：" + reason + "<input type='hidden' name='Reason" + index + "' value='" + reason + "' ></div><div class='vg_ti vgcn'>留言：" + msg + "<input type='hidden' name='Msg" + index + "' value='" + msg + "'/> </div></div>";
                $("#LastBox").append(context);
                index++;
                var mCount = parseInt($("#maxCount").prop("value")) - count;
                $("#maxCount").prop("value", mCount);
                showLostCount.html(mCount);
                if (mCount == 0) {
                    $("#rain").html(0);
                }
                else {
                    $("#rain").html(1);
                }
                $("#hideDiv").css("display", "block");
            }
        }

        function sub() {
            //if (document.getElementsByName("box").length == 0) {
            //    alert("暫無換貨訂單,請選擇后再提交！");
            //}
            //else {
            //    var cof = confirm("確認提交？");
            //    if (cof) {
            //window.listform.submit();
            //    }
            //}
            var OldMop = $("#OldMop").val();
            var ChooesePrice = $("#ChooesePrice span").html();
            //alert(OldMop);
            //alert(ChooesePrice);
            if (ChooeseGuige == "") {
                alert("請選擇換貨規格！");
                return;
            }
            if (OldMop != ChooesePrice) {
                alert("抱歉，您只能選擇價錢相同的商品進行操作！");
            }
            else {
                // var ExchangeNum = $("#UsemaxCount").val();
                // var LessKC = $("#LessKC").val();
                var ExchangeNum = $('#rain').html();
                var LessKC = $('#ChooeseKucun span').html();
                if (LessKC - ExchangeNum < 0) {
                    var $tp = $('#ttp');
                    $tp.html('存貨不足哦').show();
                    intervalo = setTimeout(function (x) {
                        $tp.hide();
                    }, 3000);
                    //alert("抱歉，該商品庫存不足！");
                    return;
                }
                else {
                    window.listform.submit();
                }
            }
        }

        function del(id) {
            var BoxDel = $("#lastBox" + id);
            var count = parseInt($("#Count" + id).html());
            var showLostCount = $("#lastCount");
            $("#rain").html(1);
            var maxCount = $("#maxCount");
            var lastCount = parseInt(maxCount.prop("value")) + count;
            $("#maxCount").prop("value", lastCount);
            showLostCount.html(lastCount);
            BoxDel.remove();
            if (document.getElementsByName("box").length == 0) {
                $("#hideDiv").css("display", "none");
            }
        }

        function Add() {
            var max = parseInt($("#maxCount").prop("value"));
            var pCount = parseInt($("#rain").html());
            var cCount = pCount + 1;
            if (cCount > max) {
                return;
            }
            else {
                $("#rain").html(cCount);
                $("#UsemaxCount").val(cCount);
                var nowPrice = $('#ChooesePrice').html();
                $('#ChooesePrice').html(nowPrice*cCount);
            }
        }
        function Edu() {
            var max = parseInt($("#maxCount").val());
            var pCount = parseInt($("#rain").html());
            var cCount = pCount - 1;
            if (cCount <= 0) {
                return;
            }
            else {
                $("#rain").html(cCount);
                $("#UsemaxCount").val(cCount);
            }
        }

        // function ChooeseTwo(id) {
        //     var three = $("#three");
        //     var stanard3 = $("#model3");
        //     var checkStandard = $("#CheckStandard");
        //     if ($(id).prop("class") == "current") {
        //         $("#model2 > li").removeClass("current");//清空所選規格
        //         checkStandard.prop("value", "");
        //         three.css("display", "none");//清空并隱藏規格三
        //         stanard3.children().remove();
        //         $("#PriceKuncunCountBox").css("display", "none");
        //     }
        //     else {
        //         $("#model2 > li").removeClass("current");
        //         $(id).prop("class", "current");
        //         $.ajax("GetExchangeGuige3.ashx", {
        //             type: "POST",
        //             data: {
        //                 Standard: $("#sStandard").prop("value"),
        //                 guige1: $("#model1 > li[class=current]").html(),
        //                 guige2: $(id).html()
        //             },
        //             success: function (result) {
        //                 if (result == "false") {
        //                     $("#PriceKuncunCountBox").css('display', "block");
        //                     var checkLi = $("#model1 > li[class=current]");
        //                     checkStandard.prop("value", checkLi.html() + "|" + $(id).html() + "|");
        //                     getPic();
        //                 }
        //                 else {
        //                     stanard3.children().remove();
        //                     stanard3.append(result);
        //                     $("#Three").css("display", "block");
        //                     //three.css("display", "block");
        //                     $("#PriceKuncunCountBox").css('display', "none");
        //                 }
        //             },
        //             error: function (XMLHttpRequest, textStatus, errorThrown) {
        //                 alert(XMLHttpRequest.status);
        //                 alert("發生未知錯誤！");
        //                 window.location.href = "Index.apsx";
        //             }
        //         })
        //     }
        // }

        // function ChooeseThree(id) {
        //     var checkStandard = $("#CheckStandard");
        //     if ($("#" + id.getAttribute("id")).attr("class") == "current") {
        //         console.log(1)
        //         $("#PriceKuncunCountBox").css('display', "none");
        //         checkStandard.prop("value", "");
        //         $("#PriceKuncunCountBox").css("display", "none");
        //     }
        //     else {
        //         $("#PriceKuncunCountBox").css('display', "block");
        //         var checkLi1 = $("#model1 > li[class=current]");
        //         var checkLi2 = $("#model2 > li[class=current]");
        //         $("#model3>li").removeClass("current");
        //         $("#" + id.getAttribute("id")).addClass("current");
        //         checkStandard.prop("value", checkLi1.html() + "|" + checkLi2.html() + "|" + $(id).html());

        //         getPic();
        //     }
        // }

        // function getPic(Standard) {
        //     $.ajax("GetPicByStandard.ashx", {
        //         type: "GET",
        //         data: {
        //             Standard: $("#CheckStandard").prop("value"),
        //             Id: $("#Id").prop("value")
        //         },
        //         datatype: "json",
        //         success: function (result) {
        //             if (result.Show == "false") {
        //                 alert("發送未知錯誤！");
        //                 window.location.href = "Index.aspx";
        //             }
        //             else {
        //                 $("#Img").prop("src", result.Img);
        //                 $("#ChooesePrice").html("mop " + result.Price);
        //                 $("#NewMop").val(result.Price);
        //                 $("#ChooeseKucun").html("庫存：" + result.Count + "件");
        //                 $("#LessKC").val(result.Count);
        //                 $("#Surplus").prop("value", result.Count);
        //                 $("#PriceKuncunCountBox").css("display", "block");
        //             }
        //         }
        //     })
        // }

        // $(function () {
        //     $("#model1 > li").click(function () {
        //         var two = $("#Two");
        //         var three = $("#Three");
        //         var checkStandard = $("#CheckStandard");
        //         var stanard2 = $("#model2");
        //         var stanard3 = $("#model3");

        //         if ($(this).prop("class") == "current") {
        //             $("#model1 > li").removeClass("current");//清空所選規格
        //             checkStandard.prop("value", "");

        //             two.css("display", "none");//清空并隱藏規格二
        //             stanard2.children().remove();

        //             three.css("display", "none");//清空并隱藏規格三
        //             stanard3.children().remove();
        //             $("#model3>li").removeClass("current");
        //             $("#PriceKuncunCountBox").css("display", "none");
        //         }
        //         else {
        //             $("#model1 > li").removeClass("current");
        //             $(this).prop("class", "current");
        //             checkStandard.prop("value", "");
        //             //alert($("#sStandard").prop("value"))
        //             $.ajax("GetExchangeGuige2.ashx", {
        //                 data: {
        //                     Standard: $("#sStandard").prop("value"),
        //                     guige: $(this).html()
        //                 },
        //                 success: function (result) {
        //                     if (result == "false") {
        //                         var checkLi = $("#model1 > li[class=current]");
        //                         checkStandard.prop("value", checkLi.html() + "||");
        //                         getPic();
        //                     }
        //                     else {
        //                         stanard2.children().remove();
        //                         stanard2.append(result);
        //                         two.css("display", "block");
        //                         stanard3.children().remove();
        //             $("#model3>li").removeClass("current");
        //                         $("#PriceKuncunCountBox").css("display", "none");
        //                     }
        //                 },
        //                 error: function () {
        //                     alert("發生未知錯誤！");
        //                     window.location.href = "Index.apsx";
        //                 }
        //             })
        //         }
        //     })
        // })
    </script>
</body>
</html>

