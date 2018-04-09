// 库存为0的，删除对应所有规格
$('.Unable').css('display','none !important');
judgeGuige();
function judgeGuige(){
    $.each(InventoryArray,function(key,value){
        if(value === '0'){
            PicTupianArray.splice(key, 1);
            InventoryArray.splice(key,1);
            ChooseArray.splice(key,1);
            MoneyArray.splice(key,1);
        }
    })
}

// 調用價格和庫存函數
function ModelSelected() {
    var ModelaChar = document.getElementById("ModelaChar");
    var ModelbChar = document.getElementById("ModelbChar");
    var ModelcChar = document.getElementById("ModelcChar");
    var ModeldChar = document.getElementById("ModeldChar");
    var ModeleChar = document.getElementById("ModeleChar");
    var ModelfChar = document.getElementById("ModelfChar");
    //var ModelDingWei= (ModelaChar.value==""?"":(ModelaChar.value + "|"))+(ModelbChar.value==""?"":(ModelbChar.value)+"|")+(ModelcChar.value==""?"":(ModelcChar.value)+"|")+(ModeldChar.value==""?"":(ModeldChar.value)+"|")+(ModeleChar.value==""?"":(ModeleChar.value)+"|")+(ModelfChar.value==""?"":(ModelfChar.value));
    var ModelDingWei = ModelaChar.value + "|" + ModelbChar.value + "|" + ModelcChar.value + "|" + ModeldChar.value + "|" + ModeleChar.value + "|" + ModelfChar.value;
    var ChooseChar = "|";
    if(location.href.indexOf('buy_rep.aspx') === -1){
        InvShow.innerHTML = '0';
        MoneyShow.innerHTML = '0';
        for (var i = 0; i < ChooseArray.length; i++) {
            var href=location.href;
            if (ChooseArray[i].indexOf(ModelaChar.value) > -1 && ChooseArray[i].indexOf(ModelbChar.value) > -1 && ChooseArray[i].indexOf(ModelcChar.value) > -1 && ChooseArray[i].indexOf(ModeldChar.value) > -1 && ChooseArray[i].indexOf(ModeleChar.value) > -1 && ChooseArray[i].indexOf(ModelfChar.value) > -1) {
                ChooseChar += ChooseArray[i] + "|";
            }
            if (ModelDingWei == ChooseArray[i]) {
                selectPic.src = PicTupianArray[i];
                InvShow.innerHTML = +InventoryArray[i];
                // 判斷是否為待確認頁面
                if(href.indexOf('buy_rep.aspx') !== -1){
                    console.log(dai);
                }else{
                    // 判断是否为代购详情页--不是
                    if(href.indexOf('global_detail.aspx') == -1){
                        window.sinplePrice = MoneyArray[i]
                        // <%=jiangjia %>;
                        MoneyShow.innerHTML = MoneyArray[i]
                        // <%=jiangjia %> * $("#buy-number").html();
                    }else{
                        //是代购详情页
                        window.sinplePrice = MoneyArray[i];
                        $('.iwbdd3 span').html(window.sinplePrice);
                        MoneyShow.innerHTML =Math.ceil(MoneyArray[i] * HuiLv + YF * YFHuiLv);
                    }
                }
                
                

            break;
            }
        }
        ChooeseGuige = ModelDingWei;
    }else{
        
        for (var i = 0; i < ChooseArray.length; i++) {
            var href=location.href;
            if (ChooseArray[i].indexOf(ModelaChar.value) > -1 && ChooseArray[i].indexOf(ModelbChar.value) > -1 && ChooseArray[i].indexOf(ModelcChar.value) > -1 && ChooseArray[i].indexOf(ModeldChar.value) > -1 && ChooseArray[i].indexOf(ModeleChar.value) > -1 && ChooseArray[i].indexOf(ModelfChar.value) > -1) {
                ChooseChar += ChooseArray[i] + "|";
            }
            if (ModelDingWei == ChooseArray[i].replace(/\s/g,"")) {
                $('#Img').src = PicTupianArray[i];
                $('#ChooeseKucun span').html(parseInt(InventoryArray[i]));
                // 判斷是否為待確認頁面
                if(href.indexOf('buy_rep.aspx') !== -1){

                    // 判斷是否為代購商品(1為代購，0為正常)
                    if(dai === "1"){
                        $('#ChooesePrice span').html(Math.ceil(MoneyArray[i] * HuiLv + YF * YFHuiLv));
                    }else if(dai === "0"){
                        $('#ChooesePrice span').html(MoneyArray[i]);
                    }
                    $('#NewMop').value = $('#ChooesePrice span').html();

                }else{
                    // 判断是否为代购详情页--不是
                    if(href.indexOf('global_detail.aspx') == -1){
                        window.sinplePrice = MoneyArray[i]
                        // <%=jiangjia %>;
                        $('#ChooesePrice span').innerHTML = MoneyArray[i]
                        // <%=jiangjia %> * $("#buy-number").html();
                    }else{
                        //是代购详情页
                        window.sinplePrice = MoneyArray[i];
                        $('.iwbdd3 span').html(window.sinplePrice);
                        MoneyShow.innerHTML =Math.ceil(MoneyArray[i] * HuiLv + YF * YFHuiLv);
                    }
                }
            break;
            }
        }
        ChooeseGuige = ModelDingWei;
        $('#CheckStandard').val(ChooeseGuige);
    }
}

