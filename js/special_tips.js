//var windowWidth = $(window).width();
//var windowHeight = $(window).height();
function tipsAlert(str,fn,state){
	var src = state == undefined ? 'images/feixuan.png' : 'images/publish_success.png';
	var html = [
		'<div id="special_tips">',
			'<div class="special_tipsbox">',
				'<div class="special_tipsimg"><img src="'+src+'" alt="" /></div>',
				'<div class="special_tipstext">'+str+'</div>',
				'<div class="special_tipsbtn">確認</div>',
			'</div>',
		'</div>'
	];
	html = html.join('');
	$('#special_tips').remove();
	$('body').append(html);
	var cancelBtn = $('#special_tips .special_tipsbtn');
	cancelBtn.off('click').on('click',function(){
		$('#special_tips').stop().fadeOut('fast',function(){
			fn&&fn();
			$('#special_tips').remove();
		});
	});
	$('#special_tips').stop().fadeIn('fast');
}
function tipsAlerts(str,fn){
	var src = 'images/cry.png';
	var html = [
		'<div id="special_tips">',
			'<div class="special_tipsbox" style="text-align:center;">',
				'<div class="special_tipsimg"><img src="'+src+'" alt="" style="margin-left: -24px;" /></div>',
				'<div class="special_tipstext" style="font-size:19px;">'+str+'</div>',
				'<div style="text-align:center;overflow:hidden;display:inline-block;">',
					'<div class="sure_tipsbtn special_tipsbtn" style="float:left;">確認</div>',
					'<div class="cancel_tipsbtn special_tipsbtn" style="float:left;margin-left:20px;">取消</div>',
				'</div>',
			'</div>',
		'</div>'
	];
	html = html.join('');
	$('#special_tips').remove();
	$('body').append(html);
	var sureBtn = $('#special_tips .sure_tipsbtn');
	var cancelBtn = $('#special_tips .cancel_tipsbtn');
	sureBtn.off('click').on('click',function(){
		$('#special_tips').stop().fadeOut('fast',function(){
			fn&&fn();
			$('#special_tips').remove();
		});
	});
	cancelBtn.off('click').on('click',function(){
		$('#special_tips').stop().fadeOut('fast',function(){
			$('#special_tips').remove();
		});
	})
	$('#special_tips').stop().fadeIn('fast');
}

function noLoginAlert(str,fn){
	var src = 'images/bomb01.png';
	var html = [
		'<div id="special_tips">',
			'<div class="special_tipsbox" style="text-align:center;">',
				'<div class="special_tipsimg"><img src="'+src+'" alt="" style="margin-left: 0px;" /></div>',
				'<div class="special_tipstext" style="font-size:19px;">'+str+'</div>',
				'<div style="text-align:center;overflow:hidden;display:inline-block;">',
					'<div class="sure_tipsbtn special_tipsbtn" style="float:left;">登錄/註冊</div>',
					'<div class="cancel_tipsbtn special_tipsbtn" style="float:left;margin-left:20px;">繼續觀看</div>',
				'</div>',
			'</div>',
		'</div>'
	];
	html = html.join('');
	$('#special_tips').remove();
	$('body').append(html);
	var sureBtn = $('#special_tips .sure_tipsbtn');
	var cancelBtn = $('#special_tips .cancel_tipsbtn');
	sureBtn.off('click').on('click',function(){
		$('#special_tips').stop().fadeOut('fast',function(){
			fn&&fn();
			$('#special_tips').remove();
		});
	});
	cancelBtn.off('click').on('click',function(){
		$('#special_tips').stop().fadeOut('fast',function(){
			$('#special_tips').remove();
		});
	})
	$('#special_tips').stop().fadeIn('fast');
}
