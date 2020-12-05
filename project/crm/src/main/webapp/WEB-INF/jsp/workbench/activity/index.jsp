<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <%@include file="/WEB-INF/jsp/inc/commons_head.jsp" %>
    <script type="text/javascript">
        jQuery(function ($) {
            //以下日历插件在FF中存在兼容问题，在IE浏览器中可以正常使用。
            $("input[time]").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                clearBtn: true,
                pickerPosition: "bottom-left"
            });

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            // 加载列表数据
            function load(currentPage, rowsPerPage) {
                // 获取查询条件
                var searchData = $("#searchForm").formJSON();
                searchData.currentPage = currentPage;
                searchData.rowsPerPage = rowsPerPage;

                $.ajax({
                    url: "/act/getPage.json",
                    data: searchData,
                    success: function (page) {
                        // 遍历当前页数据，初始化表格
                        var htmlArr = new Array(page.data.length);
                        $(page.data).each(function (i) {
                            htmlArr.push(
                                '<tr class="'+(i%2==0?"active":"")+'">\
                                    <td><input name="id" value="'+this.id+'" type="checkbox"/></td>\
                                    <td><a style="text-decoration: none; cursor: pointer;">'+this.name+'</a></td>\
                                    <td>'+this.owner+'</td>\
                                    <td>'+this.startDate+'</td>\
                                    <td>'+this.endDate+'</td>\
                                </tr>'
                            );
                        });

                        $("#dataBody").html( htmlArr.join() );
                       // $("#selectAll").prop("checked", false);

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
            });

            //全选
            $("#selectAll").click(function (){
                $(":checkbox[name=id]").prop("checked",this.checked )
            })
            $("#dataBody").on("click",":checkbox[name=id]",function (){
                $("#selectAll").prop("checked",$(":checkbox[name=id]").size() == $(":checkbox[name=id]:checked").size())
            })

          // 获取系统用户列表（所有者下拉框）
            $.ajax({
                url: "/user/getAllOwner.json",
                success: function (data) {
                    // ["zs|张三", "ls|李四", ...]
                    $(data).each(function () {
                        //$("<option value='"+this+"'>"+this+"</option>")
                        $("<option>", {
                            value: this,
                            text: this
                        }).
                        // 将创建好的元素添加到指定的元素中
                        appendTo("select[name=owner]")
                    });
                }
            });

            // 创建市场活动时，所有者默认选中当前登录用户
            $("#createBtn").click(function () {
                $("#createActivityModal select[name=owner]").val("${user.loginAct}|${user.name}");
            });

            $("#saveBtn").click(function () {
                var name = $("#addForm :input[name=name]").val()
                if(name==null || name==''){
                    $.alert("名称不能为空")
                    return false;
                }
                $.ajax({
                    url: "/act/save.do",
                    type: "post",
                    data: $("#addForm").formJSON(),
                    success: function (data) {
                        if (data.success) {
                            $("#createActivityModal").modal("hide");
                            // 重新加载列表
                            load(1, $("#page").bs_pagination("getOption", "rowsPerPage"));
                        }
                    }
                });
            });

            //修改前的回显
            $("#editBtn").click(function () {
                var ids = $(":checkbox[name=id]:checked")
                var id = ids.size();
                if(!id){
                    alert("请选择修改项！")
                    return false;
                }
                if(id>1){
                    alert("只能选择一个！")
                    return false;
                }
                $.ajax({
                    url:"/act/getone.json?id="+ids.val(),
                    success:function (data){
                        $("#editForm :input[name]").each(function (){
                           $(this).val(data[this.name])
                        })
                    }
                })
            })
            //确定修改
            $("#updateBtn").click(function (){
                var name = $("#editForm :input[name=name]").val();
                if(name==null || name==""){
                    $.alert("名称不能为空")
                    return false;
                }

                $.ajax({
                    url:"/act/update.do",
                    data:$("#editForm").formJSON(),
                    success:function (data){
                        if(data.success){
                            $("#editActivityModal").modal('hide');
                            load(1, $("#page").bs_pagination("getOption", 'rowsPerPage'));
                        }
                    }
                })
            })

            //删除
            $("#delBtn").click(function () {
                var ids = $(":checkbox[name=id]:checked").map(function () {
                    return this.value;
                }).get().join(",");
                if (!ids) {
                    $.alert("请选择删除项！");
                    return ;
                }
                $.confirm("确定删除吗？", function () {
                    $.ajax({
                        url: "/act/delete.do?ids="+ids,
                        success: function (data) {
                            if (data.success) {
                                load(1, $("#page").bs_pagination("getOption", 'rowsPerPage'));
                            }
                        }
                    });
                });

            });

            //导出
            $("#exportBtn").click(function (){
                // 文件下载不可以使用ajax来完成
                location = "/act/export.do";
            })

            //导入
            $("#importBtn").click(function (){
                var $upFile = $("#upFile")
            })
            $("#import").click(function () {
                var $upFile = $("#upFile");
                if(!$upFile.val()) {
                    $.alert("请选择文件！");
                    return;
                }

                // 获取选择的文件，拿到的是文件数组
                var files = $upFile.prop("files");
                var file = files[0];

                // 判断大小:不超过10M
                if ( file.size > 1024 * 1024 * 10) {
                    $.alert("选择的文件不能超过10M！");
                    return;
                }

                // 判断文件格式：xls 或 xlsx  不区分大小写
                if ( !/.+\.xlsx?$/i.test(file.name) ) {
                    $.alert("文件格式不正确，请选择xls或xlsx文件！");
                    return;
                }

                var formData = new FormData();
                formData.append("file", file);

                $.ajax({
                    url: "/act/import.do",
                    type: "post", // 必须为post
                    data: formData,
                    contentType: false, // 禁止jQuery对数据进行任何修改
                    processData: false, // 禁止jQuery对数据进行任何修改
                    success: function (data) {
                        if (data.success) {
                            $.alert("导入成功！");
                            load(1, $("#page").bs_pagination("getOption", 'rowsPerPage'));
                            $("#importActivityModal").modal("hide");
                        }
                    }
                });

            });

        });

    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="addForm" class="form-horizontal" role="form" autocomplete="off">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="owner" class="form-control" id="create-marketActivityOwner">
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="name" type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input time name="startDate" type="text" class="form-control" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input time name="endDate" type="text" class="form-control" id="create-endTime">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="cost" type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
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

