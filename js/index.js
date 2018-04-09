$(function () {
      function rbox() {
        var sw = Math.floor($(window).width() / 160)
        for (var i = 0; i <= sw; i++) {
            tsw=(160 * i)
          }
		$('#mlist').width(tsw)
        }

	  
	  var $container=$('#mlist')
	  $container.imagesLoaded(function(){
		$container.masonry({
			itemSelector:'.htbbg',
			columnWidth:160
		});	  
		  
	})
	  rbox();
 	  $(window).resize(function () {
        rbox();
	  });
      
   $('#mlist').masonry({  
   singleMode: true,  
   itemSelector: '.htbbg'  
})  
})
	