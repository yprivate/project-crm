<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/WEB-INF/jsp/inc/commons_head.jsp" %>
    <script type="text/javascript">
        jQuery(function ($) {
            //初始化数据跟分页的方法
            function load(currentPage, rowsPerPage) {
                $.ajax({
                    url: "/dept/getPage.json",
                    data: {
                        currentPage: currentPage, // 当前页
                        rowsPerPage: rowsPerPage // 每页条数
                    },
                    success: function (page) {
                        // 遍历当前页数据，初始化表格
                        var htmlArr = new Array(page.data.length);
                        $(page.data).each(function (i) {
                            htmlArr.push(
                                '<tr class="' + (i % 2 == 0 ? "active" : "") + '">\
                                    <td><input name="id" value="' + this.id + '" type="checkbox" /></td>\
                                    <td>' + this.no + '</td>\
                                    <td>' + this.name + '</td>\
                                    <td>' + this.manager + '</td>\
                                    <td>' + this.phone + '</td>\
                                    <td>' + this.description + '</td>\
                                </tr>'
                            );
                        });
                        $("tbody").html(htmlArr.join());

                        $("#selectAll").prop("checked", false);
                        // 初始化分页插件
                        $("#page").bs_pagination({
                            currentPage: page.currentPage,          // 页码
                            rowsPerPage: page.rowsPerPage,          // 每页显示的记录条数
                            maxRowsPerPage: page.maxRowsPerPage,    // 每页最多显示的记录条数
                            totalPages: page.totalPages,            // 总页数
                            totalRows: page.totalRows,              // 总记录数
                            visiblePageLinks: page.visiblePageLinks,// 显示几个卡片
                            onChangePage: function (event, data) {
                                load(data.currentPage, data.rowsPerPage);
                            }
                        });
                    }
                });
            }

            load();
            // 全选
            $("#selectAll").click(function () {
                $(":checkbox[name=id]").prop("checked", this.checked);
            });
            // 由于需要绑定事件的元素在进行绑定时，页面中还不存在这些元素，因此绑定无效
            // 可以通过委派的方式进行绑定：将事件绑定到目标元素的父元素上（要求这个元素在绑定时必须存在），同时指定目标元素
            $("#selecttable").on("click", ":checkbox[name=id]", function () {
                $("#selectAll").prop("checked", $(":checkbox[name=id]").size() == $(":checkbox[name=id]:checked").size());
            });
            //删除
            $("#deleteBtn").click(function () {
                var ids = $(":checkbox[name=id]:checked").map(function () {
                    return this.value
                }).get().join(",");

                if (!ids) {
                    alert("请选择删除项！");
                    return;
                }

                $.confirm("确定删除吗？", function () {
                    $.ajax({
                        url: "/dept/delete.do?ids=" + ids,
                        success: function (data) {
                            if (data.success) {
                                load(1, $("#page").bs_pagination("getOption", "rowsPerPage"));
                            }
                        }
                    });
                });
            });

            //添加
            $("#saveBtn").click(function () {
                var no = $("#create-code").val();
                if (!/^\d{4}$/.test(no)) {
                    $.alert("编号只能是4位数字！");
                    return;
                }
                $.ajax({
                    url: "/dept/getExists.json?no=" + no,
                    success: function (data) {
                        if (data) {
                            $.alert("编号已经存在");
                            $("#create-code").val("");
                        } else {
                            var data = {};
                            $("#addForm :input[name]").each(function () {
                                data[this.name] = $(this).val();
                            });
                            $.ajax({
                                url: "/dept/save.do",
                                type: "post",
                                data: data,
                                success: function (data) {
                                    if (data.success) {
                                        $.alert("操作成功！");
                                        // 关闭模态窗口
                                        $('#createDeptModal').modal('hide');
                                        // 刷新列表
                                        var rowsPerPage = $("#page").bs_pagination("getOption", "rowsPerPage");
                                        //var currentPage = $("#page").bs_pagination("getOption", "currentPage");
                                        load(1, rowsPerPage);
                                    } else {
                                        $.alert("操作失败");
                                    }
                                }
                            })
                        }
                    }
                })
            });

            //修改前的判断跟数据回显
            $("#update").click(function () {
                ss = $(":checkbox[name=id]:checked").size();
                if (ss != 1) {
                    $.alert("只能且必须选择一个编辑项!")
                    return false;
                }
                $.ajax({
                    url: "/dept/getOne.json",
                    data: {"id": $(":checkbox[name=id]:checked").val()},
                    datatype: "json",
                    success: function (data) {
                        $("#updateAll :input[name]").each(function () {
                            $(this).val(data[this.name]);
                        })
                    }
                })
            });
            //修改
            $("#updateBtn").click(function () {
                var data1 = {};
                $("#updateAll :input[name]").each(function () {
                    data1[this.name] = $(this).val();
                });
                $.ajax({
                    url: "/dept/updateadd.do",
                    data: data1,
                    success: function (data) {
                        if (data.success) {
                            $.alert(data.msg)
                            load(1, $("#page").bs_pagination("getOption", "rowsPerPage"));
                            $('#editDeptModal').modal('hide');
                            return;
                        } else {
                            $.alert("出现异常，修改失败")
                            return;
                        }
                    }
                })
            });

        });
    </script>