//a
function SelectedModela(num) {
    var selectobj = document.getElementById("Modela" + num);
    if (selectobj.className == "current") {
        selectobj.className = "optional";
        ChooeseGuige = "";
        var modelB = $("#model2 > li");
        var modelC = $("#model3 > li");
        var modelD = $("#model4 > li");
        var modelE = $("#model5 > li");
        var modelF = $("#model6 > li");
        selectobj.className = "optional";
        ChooeseGuige = "";
        for (var i = 0; i < modelB.length; i++) {
            modelB[i].className = "Unable";
        }
        for (var i = 0; i < modelC.length; i++) {
            modelC[i].className = "Unable";
        }
        for (var i = 0; i < modelD.length; i++) {
            modelD[i].className = "Unable";
        }
        for (var i = 0; i < modelE.length; i++) {
            modelE[i].className = "Unable";
        }
        for (var i = 0; i < modelF.length; i++) {
            modelF[i].className = "Unable";
        }
    }
    else {
        var myArray = new Array();
        for (var i = 0; i < ChooseArray.length; i++) {
            var flag=true;
            var arrays = ChooseArray[i].split("|");
            if(ChooseArray[i].indexOf(arrays[1])>=0 && InventoryArray[i]==0){
                flag=false;
            };
            if(arrays[0] == selectobj.innerHTML && myArray.indexOf(arrays[0]) == -1&&flag){
                myArray[myArray.length] = arrays[1];
            }
        }
        selectobj.className = "current";
        var result = false;
        for (var i = 0; i < Modela.length; i++) {
            if (i != num && $("#Modela"+i).attr('class')!='Unable') {
                document.getElementById("Modela" + i).className = "optional";
            }
        }
        document.getElementById("ModelaChar").value = selectobj.title;
        if($('#Two') !== undefined && $('#Two').css('display') === 'none'){
            ModelSelected();
        }else{
        for (var i = 0; i < Modelb.length; i++) {
            try {
                if (myArray.indexOf(document.getElementById("Modelb" + i).innerHTML) != -1) {
                    document.getElementById("Modelb" + i).className = "optional";
                }
                else {
                    document.getElementById("Modelb" + i).className = "Unable";
                }
            }
            catch (e) {
                result = true;
                break;
            }
        }
        if (result) {
            ModelSelected();
        }
        else {
            ChooeseGuige = "";
        }
    }
}
}

//b
function SelectedModelb(num) {
    
    var selectobj = document.getElementById("Modelb" + num);
    if (selectobj.className == "current") {
        var modelC = $("#model3 > li");
        var modelD = $("#model4 > li");
        var modelE = $("#model5 > li");
        var modelF = $("#model6 > li");
        selectobj.className = "optional";
        ChooeseGuige = "";
        for (var i = 0; i < modelC.length; i++) {
            modelC[i].className = "Unable";
        }
    }
    else if(selectobj.className == "Unable"){

    }
    else {
        var result = false;
        var myArray = new Array();
        var modelA = "";
        for (var i = 0; i < Modelb.length; i++) {
            if (document.getElementById("Modelb" + i).className == "current") {
                document.getElementById("Modelb" + i).className = "optional";
            }
        }
        selectobj.className = "current";
        document.getElementById("ModelbChar").value = selectobj.title;
        var $children = $("#model1").children();
        for (var i = 0; i < $children.length; i++) {
            if($children[i].className == "current"){
                modelA = $children[i].innerHTML;
            }
        }
        for (var i = 0; i < ChooseArray.length; i++) {
            var flag=true;
            var arrays = ChooseArray[i].split("|");
            if(ChooseArray[i].indexOf(arrays[2])>=0 && InventoryArray[i]==0){
                flag=false;
            }
            if(arrays[0] == modelA && arrays[1] == selectobj.innerHTML && flag){
                myArray[myArray.length] = arrays[2];
            }
        }
        if($('#Three') !== undefined && $('#Three').css('display') === 'none'){
            ModelSelected();
        }else{
        for (var i = 0; i < Modelc.length; i++) {
            //var kcIndex=num*Modela.length*Modelb.length+i;
            try {
                if (myArray.indexOf(document.getElementById("Modelc" + i).innerHTML) != -1) {
                    document.getElementById("Modelc" + i).className = "optional";
                }
                else {
                    document.getElementById("Modelc" + i).className = "Unable";
                }
            }
            catch (e) {
                result = true;
                break;
            }
        }
        if (result) {
            ModelSelected();
        }
        else {
            ChooeseGuige = "";
        }
    }
}
}

