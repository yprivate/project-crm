<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/jsp/inc/commons_head.jsp" %>

    <script type="text/javascript">
        jQuery(function ($) {

            //全选
            $("#selectAll").click(function () {
                $(":checkbox[name=id]").prop("checked", this.checked)
            })
            $("#selecttable1").on("click", ":checkbox[name=id]", function () {
                $("#selectAll").prop("checked", $(":checkbox[name=id]").size() == $(":checkbox[name=id]:checked").size());
            });
            //初始化部门
            $.ajax({
                url: "/dept/getAll.json",
                success: function (data) {
                    $(data).each(function () {
                        $("#create-dept").append("<option value='" + this.id + "'>" + this.name + "</option>")
                    })
                }
            });

            $("input[time]").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd hh:ii",//显示格式
                minView: "hour", // 日期时间选择器所能够提供的最精确的时间选择视图。
                initialDate: new Date(), //初始化当前日期
                autoclose: true,//选中自动关闭
                todayBtn: true, //显示今日按钮
                clearBtn: true,
                pickerPosition: "bottom-left"
            });

            //初始化数据跟分页的方法
            function load(currentPage, rowsPerPage) {
                var searchMap = $("#searchForm").formJSON();
                searchMap.currentPage = currentPage; // 当前页
                searchMap.rowsPerPage = rowsPerPage; // 每页条数
                $.ajax({
                    url: "/user/getAll.json",
                    data: searchMap,
                    success: function (page) {
                        // 遍历当前页数据，初始化表格
                        var htmlArr = [];
                        $(page.data).each(function (i) {
                            htmlArr.push(
                                '<tr class="' + (i % 2 == 0 ? "active" : "") + '">\
                                <td><input name="id" value="' + this.id + '" type="checkbox" /></td>\
                                <td>' + (i + 1) + '</td>\
                                <td><a  href="detail.html">' + (this.loginAct || " ") + '</a></td>\
                                <td>' + (this.name || " ") + '</td>\
                                <td>' + (this.dept == null ? "" : this.dept.name) + '</td>\
                                <td>' + (this.email || " ") + '</td>\
                                <td>' + (this.expireTime || " ") + '</td>\
                                <td>' + (this.allowIps || " ") + '</td>\
                                <td><a href="javascript:void(0);" style="text-decoration: none;">' + ((this.lockStatus == 1) ? '启用' : '锁定') + '</a></td>\
                                <td>' + (this.createBy || " ") + '</td>\
                                <td>' + (this.createTime || " ") + '</td>\
                                <td>' + (this.editBy || " ") + '</td>\
                                <td>' + (this.editTime || " ") + '</td>\
							</tr>'
                            );
                        });
                        $("#tbody").html(htmlArr.join());

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
            $("#searchBtn").click(function () {
                load();
            })

            //新增数据
            $("#saveBtn").click(function () {
                var loginAct = $("#addFrom :input[name=loginAct]").val();
                var deptId = $("#addFrom :input[name=deptId]").val()
                var loginPwd = $("#addFrom :input[name=loginPwd]").val();
                var loginPwd2 = $("#create-confirmPwd").val();
                if (loginAct == null || loginAct == "") {
                    $.alert("登录账号不能为空!")
                    return false;
                }
                if (loginPwd == null || loginPwd == "") {
                    $.alert("登录密码不能为空!")
                    return false;
                }
                if (deptId == null || deptId == "") {
                    $.alert("请选择部门!")
                    return false;
                }
                if (loginPwd != loginPwd2) {
                    $.alert("两次密码不一致")
                    return false;
                }
                $.ajax({
                    url: "/user/saveadd.do",
                    data: $("#addFrom").formJSON(),
                    success: function (data) {
                        if (data.success) {
                            $('#createUserModal').modal('hide');
                            load(1, $("#page").bs_pagination("getOption", "rowsPerPage"))
                            $.alert("添加成功!")
                        }
                    }
                })
            })


            //删除
            $("#deleteBtn").click(function () {
                var ids = $(":checkbox[name=id]:checked").map(function () {
                    return this.value;
                }).get().join(",");
                if (ids=='') {
                    $.alert("请选择要删除项!")
                    return false;
                }
                $.ajax({
                    url:"/user/delete.do",
                    data:{ids:ids},
                    success:function (data){
                        if(data.success){
                            load(1,$("#page").bs_pagination("getOption", "rowsPerPage"))
                            $.alert("删除成功")
                        }
                    }
                })
            })

        })
    </script>
</head>
<body>

<!-- 创建用户的模态窗口 -->
<div class="modal fade" id="createUserModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">新增用户</h4>
            </div>
            <div class="modal-body">

                <form id="addFrom" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-loginActNo" class="col-sm-2 control-label">登录帐号<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="loginAct" type="text" class="form-control" id="create-loginActNo">
                        </div>
                        <label for="create-username" class="col-sm-2 control-label">用户姓名</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="name" type="text" class="form-control" id="create-username">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-loginPwd" class="col-sm-2 control-label">登录密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="loginPwd" type="password" class="form-control" id="create-loginPwd">
                        </div>
                        <label for="create-confirmPwd" class="col-sm-2 control-label">确认密码<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="password" class="form-control" id="create-confirmPwd">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="email" type="text" class="form-control" id="create-email">
                        </div>
                        <label for="create-expireTime" class="col-sm-2 control-label">失效时间</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="expireTime" time type="text" class="form-control" id="create-expireTime">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-lockStatus" class="col-sm-2 control-label">锁定状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="lockStatus" class="form-control" id="create-lockStatus">
                                <option value="1">启用</option>
                                <option value="0">锁定</option>
                            </select>
                        </div>
                        <label for="create-dept" class="col-sm-2 control-label">部门<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="deptId" class="form-control" id="create-dept">
                                <option></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-allowIps" class="col-sm-2 control-label">允许访问的IP</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="allowIps" type="text" class="form-control" id="create-allowIps"
                                   style="width: 280%" placeholder="多个用逗号隔开">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>用户列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="position: relative; height: 80px; left: 30px; top: -10px;">
    <form id="searchForm" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">用户姓名</div>
                <input name="searchMap['name']" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">部门名称</div>
                <input name="searchMap['deptId']" class="form-control" type="text">
            </div>
        </div>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">锁定状态</div>
                <select name="searchMap['lockStatus']" class="form-control">
                    <option></option>
                    <option value="0">锁定</option>
                    <option value="1">启用</option>
                </select>
            </div>
        </div>
        <br><br>

        <div class="form-group">
            <div class="input-group">
                <div class="input-group-addon">失效时间</div>
                <input time name="searchMap['expireTime']" class="form-control" type="text" id="startTime"/>
            </div>
        </div>

        ~

        <div class="form-group">
            <div class="input-group">
                <input time class="form-control" type="text" id="endTime"/>
            </div>
        </div>

        <button id="searchBtn" type="button" class="btn btn-default">查询</button>

    </form>
</div>


<div class="btn-toolbar" role="toolbar"
     style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px; width: 110%; top: 20px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createUserModal"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
    <div class="btn-group" style="position: relative; top: 18%; left: 5px;">
        <button type="button" class="btn btn-default">设置显示字段</button>
        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
            <span class="caret"></span>
            <span class="sr-only">Toggle Dropdown</span>
        </button>
        <ul id="definedColumns" class="dropdown-menu" role="menu">
            <li><a href="javascript:void(0);"><input type="checkbox"/> 登录帐号</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 用户姓名</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 部门名称</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 邮箱</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 失效时间</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 允许访问IP</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 锁定状态</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 创建者</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 创建时间</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 修改者</a></li>
            <li><a href="javascript:void(0);"><input type="checkbox"/> 修改时间</a></li>
        </ul>
    </div>
</div>

<div style="position: relative; left: 30px; top: 40px; width: 110%">
    <table class="table table-hover" id="selecttable1">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input name="id" id="selectAll" type="checkbox"/></td>
            <td>序号</td>
            <td>登录帐号</td>
            <td>用户姓名</td>
            <td>部门名称</td>
            <td>邮箱</td>
            <td>失效时间</td>
            <td>允许访问IP</td>
            <td>锁定状态</td>
            <td>创建者</td>
            <td>创建时间</td>
            <td>修改者</td>
            <td>修改时间</td>
        </tr>
        </thead>
        <tbody id="tbody"></tbody>
    </table>
</div>


<div id="page" style="position: relative;top: 30px; left: 30px;">
</div>

</body>
</html>