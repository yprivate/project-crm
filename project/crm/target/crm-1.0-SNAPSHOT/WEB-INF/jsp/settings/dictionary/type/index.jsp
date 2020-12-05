<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="/jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="/jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="/jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script>
        jQuery(function ($) {
            // 全选
            $("#selectAll").click(function () {
                $(":checkbox[name=code]").prop("checked", this.checked);
            });
            $(":checkbox[name=code]").click(function () {
                $("#selectAll").prop("checked", $(":checkbox[name=code]").size() == $(":checkbox[name=code]:checked").size());
            });
            // 删除操作
            $("#delBtn").click(function () {
                var $cks = $(":checkbox[name=code]:checked");
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
                // arr: ["sex", "color"]
                // xxx?code=sex,color
                // 数组中的join方法：将数组以指定的字符串连接起来，返回连接后的字符串
                location = "/type/delete.do?code=" + arr.join(",");

            });

            $("#editBtn").click(function () {
                // 获取选中的编码
                var $cks = $(":checkbox[name=code]:checked");
                if ($cks.size() == 0) {
                    alert("请选择要编辑项！");
                    return;
                }
                if ($cks.size() > 1) {
                    alert("只能选择一项！");
                    return;
                }
                location = "/type/edit.html?code=" + $cks.val();
            });
        });
    </script>
</head>
<body>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典类型列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" onclick="location='/settings/dictionary/type/save.html'"><span
                class="glyphicon glyphicon-plus"></span> 创建
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
            <td><input id="selectAll" type="checkbox"/></td>
            <td>序号</td>
            <td>编码</td>
            <td>名称</td>
            <td>描述</td>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${ list }" var="t" varStatus="sta">
            <tr class="${sta.index%2==0 ? "active" : ""}">
                <td><input name="code" type="checkbox" value="${t.code}"/></td>
                <td>${sta.count}</td>
                <td>${t.code}</td>
                <td>${t.name}</td>
                <td>${t.description}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>