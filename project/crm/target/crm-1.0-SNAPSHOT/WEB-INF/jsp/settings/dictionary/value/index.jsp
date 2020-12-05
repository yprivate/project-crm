<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        var type = [];
        <c:forEach items="${list}" var="v" varStatus="sta">
        if (type.indexOf("${v.typeCode}") == -1) {
            type.push("${v.typeCode}");
        }
        </c:forEach>

        jQuery(function ($) {
            $(type).each(function () {
                $("#typeCode").append("<option>" + this + "</option>");
            });
            // 全选
            $("#selectAll").click(function () {
                $(":checkbox[name=id]:visible").prop("checked", this.checked);
            });
            $(":checkbox[name=id]").click(function () {
                $("#selectAll").prop("checked", $(":checkbox[name=id]").size() == $(":checkbox[name=id]:checked").size());
            });
            // 删除操作
            $("#delBtn").click(function () {
                var $cks = $(":checkbox[name=id]:checked:visible");
                if ($cks.size() == 0) {
                    alert("请选择要删除项！");
                    return;
                }
                // 删除确认
                if (!confirm("确定删除吗？")) return;
                // 获取选中的编码
                var arr = [];
                $cks.each(function () {
                    arr.push(this.value);
                });
                // arr: ["1", "2"]
                // xxx?id=1,2
                // 数组中的join方法：将数组以指定的字符串连接起来，返回连接后的字符串
                console.log(arr.join(","));
                location = "/value/delete.do?ids=" + arr.join(",");
            });

            //编辑操作
            $("#editBtn").click(function () {
                // 获取选中的编码
                var $cks = $(":checkbox[name=id]:checked");
                if ($cks.size() == 0) {
                    alert("请选择要编辑项！");
                    return;
                }
                if ($cks.size() > 1) {
                    alert("只能选择一项！");
                    return;
                }
                location = "/value/edit.html?id=" + $cks.val();
            });

            $("#typeCode").change(function () {
                //下拉框改变让多选框取消选中状态
                $("#selectAll").prop("checked", false);
                $.ajax({
                    url:"/value/get.json",
                    data:{"typeCode":$("#typeCode").select().val()},
                    success:function (responseText){
                        var htmlArr = new Array();
                       $(responseText).each(function (i) {
                           htmlArr.push(
                               '<tr "code="'+this.typeCode+'"class="'+(i%2==0?"active":"") + '">\
                                    <td><input name="id" value="' + this.id + '" type="checkbox" /></td>\
                                    <td>'+(i+1)+'</td>\
                                    <td>'+this.value+'</td>\
                                    <td>'+this.text+'</td>\
                                    <td>'+this.orderNo+'</td>\
                                    <td>'+this.typeCode+'</td>\
                                </tr>'
                           );
                       })
                        $("tbody").html( htmlArr.join() );
                        // 全选
                        $("#selectAll").click(function () {
                            $(":checkbox[name=id]:visible").prop("checked", this.checked);
                        });
                        $(":checkbox[name=id]").click(function () {
                            $("#selectAll").prop("checked", $(":checkbox[name=id]").size() == $(":checkbox[name=id]:checked").size());
                        });
                    }
                })
            })
        });
    </script>
</head>
<body>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典值列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="height: 50px; position: relative;left: 30px;">
    <div class="input-group">
        <div class="input-group-addon">字典类型编码</div>
        <select id="typeCode" class="form-control" style="width: 300px;">
            <option></option>
        </select>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" onclick="location='/value/save.html'">
            <span class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button id="editBtn" type="button" class="btn btn-default">
            <span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button id="delBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox"  id="selectAll"/></td>
            <td>序号</td>
            <td>字典值</td>
            <td>文本</td>
            <td>排序号</td>
            <td>字典类型编码</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${list}" var="v" varStatus="sta">
            <tr code="${v.typeCode}" class="${sta.index%2==0?"active":""}">
                <td><input type="checkbox" name="id" value="${v.id}"/></td>
                <td>${sta.count}</td>
                <td>${v.value}</td>
                <td>${v.text}</td>
                <td>${v.orderNo}</td>
                <td>${v.typeCode}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>