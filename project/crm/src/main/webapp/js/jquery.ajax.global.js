// 所有ajax执行成功之后，都会执行的方法，对于不想执行该函数的ajax，可以指定 global: false
// ajax的全局事件
jQuery(function ($) {
    $(document).
    // ajax执行成功时执行的函数
    ajaxSuccess(function (evt, request) {
        var data = request.responseJSON;
        if (data.msg) {
            $.alert(data.msg, function () {
                if (data.overtime) {
                    location = "/";
                }
            });
        }
    }).
    // 出错时执行的函数
    ajaxError(function () {
        alert("ajax执行错误！");
    })
    ;
});
