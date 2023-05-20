<%--
  Created by IntelliJ IDEA.
  User: 小涂
  Date: 2023/1/30
  Time: 9:55
  To change this template use File | Settings | File Templates.
--%>

<%
    String baseString = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
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
        $(function () {
            //发送ajax请求 刷新界面
            sendAjax(1,10);

            //点击创建按钮 弹出模态窗口
            initCreateBefore();
            //全选操作
            selectAll(false);

            //如每一个都选中 勾上全选按钮
            selectAll(true);

            //创建保存
            createSavaInfo();

            //日历插件
            dateTimepickerShow();

            //更新
            editCludeInfo();
            //删除
            deleteByIds();
            //查询
            ConditionSearch();
            //重置查询条件
            resetConditionSerach();
            //详细界面跳转

        })

        //删除线索
        function deleteByIds() {
            //点击删除按钮 判断所选个数书否为空 判断确定要删除吗
            $("#deleteBtn").click(function () {
                //已选的多选框是否为空
                var allIds = $("#tbodyScope input[type='checkbox']:checked");

                if (allIds.size() != 0){
                    var ids ="";
                    $.each(allIds,function () {
                        ids += 'ids=' +this.value + '&';
                    })
                   ids = ids.substring(ids.length-1,ids,length);

                    if (window.confirm("确定要删除所选中信息吗？")){
                        $.ajax({
                            url:'workbench/deleteClueByIds.do',
                            data:ids,
                            dataType:'json',
                            type:'post',
                            success:function (res) {
                                if (res.code == "1"){
                                    alert("删除成功！");
                                    sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'))
                                }else {
                                    alert(res.msg);
                                }
                            }
                        })
                    }
                }else {
                    alert("数据不能为空，请选择！");
                    return;
                }
            })
        }


        //重置查询条件按钮
        function resetConditionSerach() {
            $("#resetConditionSearch").click(function () {
                //获取参数
                var fullname = $("#clue-fullname").val("");
                var company = $("#clue-company").val("");
                var phone = $("#clue-phone").val("");
                var source = $("#clue-source").val("");
                var owner = $("#clue-clueOwner").val("");
                var mphone =$("#clue-mphone").val("");
                var state = $("#clue-states").val("");

                sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
            })
        }
        
        
        //条件查询
        function ConditionSearch() {
            //点击查询按钮 刷新ajax请求
            $("#conditionSearch").click(function () {
                //sendAjax($("#mypagination").bs_pagination('getOption','currentPage'),$("#mypagination").bs_pagination('getOption','rowsPerPage'));
                sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
            })
        }

        //修改线索信息
        function editCludeInfo() {
            //点击修改按钮
            $("#edit-clue-info-btn").click(function () {
                //拿到选中的checkbox,限制个数为一个
                var checkboxOne = $("#tbodyScope input[type='checkbox']:checked");
                if (checkboxOne.size() == 0) {
                    alert("请选择要修改的记录！");
                    return;
                }
                //拿到一个更具id查询后台拿到数据回填修改表单
                if (checkboxOne.size() == 1){
                    var id = $("#tbodyScope input[type='checkbox']:checked").val();
                    $.ajax({
                        url:'workbench/clue/queryClueById.do',
                        data:{
                            id:id
                        },
                        type:'post',
                        dataType:'json',
                        success:function (res) {
                            //回填数据
                            $("#edit-clue-info-hide-box").val(res.id);
                            $("#edit-status").val(res.state);
                            $("#edit-company").val(res.company);
                            $("#edit-clueOwner").val(res.owner);
                            $("#edit-source").val(res.source);
                            $("#edit-call").val(res.appellation);
                            $("#edit-surname").val(res.fullname);
                            $("#edit-job").val(res.job);
                            $("#edit-email").val(res.email);
                            $("#edit-phone").val(res.phone);
                            $("#edit-mphone").val(res.mphone);
                            $("#edit-website").val(res.website);
                            $("#edit-describe").val(res.description);
                            $("#edit-nextContactTime").val(res.nextContactTime);
                            $("#edit-contactSummary").val(res.contactSummary);
                            $("#edit-address").val(res.address);
                            //显示窗口
                            $("#editClueModal").modal("show");
                        }
                    })

                }else {
                    alert("一次只能修改一条数据！");
                }
            })

            //点击更新
            $("#edit-save-clue-info-btn").click(function () {
                //收集参数
                var id =  $("#edit-clue-info-hide-box").val();
                var owner            =$("#edit-clueOwner").val();
                var fullname         =$.trim($("#edit-surname").val());
                var appellation      =$("#edit-call").val();
                var company          =$.trim($("#edit-company").val());
                var job              =$.trim($("#edit-job").val());
                var email            =$.trim($("#edit-email").val());
                var phone            =$.trim($("#edit-phone").val());
                var website          =$.trim($("#edit-website").val());
                var mphone           =$.trim($("#edit-mphone").val());
                var state            =$("#edit-status").val();
                var source           =$("#edit-source").val();
                var description      =$.trim($("#edit-describe").val());
                var contactSummary  =$.trim($("#edit-contactSummary").val());
                var nextContactTime=$("#edit-nextContactTime").val();
                var address          =$.trim($("#edit-address").val());

                if (owner == ""){
                    alert("所有者不能为空！");
                    $('#edit-clueOwner').focus();
                    return false;
                }
                if (company == "") {
                    alert("公司不能为空！");
                    $('#edit-company').focus();
                    return false;
                }
                //参数验证
                if (fullname == ""){
                    alert("姓名不能为空！");
                    $('#edit-surname').focus();
                    return false;
                }

                //使用正则判断是否合法
                if (email!=""){
                    var regx = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                    if (!regx.test(email)){
                        alert("邮箱格式不合法！");
                        $('#edit-email').focus();
                        return false;
                    }
                }
                if (phone != "") {
                    var regx_phone = /^(((\d{3,4}-)?[0-9]{7,8})|(1(3|4|5|6|7|8|9)\d{9}))$/;
                    if (!regx_phone.test(phone)) {
                        alert("座机号码不合法！");
                        $('#edit-phone').focus();
                        return false;
                    }
                }

                if (mphone != ""){
                    var myreg = /^1[3456789]\d{9}$/;

                    if(mphone.length !=11){
                        message = "请输入有效的手机号码！";
                        alert(message);
                        $('#edit-mphone').focus();
                        return false;
                    }else if(!myreg.test(mphone)){
                        message = "请输入有效的手机号码！";
                        $('#edit-mphone').focus();
                        alert(message);
                        return false;
                    }
                }

                //验证网站
                if (website != ""){
                    var urlRegex = /^(https?|ftp):\/\/(([\w-]+\.)*[\w-]+|localhost)(:[0-9]+)?(\/([\w#!:.?+=&%@!\-\/]))?$/i;

                    if (!urlRegex.test(website)) {
                        message = "请输入有效的网址链接！";
                        alert(message);
                        $('#edit-website').focus();
                        return false;
                    }
                }

                    //发送请求 成功后刷新当前页
                    $.ajax({
                        url:'workbench/clue/editClue.do',
                        data:{
                            id:id,
                            owner          : owner          ,
                            fullname       : fullname       ,
                            appellation    : appellation    ,
                            company        : company        ,
                            job            : job            ,
                            email          : email          ,
                            phone          : phone          ,
                            website        : website        ,
                            mphone         : mphone         ,
                            state          : state          ,
                            source         : source         ,
                            description    : description    ,
                            contactSummary : contactSummary ,
                            nextContactTime: nextContactTime,
                            address        : address        ,
                        },
                        type:'post',
                        dataType:'json',
                        success:function (res) {
                            if (res.code == "1"){
                                //刷新当前页 关闭模态窗口
                                sendAjax($("#mypagination").bs_pagination('getOption','currentPage'),$("#mypagination").bs_pagination('getOption','rowsPerPage'));
                                //关闭模态窗口
                                $("#editClueModal").modal("hide");
                            }else {
                                alert(res.msg);
                            }
                        }
                    })
            })
        }


        //创建初始表单
        function initCreateBefore() {
            $("#createClueBtn").click(function () {
                //重置表单
                $("#create_form_data")[0].reset();
                $("#createClueModal").modal("show");
            })
        }
        
        //创建保存
        function createSavaInfo() {
            //点击保存按钮
            $("#create-save-btn").click(function () {
                //收集参数
                var fullname         =$.trim($("#create-fullname").val());
                var appellation      =$("#create-appellation").val();
                var owner            =$("#create-owner").val();
                var company          =$.trim($("#create-company").val());
                var job              =$.trim($("#create-job").val());
                var email            =$.trim($("#create-email").val());
                var phone            =$.trim($("#create-phone").val());
                var website          =$.trim($("#create-website").val());
                var mphone           =$.trim($("#create-mphone").val());
                var state            =$("#create-state").val();
                var source           =$("#create-source").val();
                var description      =$.trim($("#create-description").val());
                var contactSummary  =$.trim($("#create-contact_summary").val());
                var nextContactTime=$("#create-next_contact_time").val();
                var address          =$.trim($("#create-address").val());

                if (checkParameter(owner,company,fullname,email,phone,mphone,website)){
                    //发送保存请求
                    $.ajax({
                        url:'workbench/clue/createClue.do',
                        data:{
                            fullname       :   fullname,
                            appellation    :   appellation,
                            owner          :   owner,
                            company        :   company,
                            job            :   job,
                            email          :   email,
                            phone          :   phone,
                            website        :   website,
                            mphone         :   mphone,
                            state          :   state,
                            source         :   source,
                            description    :   description,
                            contactSummary :   contactSummary,
                            nextContactTime:   nextContactTime,
                            address        :   address,
                        },
                        type:'post',
                        dataType:'json',
                        success:function (res) {
                            if (res.code == "1"){
                                console.log(res);
                                //请求成功分页查询
                                sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'))
                                //关闭模态窗口
                                $("#createClueModal").modal("hide");
                            }else {
                                alert(res.msg);
                            }
                        }
                    })
                }
            })
        }

        //全选操作
        function selectAll(flag) {
            //第一种全部选上才勾选
            if (flag){
                $("#tbodyScope").on("click",$("#tbodyScope input[type='checkbox']"),function (){
                    if ($("#tbodyScope input[type='checkbox']:checked").size() == $("#tbodyScope input[type='checkbox']").size()){
                        $("#chckAll").prop("checked",true);
                    }else {
                        $("#chckAll").prop("checked",false);
                    }
                })
            }else {
                //点击全选
                //全选操作
                $("#chckAll").click(function () {
                    //如果"全选"按钮是选中状态，则表中所有checkbox都选中
                    /* if(this.checked == true){
                         $("#tbodyScope input[type='checkbox']").prop('checked',true);
                     }else {
                         $("#tbodyScope input[type='checkbox']").prop('checked',false);
                     }*/

                    //等同上面的写法
                    $("#tbodyScope input[type='checkbox']").prop("checked",this.checked);  })
            }



        }


        //判断参数合法性
        function checkParameter(owner,company,fullname,email,phone,mphone,website) {
            if (owner == ""){
                alert("所有者不能为空！");
                $('#create-owner').focus();
                return false;
            }
            if (company == "") {
                alert("公司不能为空！");
                $('#create-company').focus();
                return false;
            }
            //参数验证
            if (fullname == ""){
                alert("姓名不能为空！");
                $('#create-fullname').focus();
                return false;
            }

            //使用正则判断是否合法
            if (email!=""){
                var regx = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
                if (!regx.test(email)){
                    alert("邮箱格式不合法！");
                    $('#create-email').focus();
                    return false;
                }
            }
            if (phone != "") {
                var regx_phone = /^(((\d{3,4}-)?[0-9]{7,8})|(1(3|4|5|6|7|8|9)\d{9}))$/;
                if (!regx_phone.test(phone)) {
                    alert("座机号码不合法！");
                    $('#create-phone').focus();
                    return false;
                }
            }

            if (mphone != ""){
                var myreg = /^1[3456789]\d{9}$/;

                if(mphone.length !=11){
                    message = "请输入有效的手机号码！";
                    alert(message);
                    $('#create-mphone').focus();
                    return false;
                }else if(!myreg.test(mphone)){
                    message = "请输入有效的手机号码！";
                    $('#create-mphone').focus();
                    alert(message);
                    return false;
                }
            }

            //验证网站
            if (website != ""){
                var urlRegex = /^(https?|ftp):\/\/(([\w-]+\.)*[\w-]+|localhost)(:[0-9]+)?(\/([\w#!:.?+=&%@!\-\/]))?$/i;

                if (!urlRegex.test(website)) {
                    message = "请输入有效的网址链接！";
                    alert(message);
                    $('#create-website').focus();
                    return false;
                }
            }

            return true;
        }


        //日历插件
        function dateTimepickerShow() {
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
        }


        /*市场活动初始化界面数据*/
        function sendAjax(pageNo,pageSize) {
            //获取参数
            var fullname = $.trim($("#clue-fullname").val());
            var company = $.trim($("#clue-company").val());
            var phone = $.trim($("#clue-phone").val());
            var source = $("#clue-source").val();
            var owner = $.trim($("#clue-clueOwner").val());
            var mphone = $.trim($("#clue-mphone").val());
            var state = $("#clue-states").val();
            var pageNo = pageNo;
            var pageSize = pageSize;

            $.ajax({
                url: 'workbench/clue/queryAllClueByByConditionForPage.do',
                data: {
                    fullname:fullname,
                    owner:owner,
                    company:company,
                    phone:phone,
                    source:source,
                    mphone:mphone,
                    state:state,
                    pageNo:pageNo,
                    pageSize:pageSize
                },
                type: 'post',
                dataType: 'json',
                success:function (data) {
                    //遍历数据
                    var str = "";
                    //obj 循环变量
                    $.each(data.clueList,function (index,obj) {//obj是一个循环变量 与this同等
                        str += "<tr>"
                            +"<td><input value=\""+obj.id+"\" type=\"checkbox\" /></td>"
                            +"<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/detailClue.do?clueId="+obj.id+"'\">"+obj.fullname+obj.appellation+"</a></td>"
                            +"<td>"+obj.company+"</td>"
                            +"<td>"+obj.phone+"</td>"
                            +"<td>"+obj.mphone+"</td>"
                            +"<td>"+obj.source+"</td>"
                            +"<td>"+obj.owner+"</td>"
                            +"<td>"+obj.state+"</td>"
                            +"</tr>"
                    });

                    $("#tbodyScope").html(str);

                    //取消全选时候的 下一页数据会后取消全选
                    $("#chckAll").prop("checked",false);

                    // 计算页数
                    var totalPages = 1;
                    if (data.clueCount % pageSize == 0){
                        totalPages = data.clueCount / pageSize;
                    }else {
                        totalPages = parseInt(data.clueCount / pageSize ) + 1;
                    }
                    //分页插件
                    $("#mypagination").bs_pagination({
                        currentPage: pageNo,
                        rowsPerPage: pageSize, //每页条数
                        totalPages: totalPages,//总页数
                        totalRows: data.clueCount,//总条数

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
                <form class="form-horizontal" id="create_form_data" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <option></option>
                               <c:forEach items="${userList}" var="u">
                                   <option value="${u.id}">${u.name}</option>
                               </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellation}" var="app">
                                    <option value="${app.id}">${app.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueState}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${source}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contact_summary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contact_summary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-next_contact_time" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" readonly placeholder="请选择日期" id="create-next_contact_time">
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="create-save-btn">保存</button>
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
                <form class="form-horizontal" role="form">
                    <input type="hidden" value="" id="edit-clue-info-hide-box">
                    <div class="form-group">
                        <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-clueOwner">
                                <option></option>
                                <c:forEach items="${userList}" var="u">
                                    <option value="${u.id}">${u.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-call">
                                <option></option>
                                <c:forEach items="${appellation}" var="app">
                                    <option value="${app.id}">${app.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-surname" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website" value="">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-status">
                                <option></option>
                                <c:forEach items="${clueState}" var="clueState">
                                    <option value="${clueState.id}">${clueState.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${source}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label ">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control mydate" readonly id="edit-nextContactTime" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>

                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="edit-save-clue-info-btn">更新</button>
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
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" id="clue-fullname" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" id="clue-company" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" id="clue-phone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="clue-source">
                            <option></option>
                            <c:forEach items="${source}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <select class="form-control" id="clue-clueOwner">
                            <option></option>
                            <c:forEach items="${userList}" var="u">
                                <option value="${u.id}">${u.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>



                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" id="clue-mphone" type="text">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="clue-states">
                            <option></option>
                            <c:forEach items="${clueState}" var="clueState">
                                <option value="${clueState.id}">${clueState.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" id="conditionSearch" class="btn btn-default">查询</button>
                <button type="button" id="resetConditionSearch" class="btn btn-default">重置</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
                <button type="button" class="btn btn-default" id="edit-clue-info-btn" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input id="chckAll" type="checkbox" /></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="tbodyScope">
                </tbody>
            </table>
        </div>

        <%--分页插件控件--%>
        <div style="height: 50px; position: relative;top: 60px;">
            <div id="mypagination"></div>
        </div>

    </div>

</div>
</body>
</html>
