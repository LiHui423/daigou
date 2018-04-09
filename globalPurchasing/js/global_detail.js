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
		template.helper("countPrice",function(k,y){
			var res = k * y;
			return Math.ceil(res);
		});
		menuBar();
		menuScroll();
		dgCloses();
		
	})


	function detailToDetail(){
		$("#global_lister").on('click',function(event){
			var boxItem = event.target;
			var did =  $(boxItem).parents('.list_item').attr('id');
			var linking = '../../global_detail.aspx?id='+did;
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
		});


		var headerArrs = window.PicTupianArray;
		$('.model1 li').on('click',function(){
			var idee = $(this).index();
		});
		$('.header_pic').on('click',function(){
			var id = window.idee;
			if(headerArrs.length==1){
				var arr = [];
				arr.push($('.header_pic img').attr('src'));
				bigGlass(arr);
			}
			else{
				bigGlass(headerArrs,id);
			}
			$('.PicShopSize').addClass('pp');
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
			if(y === PicTupianArray[k]){
				var itemArr = [
					'<div class="swiper-slide">',
						'<div class="swiper-zoom-container">',
							'<img src="'+y+'">',
							'<span class="PicShopSize">'+ChooseArray[k].replace('|','')+'</span>',
						'</div>',
					'</div>'
				];
			}else{
				var itemArr = [
					'<div class="swiper-slide">',
						'<div class="swiper-zoom-container">',
							'<img src="'+y+'">',
							'<span class="PicShopSize"></span>',
						'</div>',
					'</div>'
				];
			}
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
		$(".menuu").find('li').on('click', function() {
			var line = $(".menu_line").width();
			var len = $(this).index() * line;
			var lens = $(this).index();	
			var menuTop = $('.detail_menu').offset().top-60;
			/*字体与横杠切换*/
			$(".menuu").find('li').removeClass('onlyOne');
			$(this).addClass('onlyOne');
			$(".menu_line").animate({
				left: len + 'px'
			}, 'fast');
			/*div切换*/
			$(".menu_boss").find('.itemCount').css('display', 'none');
			$(".menu_boss").find('.itemCount').eq(lens).css('display', 'block');
			$("html,body").animate({scrollTop:menuTop},500);
		});
	}



	// 產看購物欄
	function checkWhatBuy(){
		$('.wantBuy_check span').on('click',function(){
			window.location.href="../../buy_view.aspx";
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
	function dgCloses(){
		$(".packUp").on('click',function(){
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
		var pageSize = 5;
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
						if(y.Pic == undefined) {
							y.Pic = osURL + 'npbuy.png' + ys;
						} else {
							y.pic = osURL + y.Pic + ys;
						}
						if(y.UserPic == undefined){
							y.UserPic = osURL + '/images/nohead.png' + ys;
						}else{
							y.UserPic = osURL + y.UserPic + ys;
						}
						if(y.exchange == '') y.exchange = 1;
					});
					data.list.forEach(function(y){//代购人名加密 
						if(y.name.length<4){
							var realLength = 0, len = y.name, charCode = -1;
								for (var i = 0; i < 2; i++) {
									charCode = len.charCodeAt(i);
									if (charCode >= 0 && charCode <= 128){
										realLength += 1;
									} 
									else{
										realLength += 2;
									} 
								}
								if(realLength==2||realLength==3){
									y.name = y.name.substring(0,2)+'***';
								}
								else if(realLength==4){
									y.name = y.name.substring(0,1)+'***';
								}						
						}
						else if(y.name.length>=4){
							y.name = y.name.substring(0,2)+'***'+y.name.substr(-1);
						}
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
	//menuBar的浮动
	function menuBar(){
		var menu = $('.menuu');
		var oldOffsettop = menu.offset().top;
		$(window).on('scroll.dd',function(){
			var iScroll = $(document).scrollTop();
			if(iScroll>oldOffsettop){
				menu.css({
					'position':'fixed',
					'top':'60px',
					'background':'white',
					'z-index':'3'
				});
				
			}
			else{
				menu.css({
					'position':'absolute',
					'top':'0'
				})
			}
		})
	}


	//menuBar的收缩
	function menuScroll(){
		var heig = $('.menuu').offset().top;
		var oldScroll = $(window).scrollTop();
		detailScroll('on');
		function detailScroll(state){
			if(state=='on'){
				$(window).on('scroll.ee',function(){			
					var nowScroll = $(window).scrollTop();
					var res = nowScroll-oldScroll;
					if(res>=0&&$(window).scrollTop()>=heig+20){
						dir = false;
						direction(dir);						
					}
					else if(res<0&&$(window).scrollTop()>=heig+20){
						dir = true;
						direction(dir);
					}
	
					oldScroll = nowScroll;
				
				})
			}
			else{
				$(window).off('scroll.ee');
			}
			
		}
		
		//menuBar的收缩 
		function direction(dir){
			detailScroll('off');
			if(!dir){
				$('.menuu').stop().slideUp('fast',function(){
					detailScroll('on');
				});
				
			}
			else{
				$('.menuu').stop().slideDown('fast',function(){
					detailScroll('on');
				});
				
			}
		}
		
	}




	//ios浏览器兼容
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