</head>
<body>

<!-- 我的资料 -->


<!-- 修改密码的模态窗口 -->

<!-- 退出系统的模态窗口 -->
<!-- 顶部 -->
<%@ include file="/WEB-INF/jsp/inc/header.jsp" %>

<!-- 创建部门的模态窗口 -->
<div class="modal fade" id="createDeptModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel"><span class="glyphicon glyphicon-plus"></span> 新增部门</h4>
            </div>
            <div class="modal-body">

                <form id="addForm" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-code" class="col-sm-2 control-label">编号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="no" type="text" class="form-control" id="create-code" style="width: 200%;"
                                   placeholder="编号为四位数字，不能为空，具有唯一性">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-name" class="col-sm-2 control-label">名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="name" type="text" class="form-control" id="create-name" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-manager" class="col-sm-2 control-label">负责人</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="manager" type="text" class="form-control" id="create-manager"
                                   style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">电话</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="phone" type="text" class="form-control" id="create-phone" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 55%;">
                            <textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveBtn" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改部门的模态窗口 -->
<div class="modal fade" id="editDeptModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="mModalLabel"><span class="glyphicon glyphicon-edit"></span> 编辑部门</h4>
            </div>
            <div class="modal-body">

                <form id="updateAll" class="form-horizontal" role="form">
                    <input id="id" name="id" type="hidden"/>
                    <div class="form-group">
                        <label for="create-code" class="col-sm-2 control-label">编号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="no" type="text" readonly class="form-control" id="edit-code" style="width: 200%;"
                                   placeholder="编号为四位数字，不能为空，具有唯一性" value="1110"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-name" class="col-sm-2 control-label">名称</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="name" type="text" class="form-control" id="create-name" style="width: 200%;"/>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-manager" class="col-sm-2 control-label">负责人</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="manager" type="text" class="form-control" id="create-manager"
                                   style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">电话</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="phone" type="text" class="form-control" id="create-phone" style="width: 200%;">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 55%;">
                            <textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="updateBtn" type="button" class="btn btn-primary">更新</button>
            </div>
        </div>
    </div>
</div>

<div style="width: 95%">
    <div>
        <div style="position: relative; left: 30px; top: -10px;">
            <div class="page-header">
                <h3>部门列表</h3>
            </div>
        </div>
    </div>
    <div class="btn-toolbar" role="toolbar"
         style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; top:-30px;">
        <div class="btn-group" style="position: relative; top: 18%;">
            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createDeptModal"><span
                    class="glyphicon glyphicon-plus"></span> 创建
            </button>
            <button id="update" type="button" class="btn btn-default" data-toggle="modal" data-target="#editDeptModal">
                <span class="glyphicon glyphicon-edit"></span> 编辑
            </button>
            <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span>
                删除
            </button>
        </div>
    </div>
    <div style="position: relative; left: 30px; top: -10px;">
        <table class="table table-hover" id="selecttable">
            <thead>
            <tr style="color: #B3B3B3;">
                <td><input id="selectAll" type="checkbox"/></td>
                <td>编号</td>
                <td>名称</td>
                <td>负责人</td>
                <td>电话</td>
                <td>描述</td>
            </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div style="height: 10px; position: relative;top: 0px; left:30px;">
        <div id="page"></div>
    </div>
</div>
</body>
</html>