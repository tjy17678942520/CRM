
<%
    String baseString = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=baseString%>">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    
    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <script type="text/javascript">

        //点击创建 常出现模态窗口
        $(function(){

            //日期日历显示插件
            $(".mydate").datetimepicker({
                language:'zh-CN',//选择语言
                format:'yyyy-mm-dd',//日期的格式
                initData: new Date(),//默认日期
                autoclose:true,//选择日期后，是否自动关闭日期
                minView:'month',
                todayBtn:true,//是否显示今天按钮
                clearBtn:true,//是否显示清空按钮 默认不显示
            })

            //创建模态窗口
            $("#createActivityModelBtn").click(function (){
                $("#createActivityModelfrom").get(0).reset();
                //弹出市场活动的模态窗口 hide为关闭
                $("#createActivityModal").modal("show");
            });
            
            //创建市场活动添加保存按钮事件
            $("#savaActivityBtn").click(function () {
                //收集参数
                var owener = $("#create-marketActivityOwner").val();
                var caretName = $.trim($("#create-marketActivityName").val());
                var startTime = $("#create-startTime").val();
                var endTime = $("#create-endTime").val();
                var createCost =$.trim($("#create-cost").val());

                var createDescribe = $("#create-describe").val();
                
                if (CheckParameters (owener,caretName,startTime,endTime,createCost)){
                    //发送请求
                    $.ajax({
                        url:'workbench/activity/savaCreateActivity.do',
                        data:{
                            owner:owener,
                            name:caretName,
                            startDate:startTime,
                            endDate:endTime,
                            cost:createCost,
                            description:createDescribe
                        },
                        type:"post",
                        dataType:'json',
                        success:function (data) {
                            if (data.code==1){
                                //关闭模态窗口
                                sendAjax(1, $("#mypagination").bs_pagination('getOption','rowsPerPage'));
                                $("#createActivityModal").modal("hide");
                            }
                        }
                    })
                }
            })
            //初始页面
            sendAjax(1,10);

            //点击查询
            $("#slect").click(function () {
                sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
            })

            //全选操作
            $("#chckAll").click(function () {
                //如果"全选"按钮是选中状态，则表中所有checkbox都选中
               /* if(this.checked == true){
                    $("#tbodyScope input[type='checkbox']").prop('checked',true);
                }else {
                    $("#tbodyScope input[type='checkbox']").prop('checked',false);
                }*/

                //等同上面的写法
                $("#tbodyScope input[type='checkbox']").prop("checked",this.checked);
            })

            //该方式不能给动态的元素添加事件 也就是异步拼接上的数据
            // $("#tbodyScope input[type='checkbox']").click(function () {
            //     if ($("#tbodyScope input[type='checkbox']:checked").size() == $("#tbodyScope input[type='checkbox']").size()){
            //         alert("执行");
            //         $("#chckAll").prop("checked",true);
            //     }else {
            //         $("#chckAll").prop("checked",false);
            //     }
            // })

            //可以给动态的元素添加事件 父元素$("#tbodyScope")必须是固定元素不能是动态拼接而成的
            $("#tbodyScope").on("click",$("#tbodyScope input[type='checkbox']"),function (){
                    if ($("#tbodyScope input[type='checkbox']:checked").size() == $("#tbodyScope input[type='checkbox']").size()){
                        $("#chckAll").prop("checked",true);
                    }else {
                        $("#chckAll").prop("checked",false);
                    }
            })

            //删除市场活动记录
            //获取删除按钮事件
            $("#deleteActivityBtn").click(function () {
                //获取需要删除的数据id
               var chacedId = $("#tbodyScope input[type='checkbox']:checked");
                //验证数据是否正确 不正确不让提交
               if (chacedId.size() == 0){
                   alert("数据不能为空，请选择！");
                   return;
               }else {
                   //拼接参数对象
                   var ids = "";
                   $.each(chacedId,function () {
                        ids += "ids="+this.value+"&";
                   })
                   ids = ids.substring(0,ids.length-1);
                   //发送请求 正确使用Ajax发送异步请求
                   if (window.confirm("确定要删除吗？")){
                       $.ajax({
                           url:'workbench/deleteActivityByIds.do',
                           data:ids,
                           dataType:'json',
                           type:'post',
                           success:function (data) {
                               if (data.code == 1){
                                    //刷新界面
                                   sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
                               }else {
                                   alert(data.msg);
                                   return;
                               }
                           }
                       })
                   }

               }
            })


            //修改信息
            $("#ActivityModifyBtn").click(function () {
                //请求后台数据
                //拿到选中的checkbox,限制个数为一个
                var checkboxOne = $("#tbodyScope input[type='checkbox']:checked");
                if (checkboxOne.size() == 0) {
                    alert("请选择要修改的记录！");
                    return;
                }
                if (checkboxOne.size() == 1){
                    //为一个发送请求
                    $.ajax({
                        url:'workbench/queryActivityById.do',
                        type:'post',
                        dataType:'json',
                        data:{
                            id:checkboxOne[0].value,
                        },
                        success:function (data) {
                            //显示数据在模态窗口中
                            $("#edit-id").val(data.id);
                            //将id赋值给下拉列表
                            $("#edit-marketActivityOwner").val(data.owner);

                            $("#edit-marketActivityName").val(data.name);
                            $("#edit-startTime").val(data.startDate);
                            $("#edit-endTime").val(data.endDate);
                            $("#edit-cost").val(data.cost);
                            $("#edit-describe").val(data.description);
                            //弹出修改市场活动的模态窗口
                            $("#editActivityModal").modal('show')
                        }
                    })
                }else {
                    alert("一次只能修改一条数据！");
                }


            })

            //点击更新提交数据信息
            $("#SaveActivityModifyBtn").click(function () {
                //收集参数
                // name
                var name = $.trim($("#edit-marketActivityName").val());
                var Owner = $("#edit-marketActivityOwner").val();
                var startTime = $("#edit-startTime").val();
                var endTime = $("#edit-endTime").val();
                var cost =$.trim($("#edit-cost").val());
                var editDescribe = $.trim($("#edit-describe").val());

                //获取市场id
                var id = $("#edit-id").val();

                if (CheckParameters (name,"标记而已，不传后端",startTime,endTime,cost)) {
                    $.ajax({
                        url:'workbench/updataActivity.do',
                        data:{
                            owner:Owner,
                            name:name,
                            startDate:startTime,
                            endDate:endTime,
                            cost:cost,
                            description:editDescribe,
                            id:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (res) {
                            //关闭窗口显示在当前页页数不变 在当前行显示
                            if (res.code == 1){
                                //刷新当前页面条数大小不变
                                sendAjax($("#mypagination").bs_pagination('getOption','currentPage'),$("#mypagination").bs_pagination('getOption','rowsPerPage'))
                                //返回的数据 可以写入 太麻烦还是分页查询
                                // console.log(res);
                                //关闭模态窗口
                                $("#editActivityModal").modal('hide')
                            }else {
                                //提示用户出错信息 不关闭模态窗口
                                alert(res.msg);
                            }
                        }
                    })
                }
            })

            //导出全部数据
            $("#exportActivityAllBtn").click(function () {
                window.location = 'workbench/fileDownLoad.do';
            })

            //选择导出
            $("#exportActivityXzBtn").click(function () {
                //获取需要删除的数据id
                var chacedId = $("#tbodyScope input[type='checkbox']:checked");
                //验证数据是否正确 不正确不让提交
                if (chacedId.size() == 0){
                    alert("数据不能为空，请选择！");
                    return;
                }else {
                    //拼接参数对象

                    var ids = "";
                    $.each(chacedId, function () {
                        ids += "ids=" + this.value + "&";
                    })
                    ids = ids.substring(0, ids.length - 1);
                    //发送请求 正确使用Ajax发送异步请求
                    $.ajax({
                        url: 'workbench/ConditionalBatchExport.do',
                        data: ids,
                        dataType: 'json',
                        type: 'post',
                        success:function (data) {
                            if (data.code == 1){
                                // console.log(data)
                                window.location = "downloadExcel_d";
                            }else {
                                alert(data.msg);
                                return;
                            }
                        }
                    })
                }
            })

            //下载导入模板
            $("#importExcelTemplateBtn").click(function (){
                window.location = "workbench/downLoadExcelTemplate.do";
            })

            //给导入按钮添加单击事件
            $("#importActivityBtn").click(function () {
                //收集参数
                //不是文件本身 只是文件名
                var fileName = $("#activityFile").val();

                var xls = fileName.substring(fileName.length-3,fileName.length).toLowerCase();
                if (xls == 'xls'){
                    //获取文件
                    var file = $("#activityFile").get(0).files[0];

                    //FormData 是Ajax提供的接口， 相当于java的类 可以模拟键值对提交参数
                    //最大的优势能向后台提交 文本数据 还可以提交二进制数据
                    var formdata = new FormData();
                    formdata.append("file",file);

                    //文件大小不能超过5M
                    if (file.size <= 5 * 1024 * 1024){
                        $.ajax({
                            url:'workbench/importActivities.do',
                            data:formdata,
                            type:'post',
                            processData:false,//设置ajax向后台发送数据之前，是否把参数统一转化为字符串，true转换false不转化，默认是true
                            contentType:false,//设置ajax向后台提交参数前，是否把所有的参数统一按照urlencoded编码，默认是true
                            dataType:"json",
                            success:function (res) {
                                if (res.code == 1){
                                    //关闭模态窗口
                                    $("#importActivityModal").modal("hide");
                                    //刷新界面
                                    sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
                                    //件文件属性赋值为空
                                    $("#activityFile").get(0).files[0]='';
                                    $("#activityFile").val("");
                                    //提示成功导入多少条
                                    alert(res.msg);

                                }else {
                                    alert(res.msg);
                                }
                            }
                        })
                    }else {
                        alert("上传的文件过大，请确保文件是否小于5M！");
                        return;
                    }
                }else {
                    alert("上传的文件不支持，只支持xls文件");
                    return;
                }



            })


        });

        /*重置查询条件*/
        function clearBtn(){
            /*重置查询条件*/
            var name = $("#query_name").val("");
            var owner = $("#query-owner").val("");
            var startDate = $("#query_startDate").val("");
            var endDate = $("#query_endDate").val("");
            //恢复初始数据
            sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
        }
        /*市场活动初始化界面数据*/
        function sendAjax(pageNo,pageSize) {
            var name = $("#query_name").val();
            var owner = $("#query-owner").val();
            var startDate = $("#query_startDate").val();
            var endDate = $("#query_endDate").val();
            var pageNo = pageNo;
            var pageSize = pageSize;

            $.ajax({
                url: 'workbench/activity/queryAtivtyByConditionForPage.do',
                data: {
                    name:name,
                    owner:owner,
                    startDate:startDate,
                    endDate:endDate,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                type: 'post',
                dataType: 'json',
                success:function (data) {

                    // $("#totalRowsB").text(data.count);

                    //遍历数据
                    var str = "";
                    //obj 循环变量
                    $.each(data.activities,function (index,obj) {//obj是一个循环变量 与this同等
                        str += "<tr class=\"active\">"
                            +"<td><input type='checkbox' value='"+obj.id+"'/></td>"
                            +"<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"'\">"+obj.name+"</a></td>"
                            +"<td>"+obj.owner+"</td>"
                            +"<td>"+obj.startDate+"</td>"
                            +"<td>"+obj.endDate+"</td>"
                            +"</tr>"
                    });
                    $("#tbodyScope").html(str);

                    //取消全选时候的 下一页数据会后取消全选
                    $("#chckAll").prop("checked",false);

                     // 计算页数
                    var totalPages = 1;
                    if (data.count % pageSize == 0){
                        totalPages = data.count / pageSize;
                    }else {
                        totalPages = parseInt(data.count / pageSize ) + 1;
                    }
                    //分页插件
                    $("#mypagination").bs_pagination({
                        currentPage: pageNo,
                        rowsPerPage: pageSize, //每页条数
                        totalPages: totalPages,//总页数
                        totalRows: data.count,//总条数

                        visiblePageLinks: 5,

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,

                        onChangePage: function(event,pageObj) { // returns page_num and rows_per_page after a link has clicked
                            sendAjax(pageObj.currentPage,pageObj.rowsPerPage);
                        },

                    })
                }
            })
        }
        
        //验证数据是否正确
        function CheckParameters (owener,caretName,startTime,endTime,createCost) {
            //验证参数是否合法
            if (owener == ""){
                alert("所有者不能为空！");
                return false;
            }

            if (caretName == ""){
                alert("名称不能为空！");
                return false;
            }

            if(startTime != "" && endTime != ""){
                if (startTime > endTime){
                    alert("开始时间不得大于结束时间！");
                    return false;
                }
            }else {
                alert("时间不能为空,请检查！");
                return false;
            }

            //非负整数 判断
            var regx = /^(([1-9]\d*)|0)$/;
            if (!regx.test(createCost)){
                alert("成本必须大于零！");
                $("#create-cost").html("");
                return false;
            }

            return  true;
        }
    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form id="createActivityModelfrom" class="form-horizontal" role="form">

                    <div class="form-group">
                        <label for="create-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-marketActivityOwner">
                                <c:forEach items="${userlist}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-marketActivityName">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startTime" class="col-sm-2 control-label" >开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" readonly="true" placeholder="" id="create-startTime">
                        </div>
                        <label for="create-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate"  readonly="true"  id="create-endTime">
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-describe"  class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary"  id="savaActivityBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input type="hidden" value="" id="edit-id">
                    <div class="form-group">
                        <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-marketActivityOwner">
                                <c:forEach items="${userlist}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-marketActivityName" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-startTime" value="2020-10-10">
                        </div>
                        <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control mydate" id="edit-endTime" value="2020-10-20">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="SaveActivityModifyBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
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
                    请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <br>
                <div style="position: relative;top: 60px; left: 50px;"><button id="importExcelTemplateBtn">下载导入模板</button></div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
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
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control"  id="query_name" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" id="query-owner" type="text">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon " >开始日期</div>
                        <input class="form-control mydate" readonly type="text" id="query_startDate" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon ">结束日期</div>
                        <input class="form-control mydate" readonly type="text" id="query_endDate">
                    </div>
                </div>

                <button type="button" id="slect" class="btn btn-default">查询</button>
                <button type="button" onclick="clearBtn()" class="btn btn-default">清空</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityModelBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default"   id="ActivityModifyBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
            </div>
        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="chckAll" type="checkbox" /></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="tbodyScope">
                </tbody>
            </table>
        </div>

        <%--分页插件控件--%>
        <div style="height: 50px; position: relative;top: 30px;">
            <div id="mypagination"></div>
        </div>

    </div>

</div>
</body>
</html>
