$(function(){
	FastClick.attach(document.body); //初始化fastclick 
});
//轉換字符串
function formatNum(num){
	var str = num + "";//转换成字符串
    var str_num = str.split('.')[0];
    var str_last = str.split('.')[1] == undefined ? '' : '.'+str.split('.')[1];
    var ret_num = "";
    var counter = 0;
    for(var i=str_num.length-1;i>=0;i--){
        ret_num = str_num.charAt(i) + ret_num;
        counter++;
        if(counter==3){
            counter = 0;
            if(i!=0){
            ret_num = "," + ret_num;
            }
        }}
    return ret_num + str_last;
}
//模拟点击事件
function onClick(obj,opt){
	var maxNum = 20; //滑動閾值
	var touchRange;
	obj[0].flag = false;
	obj.off('touchstart.myclick touchmove.myclick touchend.myclick');
	obj.on('touchstart.myclick',function(event){
		obj[0].flag = true;
		touchRange = 0;
		//獲取初始距離
		var touch = event.targetTouches[0];
		obj[0].startX = touch.pageX;
        obj[0].startY = touch.pageY;
        obj[0].endX = touch.pageX;
        obj[0].endY = touch.pageY;
        opt.start&&opt.start.call(obj,event);
	});
	obj.on('touchmove.myclick',function(event){
		//獲取滑動距離
		var touch = event.targetTouches[0];
		obj[0].endX = touch.pageX;
        obj[0].endY = touch.pageY;
        opt.move&&opt.move.call(obj,event);
	});
	obj.on('touchend.myclick',function(event){
		touchRange = Math.sqrt(Math.pow(obj[0].endX - obj[0].startX,2) + Math.pow(obj[0].endY - obj[0].startY,2));
		if(obj[0].flag && opt.touchClick && touchRange<=maxNum){
			opt.touchClick&&opt.touchClick.call(obj,event);
		}
		opt.end&&opt.end.call(obj,event);
		obj[0].flag = false;
		touchRange = 0;
	});
}
//點擊其他地方，消失
function maskClick(el,func,str){
	var str = str == undefined ? 'maskClick' : str;
	$(document).off('click.'+str);
	$(document).on('click.'+str,function(e){
		if(!$(el).is(e.target) && $(el).has(e.target).length === 0){
			if(func) func();
		}
	});
}
//支持代购网站banner图
function supportBanner(){
	var pageNum = 5;
	var pageCount;
	$.get('ShopInfoForDai.ashx',function(data){
		data = data.replace(/\\/g,'/');
		data = JSON.parse(data);
		$.each(data.list,function(k,y){
			if(y.Pic == ''){
				y.logo = osURL + errorUrl + ys;
			}else{
				y.logo = osURL + y.logo + ys;
			}
		});
		var len = data.list.length;
		pageCount = Math.ceil(len/5);
		var itemHtml = '';
		for(var i=0;i<pageCount;i++){
			itemHtml += '<div class="swiper-slide clearfloat" id="support_slide'+i+'"></div>';
		};
		$('#global_support .global_support_inner').html(itemHtml);
		$.each(data.list,function(k,y){
			if(k == 0) k == 1;
			var html = [
				'<div class="global_support_item">',
					'<div class="global_support_itemImg" style="background-image:url('+y.logo+')">',
					'</div>',
					'<div class="global_support_itemName">'+y.shopname+'</div>',
				'</div>'
			];
			var idx = Math.floor((k+pageNum)/pageNum)-1
			$('#support_slide'+idx).append(html.join(''));
		});
		var banner = new Swiper('.swiper-container2',{
			pagination:{
				el : '.swiper-page2',
				clickable : true
			}
		});
	});
}