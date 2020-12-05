<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <link href="/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        jQuery(function ($) {
            $("#saveBtn").click(function () {
                // 去掉两端空格
                var code = $.trim( $("#code").val() );
                // 非空
                if (!code) {
                    alert("请输入编码！");
                    return;
                }
                // 不能是中文
                if ( /[\u4e00-\u9fa5]/.test(code) ) {
                    alert("编码中不能包含中文！");
                    return;
                }
                // 不可重复
                $.ajax({
                    url: "/type/getExists.json?code="+code,
                    success: function (cunzai) {
                        if (!cunzai) {
                            $("form").submit();
                        } else {
                            alert("编码已经存在！");
                        }
                    }
                });
            });
        });
    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>新增字典类型</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<%--
    表单提交之前，检查三项：
        1. 表单的action
        2. 表单的提交方式是否为post
        3. 表单元素的name属性是否和实体类中的属性名一致
--%>
<form action="/type/save.do" method="post" class="form-horizontal" role="form">
    <div class="form-group">
        <label for="code" class="col-sm-2 control-label">编码<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="code" type="text" class="form-control" id="code" style="width: 200%;" placeholder="编码作为主键，不能是中文，不可重复">
        </div>
    </div>

    <div class="form-group">
        <label for="_name" class="col-sm-2 control-label">名称</label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="name" type="text" class="form-control" id="_name" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label for="describe" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 300px;">
            <textarea name="description" class="form-control" rows="3" id="describe" style="width: 200%;"></textarea>
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>