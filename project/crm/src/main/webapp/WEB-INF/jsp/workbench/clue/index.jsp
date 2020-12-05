<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
   <%@include file="/WEB-INF/jsp/inc/commons_head.jsp"%>>
    <script type="text/javascript">

        $(function () {
            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });

            $("input[time]").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                clearBtn: true,
                pickerPosition: "top-left"
            });

            // 加载列表数据
            function load(currentPage, rowsPerPage) {
                // 获取查询条件
                var searchData = $("#searchForm").formJSON();
                searchData.currentPage = currentPage;
                searchData.rowsPerPage = rowsPerPage;
                $.ajax({
                    url: "/clue/getPage.json",
                    data: searchData,
                    success: function (page) {
                        // 遍历当前页数据，初始化表格
                        var htmlArr = new Array(page.data.length);
                        $(page.data).each(function (i) {
                            htmlArr.push(
                            `<tr>
                                <td><input name="id" value="`+this.id+`" type="checkbox"/></td>
                                <td><a style="text-decoration: none; cursor: pointer;"
                                onclick="window.location.href='detail.html?id=`+this.id+`';">`+this.fullName+this.appellation+`</a></td>
                                <td>`+this.company+`</td>
                                <td>`+this.phone+`</td>
                                <td>`+this.mphone+`</td>
                                <td>`+this.source+`</td>
                                <td>`+this.owner+`</td>
                                <td>`+this.state+`</td>
                            </tr>`
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
            //初始化所有者下拉框
            $.ajax({
                url:"/user/getAllOwner.json",
                success:function (data){
                    $(data).each(function (){
                        $("<option>",{
                            value:this,
                            text:this,
                        }).appendTo($("select[name=owner]"))
                    })
                }
            })
            //创建线索
            $("#saveBtn").click(function (){
                var company = $("#saveFrom :input[name=company]").val();
                var fullName = $("#saveFrom :input[name=fullName]").val();
                if(company==null || company==""){
                    alert("公司不能为空!")
                    return false;
                }
                if(fullName==null || fullName==""){
                    alert("姓名不能为空!")
                    return false;
                }
                $.ajax({
                    url:"/clue",
                    type:"post",
                    data:$("#saveFrom").formJSON(),
                    success:function (data){
                        if(data.success){
                            $("#createClueModal").modal("hide");
                            load(1,$("#page").bs_pagination("getOption", "rowsPerPage"))
                            $.alert("添加成功");
                        }
                    }
                })
            })

            //全选
            $("#selectAll").click(function (){
                $(":checkbox[name=id]").prop("checked",this.checked)
            })
            $("#tableAll").on("click",":checkbox[name=id]",function (){
                $("#selectAll").prop("checked",$(":checkbox[name=id]").size() == $(":checkbox[name=id]:checked").size())
            })

            //删除
            $("#deleteBtn").click(function () {
                var ids = $(":checkbox[name=id]:checked").map(function (){
                    return this.value;
                }).get().join(",")
                if(ids==null || ids==""){
                    $.alert("请选择删除项!")
                    return false;
                }
                $.ajax({
                    url:"/clue/"+ids,
                    type:"delete",
                    success:function (data){
                        if(data.success){
                            $.alert("删除成功")
                            load(1,$("#page").bs_pagination("getOption", "rowsPerPage"))
                        }
                    }
                })
            })

            //修改前回显
            $("#editBtn").click(function (){
                 var size = $(":checkbox[name=id]:checked").size();
                if(size==0){
                    $.alert("请选择修改项！")
                    return false;
                }
                if(size>1){
                    $.alert("只能选择一个!")
                    return false;
                }
                $.ajax({
                    url:"/clue/"+$(":checkbox[name=id]:checked").val(),
                    type:"get",
                    success:function (data){
                        $("#editFrom :input[name]").each(function (){
                            $(this).val(data[this.name])
                        })
                    }
                })
            })
            //确定修改
            $("#updateBtn").click(function (){
                var company = $("#editFrom :input[name=company]").val();
                var fullName = $("#editFrom :input[name=fullName]").val();
                if(company==null || company==""){
                    alert("公司不能为空!")
                    return false;
                }
                if(fullName==null || fullName==""){
                    alert("姓名不能为空!")
                    return false;
                }
                $.ajax({
                    url:"/clue",
                    type:"put",
                    data:$("#editFrom").formJSON(),
                    success:function (data){
                        if(data.success){
                            $("#editClueModal").modal("hide")
                            $.alert("修改成功")
                            load(1,$("#page").bs_pagination("getOption", "rowsPerPage"))
                        }
                    }
                })
            })

        });

    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form id="saveFrom" autocapitalize="off" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="owner" class="form-control" id="create-clueOwner">

                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="company" type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="appellation" class="form-control" id="create-call">
                                <option></option>
                                <c:forEach items="${dicMap.appellation}" var="v">
                                    <option value="${v.value}">${v.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="fullName" type="text" class="form-control" id="create-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="job" type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="email" type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="phone" type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="website" type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="mphone" type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="state" class="form-control" id="create-status">
                                <option></option>
                                <c:forEach items="${dicMap.clueState}" var="v">
                                    <option value="${v.value}">${v.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="source" class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${dicMap.source}" var="v">
                                    <option value="${v.value}">${v.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-describe" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea name="description" class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea name="contactSummary" class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input time name="nextContactTime" type="text" class="form-control" id="create-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea name="address" class="form-control" rows="1" id="create-address"></textarea>
                            </div>
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

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form id="editFrom" class="form-horizontal" role="form">
                    <input type="hidden" name="id" value="id" >

                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="owner" class="form-control" id="edit-clueOwner">
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="company"  type="text" class="form-control" id="edit-company" value="测试">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="appellation"  class="form-control" id="edit-call">
                                <option></option>
                                <c:forEach items="${dicMap.appellation}" var="v">
                                    <option value="${v.value}">${v.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="fullName"  type="text" class="form-control" id="edit-surname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="job"  type="text" class="form-control" id="edit-job">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="email"  type="text" class="form-control" id="edit-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input name="phone"  type="text" class="form-control" id="edit-phone">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input  name="website"  type="text" class="form-control" id="edit-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input  name="mphone"  type="text" class="form-control" id="edit-mphone">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="state"  class="form-control" id="edit-status">
                                <option></option>
                                <c:forEach items="${dicMap.clueState}" var="v">
                                    <option value="${v.value}">${v.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select name="source"  class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${dicMap.source}" var="v">
                                    <option value="${v.value}">${v.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea name="description"  class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea name="contactSummary"  class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input time name="nextContactTime"  type="text" class="form-control" id="edit-nextContactTime">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea name="address"  class="form-control" rows="1" id="edit-address"></textarea>
                            </div>
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


<!-- 导入线索的模态窗口 -->
<div class="modal fade" id="importClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">导入线索</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file">
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
                <button type="button" class="btn btn-primary" data-dismiss="modal">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form id="searchForm" class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input name="searchMap['fullName']" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input name="searchMap['company']" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input name="searchMap['phone']" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select name="searchMap['source']" class="form-control">
                            <option></option>
                            <c:forEach items="${dicMap.source}" var="v">
                                <option value="${v.value}">${v.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input name="searchMap['owner']" class="form-control" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input name="searchMap['mphone']" class="form-control" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select name="searchMap['state']" class="form-control">
                            <option></option>
                            <c:forEach items="${dicMap.clueState}" var="v">
                                <option value="${v.value}">${v.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button id="searchBtn" type="button" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#createClueModal"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button id="editBtn" type="button" class="btn btn-default" data-toggle="modal" data-target="#editClueModal"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button id="deleteBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importClueModal"><span
                        class="glyphicon glyphicon-import"></span> 导入
                </button>
                <button type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 导出
                </button>
            </div>

        </div>
        <div style="position: relative;top: 50px;">
            <table id="tableAll" class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="selectAll" type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="dataBody">

                </tbody>
            </table>
        </div>

        <div id="page" style=" position: relative;top: 60px;">
        </div>

    </div>

</div>
</body>
</html>
