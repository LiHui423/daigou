$(function(){
    supportBanner(); //支持代购网站banner图
    backBtn(); //返回按钮
    globalOtherBtn(); //返回代购
});
//返回按钮
function backBtn(){
	onClick($('#back_index_btn'),{
		start : function(){
			$(this).addClass('hover');
		},
		end : function(){
			$(this).removeClass('hover');
		},
		touchClick : function(){
			window.location.href="index.aspx";
		}
	});
}

//返回代购
function globalOtherBtn(){
	onClick($('#global_other_btn'),{
		start : function(){
			$(this).addClass('hover');
		},
		end : function(){
			$(this).removeClass('hover');
		},
		touchClick : function(){
			window.location.href="global_index.aspx";
		}
	});
}