var url = window.location.href;  
$("a").each(function () {  
    if (returnUrl($(this).attr("href")) == returnUrl(url)) {  
        console.log($(this));  
        $(this).addClass("active");  
    }  
});  
//以下为截取url的方法  
function returnUrl(href) {  
    var number = href.lastIndexOf("/");  
    return href.substring(number + 1);  
}  
