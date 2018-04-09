$(function() {
	if(!!navigator.userAgent.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)){
		iosScrollFix();
	}
	shopClick();
	requestList();
	myBuy();
	Dg();
	dgClose();
	bindClickBigGlass();
	detailToDetail();
	checkWhatBuy();
	template.helper("countPrice", function(k, y) {
		var res = parseInt(k) * parseInt(y);
		return res;
	});
	
})


        $(function () {

            function mobilecheck() {

                var check = false;
                (function (a) { if (/(android|ipad|playbook|silk|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(a) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(a.substr(0, 4))) check = true })(navigator.userAgent || navigator.vendor || window.opera);
                return check;
            }

            var touchEvent = mobilecheck() ? 'touchstart' : 'click', $modal = $('#pop-modal'), $pobg = $('#pobg'), $istar = $('#istar'), $pannd = $('.pannd'), $popcon = $('#tpop-content'), $tmodal = $('#tpop-modal');
				
			$istar.on(touchEvent, function (e) {
				e.preventDefault;
				$modal.css({ visibility: 'visible', transform: 'scale(1)', opacity: '1' })
				$pobg.show();
			});
			$pobg.on(touchEvent, function (e) {
				         e.preventDefault;
				         $modal.css({ visibility: 'hidden', transform: 'scale(0)', opacity: '0' })
				         $tmodal.css({ visibility: 'hidden',opacity: '0' })
				         $(this).hide()
				     })

			        

            $('#btop').on(touchEvent, function (e) { $('html, body').stop(false, true).animate({ scrollTop: 0 }, 'fast'); e.preventDefault; })

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

        })


function detailToDetail(){
	$("#global_lister").on('click',function(event){
		var boxItem = event.target;
		var did =  $(boxItem).parents('.list_item').attr('id');
		var linking = 'http://debug.macaoeasybuy.com/global_detail.aspx?id='+did;
			window.location.href=linking;
	})
}




function bindClickBigGlass(){
	var urlArr = [];
	$('#banner_box img').each(function(){
		urlArr.push($(this).attr('src'));
	});
	$('#banner_box').on('click',function(){
		bigGlass(urlArr,1);
	});



	var arrs = [];
	$('#long_img img').each(function(){
		arrs.push($(this).attr('src'));
	});
	$("#long_img img").on('click',function(){
		var idx = $(this).index();
		bigGlass(arrs,idx);
	})
}
//放大镜
function bigGlass(arr,idx){
	idx == undefined ? 0 : idx;
	var html = [
		'<div id="big_glass">',
			'<div class="big_glassClose"></div>',
			'<div class="swiper-container big_swipercontainer">',
				'<div class="swiper-wrapper"></div>',
			'</div>',
			'<div class="swiper-pagination big_glass_page"></div>',
		'</div>'
	];
	$('body').append(html.join(''));
	var box = $('#big_glass');
	var item = '';

	$.each(arr,function(k,y){
		var itemArr = [
			'<div class="swiper-slide">',
				'<div class="swiper-zoom-container">',
					'<img src="'+y+'">',
				'</div>',
			'</div>'
		];
		item+=itemArr.join('');
	});
	box.find('.swiper-wrapper').append(item);

	box.fadeIn('fast');


	var boxSwiper = new Swiper('.big_swipercontainer', {
		zoom: true,
		pagination:{
			el:'.big_glass_page',
			type: 'fraction'
		}
	});
	boxSwiper.slideTo(idx, 0, false);
	//單擊雙擊事件

		// var touchtime = new Date().getTime();
    
		$(".swiper-zoom-container").on("click", function(){
			var touchtime = new Date().getTime();
			if( new Date().getTime() - touchtime < 1000){
				//shangji
			}else{
				//danji
				// touchtime = new Date().getTime();
				box.fadeOut('fast',function(){
						box.remove();
						boxSwiper.destroy(false);
					});
			}
		});
	
	
		

	box.find('.big_glassClose').on('click',function(){
		box.fadeOut('fast',function(){
			$(this).remove();
			boxSwiper.destroy(false);
		});
	});

}
/*商品图片点击切换*/
function shopClick() {
	$(".detail_menu").find('li').on('click', function() {
		var line = $(".menu_line").width();
		var len = $(this).index() * line;
		var lens = $(this).index();
		/*字体与横杠切换*/
		$(".detail_menu").find('li').removeClass('onlyOne');
		$(this).addClass('onlyOne');
		$(".menu_line").animate({
			left: len + 'px'
		}, 'fast');
		/*div切换*/
		$(".menu_boss").find('.itemCount').css('display', 'none');
		$(".menu_boss").find('.itemCount').eq(lens).css('display', 'block');
	});
}

// 產看購物欄
function checkWhatBuy(){
	$('.wantBuy_check span').on('click',function(){
		window.location.href="http://debug.macaoeasybuy.com/buy_view.aspx";
	})
}



/*我要買*/

function myBuy(){

	$(".wantBuy_rightNow").on('click',function(){
		//
		if($('#model2').length===0){
            for(var i=0;i<InventoryArray.length;i++){
                if(InventoryArray[i]==="0"){
                    $('#Modela'+i).attr('class','Unable');
                    $('#Modela'+i).attr('onclick','');
                }
            }
        }else{
            SelectedModela(0);
		}
		//
		$(".black_mu").css('display','block');
		$("#iwtts").css('transform','translate(0%,0%)');
		// $('.container').addClass('overFlow');
	})
	$(".closethick").on('click',function(){
			$(".black_mu").css('display','none');
			$("#iwtts").css('transform','translate(0%,110%)');
			$("#iwtts").css('display','block !important');
			// $('.container').removeClass('overFlow');
		})

	
}

// 點擊查看代購費
function Dg(){

	$("#price_look").on('click',function(){
		// $(".dg_detail").css({
		// 	'-webkit-transform' : 'translate(0,0)',
		// 	'-moz-transform' : 'translate(0,0)',
		// 	'-ms-transform' : 'translate(0,0)',
		// 	'transform' : 'translate(0,0)'
		// });
		$(".dg_detail").toggleClass('closeDgg');
	})
}

function dgClose(){
	$(".dg_close").on('click',function(){
		$(".dg_detail").removeClass('closeDgg');
		// $(".dg_detail").css({
		// 	'-webkit-transform' : 'translate(0,100%)',
		// 	'-moz-transform' : 'translate(0,100%)',
		// 	'-ms-transform' : 'translate(0,100%)',
		// 	'transform' : 'translate(0,100%)'
		// });

	})
}

//分页请求
function requestList() {
	if(window.count == 0) return false;
	var $container = $('#global_lister');
	var itemClass = '.list_item';
	var pageSize = 10;
	var page = 1;
	var orderby = 'addtime';
	var isComplete = false;
	var requestUrl = 'global_index.ashx';
	var count = window.count;
	myNewRequest();

	function myNewRequest() {
		$.ajax({
			url: requestUrl,
			type: "get",
			data: {
				pagesize: pageSize,
				page: page,
				orderby: orderby,
				count: count
			},
			async: true,
			cache: true,
			dataType: 'json',
			beforeSend: function() {
				easyScrollRequest('off', 'myScroll', $(window));
				if(isComplete) return false;
				if($('#infscr-loading').length == 0) $('body').append('<div id="infscr-loading"><img alt="Loading..." src="../images/6RMhx.gif"></div>');
			},
			success: function(data) {
				data = data.replace(/\\/g, '/');
				data = JSON.parse(data);
				$.each(data.list, function(k, y) {
					if(y.Pic == '') {
						y.Pic = osURL + errorUrl + ys;
					} else {
						y.pic = osURL + y.Pic + ys;
					}
					if(y.exchange == '') y.exchange = 1;
				});
				var html = template('list_template', data);
				$container.append(html);
				if(page * pageSize < count) {
					easyScrollRequest('on', 'myScroll', $(window), $(document), function() {
						myNewRequest();
					});
				} else {
					easyScrollRequest('off', 'myScroll', $(window));
					isComplete = true;
				}
				page++;
				$('#infscr-loading').remove();
			}
		});
	}
}
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



$(function(){
	addHref()
})
function addHref(){
	var test = window.location.href;
	var newstring = test.split('?')
	sessionStorage.setItem("addhref",newstring[0])
}