//c
function SelectedModelc(num) {
    
    var selectobj = document.getElementById("Modelc" + num);
    if (selectobj.className == "current") {
        var modelD = $("#model4 > li");
        var modelE = $("#model5 > li");
        var modelF = $("#model6 > li");
        selectobj.className = "optional";
        ChooeseGuige = "";
        for (var i = 0; i < modelD.length; i++) {
            modelD[i].className = "Unable";
        }
    }
    else if(selectobj.className == "Unable"){

    }
    else {
        var result = false;
        var myArray = new Array();
        var modelB="";
        for (var i = 0; i < Modelc.length; i++) {
            if (document.getElementById("Modelc" + i).className == "current") {
                document.getElementById("Modelc" + i).className = "optional";
            }
        }
        selectobj.className = "current";
        document.getElementById("ModelcChar").value = selectobj.title;
        var $children = $("#model2").children();
        for (var i = 0; i < $children.length; i++) {
            if($children[i].className == "current"){
                modelB = $children[i].innerHTML;
            }
        }
        for (var i = 0; i < ChooseArray.length; i++) {
            var flag=true;
            var arrays = ChooseArray[i].split("|");
            if(ChooseArray[i].indexOf(arrays[3])>0 && InventoryArray[i]==0){
                flag=false;
            }
            if(arrays[1] == modelB && arrays[2] == selectobj.innerHTML && flag){
                myArray[myArray.length] = arrays[3];
            }
        }
        if($('#Four') !== undefined && $('#Four').css('display') === 'none'){
            ModelSelected();
        }else{
        for (var i = 0; i < Modeld.length; i++) {
            try {
                if (myArray.indexOf(document.getElementById("Modeld" + i).innerHTML) != -1) {
                    document.getElementById("Modeld" + i).className = "optional";
                }
                else {
                    document.getElementById("Modeld" + i).className = "Unable";
                }
            }
            catch (e) {
                result = true;
                break;
            }
        }
        if (result) {
            ModelSelected();
        }
        else {
            ChooeseGuige = "";
        }
    }
}
}

//d
function SelectedModeld(num) {
    
    var selectobj = document.getElementById("Modeld" + num);
    if (selectobj.className == "current") {
        var modelE = $("#model5 > li");
        var modelF = $("#model6 > li");
        selectobj.className = "optional";
        ChooeseGuige = "";
        for (var i = 0; i < modelE.length; i++) {
            modelE[i].className = "Unable";
        }
    }
    else if(selectobj.className == "Unable"){

    }
    else {
        var result = false;
        var myArray = new Array();
        var modelC="";
        for (var i = 0; i < Modeld.length; i++) {
            if (document.getElementById("Modeld" + i).className == "current") {
                document.getElementById("Modeld" + i).className = "optional";
            }
        }
        selectobj.className = "current";
        document.getElementById("ModeldChar").value = selectobj.title;
        var $children = $("#model3").children();
        for (var i = 0; i < $children.length; i++) {
            if($children[i].className == "current"){
                modelC = $children[i].innerHTML;
            }
        }
        for (var i = 0; i < ChooseArray.length; i++) {
            var flag=true;
            var arrays = ChooseArray[i].split("|");
            if(ChooseArray[i].indexOf(arrays[4])>0 && InventoryArray[i]==0){
                flag=false;
            }
            if(arrays[2] == modelC && arrays[3] == selectobj.innerHTML&&flag){
                myArray[myArray.length] = arrays[4];
            }
        }
        if($('#Five') !== undefined && $('#Five').css('display') === 'none'){
            ModelSelected();
        }else{
        for (var i = 0; i < Modele.length; i++) {
            //var kcIndex=num*Modela.length*Modelb.length*Modelc.length*Modeld.length+i;
            try {
                if (myArray.indexOf(document.getElementById("Modele" + i).innerHTML) != -1) {
                    document.getElementById("Modele" + i).className = "optional";
                }
                else {
                    document.getElementById("Modele" + i).className = "Unable";
                }
            }
            catch (e) {
                result = true;
                break;
            }
        }
        for (var i = 0; i < Modelf.length; i++) {
            try {
                document.getElementById("Modelf" + i).className = "Unable";
            }
            catch (e) {
                result = true;
                break;
            }
        }
        if (result) {
            ModelSelected();
        }
        else {
            ChooeseGuige = "";
        }
    }
}
}

