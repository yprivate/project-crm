<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <link href="/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <link href="/jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        jQuery(function ($) {
            $("#saveBtn").click(function () {
                var value = $.trim( $("#create-dicValue").val() );
                if (!value) {
                    alert("请输入字典值！");
                    return ;
                }

                var text = $.trim( $("#create-text").val() );
                if (!text) {
                    alert("请输入文本值！");
                    return ;
                }

                $("form").submit();
            });

            $("#typeCode").change(function() {
                $.ajax({
                    url: "/value/getSuggestOrderNo.json?code=" + this.value,
                    dataType: "text",
                    success: function (suggestOrderNo) {
                        $("#create-orderNo").val(suggestOrderNo);
                    }
                });
            }).
            // 手动（通过代码）调用绑定的change事件
            change();

        });
    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>新增字典值</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form action="/value/save.do" method="post" class="form-horizontal" role="form">

    <div class="form-group">
        <label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select id="typeCode" name="typeCode" class="form-control" id="create-dicTypeCode" style="width: 200%;">
                <c:forEach items="${list}" var="v">
                    <option value="${v.code}">${v.name}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-dicValue" class="col-sm-2 control-label">字典值<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="value" type="text" class="form-control" id="create-dicValue" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label for="create-text" class="col-sm-2 control-label">文本<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="text" type="text" class="form-control" id="create-text" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
        <div class="col-sm-10" style="width: 300px;">
            <input name="orderNo" type="text"  class="form-control" id="create-orderNo" style="width: 200%;"><br/>
            改变字典类型时，给出推荐排序号：如果该类型下没有字典值，则推荐值1，如果该类型下最大的排序号为5，则推荐值是6
            <hr/>
            select IFNULL(max(orderNo), 0) + 1 from tbl_dictionary_value
            where typeCode='color'
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>