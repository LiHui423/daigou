$(function(){
	template.helper("countPrice",function(k,y){
		var res = parseInt(k) * parseInt(y);
		return res;
	});
	var requestObj = {
		container : $('#global_lister'),
		selectNum : 0,
		count:count,
		ys : ys,
		osURL : osURL,
		errorUrl : errorUrl,
		pageSize : 20,
		data : [
			{isFirst : false,page : 1,isComplete : false, orderby:'addtime'},
			{isFirst : true,page : 1,isComplete : false, orderby:'buynum'},
			{isFirst : true,page : 1,isComplete : false, orderby:'seenum'},
		]
	}
	listSortSelect(); //列表排序选择
	supportBanner(); //支持代购网站banner图
	globalSearch(); //全球搜索
	requestList(); //第一次请求数据
	jumpToDetail();//跳轉到商品詳情


	function jumpToDetail(){
		$("#global_lister").on("click",function(){
			window.location.href="http://debug.macaoeasybuy.com/global_detail.aspx?id=2580";
		})
	}
	//列表排序选择
	function listSortSelect(){
		var btn = $('#global_list .global_listSortSelect');
		var showBox = btn.find('span');
		var slideBox = $('#global_list .global_listSortBox ul');
		var icon = btn.find('i');
		var idx = 0;
		btn.on('click',function(){
			selectBtn();
		});
		slideBox.find('li').each(function(){
			onClick($(this),{
				start : function(){
					$(this).addClass('hover');
				},
				end : function(){
					$(this).removeClass('hover');
				},
				touchClick : function(){
					selectBtn();
					showBox.html(this.html());
					var newIdx = this.index();
					if(newIdx != idx){
						idx = newIdx;
						afterSelect(idx);
					}
				}
			});
		});
		function selectBtn(){
			slideBox.stop().slideToggle('fast');
			if(icon.hasClass('arrow_bottom')){
				icon.removeClass('arrow_bottom').addClass('arrow_top');
			}else{
				icon.removeClass('arrow_top').addClass('arrow_bottom');
			}
		}
		maskClick($('#global_list .global_listSortSelect,#global_list .global_listSortBox ul'),function(){
			slideBox.stop().slideUp('fast');
		},'listSort');
		//选择过后
		function afterSelect(idx){
			$('.global_lister').eq(idx).siblings('.global_lister').removeClass('select').end().addClass('select');
			requestObj.selectNum = idx;
			requestObj.container = $('.global_lister').eq(idx);
			if(requestObj.data[idx].isFirst){
				requestObj.data[idx].isFirst = false;
			}
			if(!requestObj.data[idx].isComplete){
				requestList();
			}
		}
	}
	//全球搜索
	function globalSearch(){
		onClick($('.global_searchBtn'),{
			start : function(){
				$(this).addClass('hover');
			},
			end : function(){
				$(this).removeClass('hover');
			},
			touchClick : function(){
				if(memberid == ''){
					noLoginAlert('請先會員登錄哦！',function(){
						window.location.href='login.aspx';
					});
				}else{
					globalSearchRequest();
				}
			}
		});
		//发送请求搜索
		function globalSearchRequest(){
			var val = $('#global_search .global_searchInput').val();
			var requestURL = '';
		}
	}
	//分页请求
	function requestList(){
		var $container = requestObj.container;
		var itemClass = '.list_item';
		var pageSize = requestObj.pageSize;
		var requestFocus = requestObj.data[requestObj.selectNum]
		var page = requestFocus.page;
		var orderby = requestFocus.orderby;
		var isComplete = requestFocus.isComplete;
		var requestUrl = 'global_index.ashx';
		var count = requestObj.count;
		myNewRequest();
		function myNewRequest(){
			$.ajax({
				url:requestUrl,
				type:"get",
				data:{
					pagesize : pageSize,
					page :page,
					orderby : orderby,
					count : count
				},
				async:true,
				cache:true,
				dataType:'json',
				beforeSend:function(){
					easyScrollRequest('off','myScroll',$(window));
					if(isComplete) return false;
					if($('#infscr-loading').length == 0) $('body').append('<div id="infscr-loading"><img alt="Loading..." src="../images/6RMhx.gif"></div>');
				},
				success:function(data){
					data = data.replace(/\\/g,'/');
					data = JSON.parse(data);
					$.each(data.list,function(k,y){
						if(y.Pic == ''){
							y.Pic = requestObj.osURL + requestObj.errorUrl + requestObj.ys;
						}else{
							y.pic = requestObj.osURL + y.Pic + requestObj.ys;
						}
						if(y.exchange == '') y.exchange = 1;
					});
					var html = template('list_template',data);
					$container.append(html);
					if(page * pageSize < count){
						easyScrollRequest('on','myScroll',$(window),$(document),function(){
							myNewRequest();
						});
					}else{
						easyScrollRequest('off','myScroll',$(window));
						requestObj.data[requestObj.selectNum].isComplete = true;
					}
					requestObj.data[requestObj.selectNum].page++;
					$('#infscr-loading').remove();
				}
			});
		}
	}
});