//e
function SelectedModele(num) {
    
    var selectobj = document.getElementById("Modele" + num);
    if (selectobj.className == "current") {
        var modelF = $("#model6 > li");
        selectobj.className = "optional";
        ChooeseGuige = "";
        for (var i = 0; i < modelF.length; i++) {
            modelF[i].className = "Unable";
        }
    }
    else if(selectobj.className == "Unable"){

    }
    else {
        var result = false;
        var myArray = new Array();
        var modelD="";
        for (var i = 0; i < Modele.length; i++) {
            if (document.getElementById("Modele" + i).className == "current") {
                document.getElementById("Modele" + i).className = "optional";
            }
        }
        selectobj.className = "current";
        document.getElementById("ModeleChar").value = selectobj.title;
        var $children = $("#model4").children();
        for (var i = 0; i < $children.length; i++) {
            if($children[i].className == "current"){
                modelD = $children[i].innerHTML;
            }
        }
        for (var i = 0; i < ChooseArray.length; i++) {
            var flag=true;
            var arrays = ChooseArray[i].split("|");
            if(ChooseArray[i].indexOf(arrays[5])>0 && InventoryArray[i]==0){
                flag=false;
            }
            if(arrays[3] == modelD && arrays[4] == selectobj.innerHTML&&flag){
                myArray[myArray.length] = arrays[5];
            }
        }
        if($('#Six') !== undefined && $('#Six').css('display') === 'none'){
            ModelSelected();
        }else{
        for (var i = 0; i < Modelf.length; i++) {
            //var kcIndex=num*Modela.length*Modelb.length*Modelc.length*Modeld.length*Modele.length+i;
            try {
                if (myArray.indexOf(document.getElementById("Modelf" + i).innerHTML) != -1) {
                    document.getElementById("Modelf" + i).className = "optional";
                }
                else {
                    document.getElementById("Modelf" + i).className = "Unable";
                }
            }
            catch (e) {
                result = true;
                break;
            }
        }
        if (result) {
            ModelSelected();
        }
        else {
            ChooeseGuige = "";
        }
    }
}
}

//f
function SelectedModelf(num) {
    //当前选中的
    var selectobj = document.getElementById("Modelf" + num);
    //子元素总数
    var count=document.getElementById("model6").children.length;
    var un="";
    for (var j = 0; j < count; j++) {
        var select=document.getElementById("Modelf"+j);
        if (select.className=="Unable") {
            un+=j+",";
        }
    }
    if (selectobj.className == "current") {
        selectobj.className = "optional";
        ChooeseGuige = "";
    }
    else if(selectobj.className == "Unable")
    {

    }
    else{
        // var result=false;
        // var myArray=new Array();
        // var modelE="";
        // for(var i=0;i<Modelf.length;i++){
        // 	if(document.getElementById("Modelf"+i).className=="current"){
        // 		document.getElementById("Modelf"+i).className=="optional";
        // 	}
        // }
        selectobj.className="current";
        for (var i = 0; i < Modelf.length; i++) {
            if (i != num) {
                document.getElementById("Modelf" + i).className = "optional";
            }
        }
        document.getElementById("ModelfChar").value = selectobj.title;
        ModelSelected();
        // var $children = $("#model5").children();
        // for (var i = 0; i < $children.length; i++) {
        // 	if($children[i].className == "current"){
        //     	modelE = $children[i].innerHTML;
        // 	}
        // }
        // for (var i = 0; i < ChooseArray.length; i++) {
        // var arrays = ChooseArray[i].split("|");
        // if(arrays[4] == modelE && arrays[5] == selectobj.innerHTML){
        //     myArray[myArray.length] = arrays[6];
        // }
    }
    //alert(un);
    //没有的规格不能点
    if (un!="") {
        var check=un.substring(0,un.length-1);
        for (var k = 0; k <= check.split(',').length; k++) {
            //document.getElementById("Modelc" + k).className = "Unable";
            //alert();
            $("#Modelf" + check.split(',')[k]).attr("class", "Unable");
        }
    }
    //alert(check);
}