<!-- 修改市场活动的模态窗口 -->
<div class="modal" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="editForm" class="form-horizontal" role="form" autocomplete="off">
                    <input name="id" type="hidden" />
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="owner" class="form-control" id="edit-marketActivityOwner">
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="name" type="text" class="form-control" id="edit-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input time name="startDate" type="text" class="form-control" id="edit-startTime">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input time name="endDate" type="text" class="form-control" id="edit-endTime">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="cost" type="text" class="form-control" id="edit-cost">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea name="description" class="form-control" rows="3" id="edit-describe"></textarea>
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


<!-- 导入市场活动的模态窗口 -->
<div class="modal" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：
                    <small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input id="upFile" type="file" accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>从XLS/XLSX文件中导入全部重复记录之前都会被忽略。</li>
                        <li>复选框值应该是1或者0。</li>
                        <li>日期值必须为MM/dd/yyyy格式。任何其它格式的日期都将被忽略。</li>
                        <li>日期时间必须符合MM/dd/yyyy hh:mm:ss的格式，其它格式的日期时间将被忽略。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="import" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>

<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
        </div>
    </div>
</div>
<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">
        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form id="searchForm" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;" autocomplete="off">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input name="searchMap['name']" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input name="searchMap['owner']" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">开始日期</div>
                        <input time name="searchMap['startDate']" class="form-control" type="text" id="startTime"/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input time name="searchMap['endDate']" class="form-control" type="text" id="endTime">
                    </div>
                </div>

                <button id="searchBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="createBtn" type="button" class="btn btn-primary" data-toggle="modal" data-target="#createActivityModal">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editBtn" type="button" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="delBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button id="importBtn" type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 导入
                </button>
                <button id="exportBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 导出
                </button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="selectAll" type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="dataBody">

                </tbody>
            </table>
        </div>

        <div id="page" style="position: relative;top: 30px;">
        </div>

    </div>

</div>
</body>
</html>