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

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function(){
            //线索备注操作
            ButtonDecoration();
            //取消市场活动与当前线索的关联
            cancelClueRelationActivity();

            //查询所有市场活动
            RelatedMarketsBtn();

            //全选操作
            checkAll();

            //查询市场活动
            searchActivityByName();

            //添加关系
            addActivityRelationClue();
        });

        //添加关联关系
        function addActivityRelationClue() {
            //点击关联按钮 为空不向后台发送信息 提示选者市场活动
            $("#contiontBtn").click(function () {
                //拼接数据
                var ids = $("#RelationActivieModelTbaleBody input[type='checkbox']:checked");
                var clue_id = '${clue.id}';

                if (ids.size() != 0) {
                    //拼接参数
                    activityIds = "";
                    $.each(ids,function (index,obj) {
                        activityIds += "activityIds="+obj.value+"&";
                    })
                    activityIds += "clueId="+clue_id;

                    $.ajax({
                        url:'workbench/clue/addClueRelationActivity.do',
                        data:activityIds,
                        type:'post',
                        dataType:'json',
                        success:function (res){
                            var s = "";
                            if (res.code == "1"){
                                //回写数据到关联市场活动
                                $.each(res.otherDate,function (index,obj) {
                                    s+="<tr>";
                                    s+="<td>"+obj.name+"</td>";
                                    s+="<td>"+obj.startDate+"</td>";
                                    s+="<td>"+obj.endDate+"</td>";
                                    s+="<td>"+obj.owner+"</td>";
                                    s+="<td><a  style=\"text-decoration: none;\" clue_id=\"${clue.id}\" activity_id=\""+obj.id+"\"><span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
                                    s+="</tr>"
                                })
                                //覆盖
                                $("#clue_detail_activity_tbody").html(s);
                                $("#bundModal").modal("hide");
                            }else {
                                alert(res.msg);
                            }
                        }
                    })
                }else {
                    alert("请选择需要关联的市场活动");
                    return;
                }
            })


        }

        //名称查询市场活动
        function searchActivityByName() {
            //点击搜索图标上传
            $("#search_box").keyup(function () {
                var clueId = "${clue.id}";
                var activityName = this.value;

                $.ajax({
                    url:'workbench/clue/ClueRelatedAllMarkets.do',
                    data:{
                        clueId:clueId,
                        activityName:activityName
                    },
                    type:'post',
                    dataType:'json',
                    success:function (res) {
                        // 拼接参数
                        var str = "";
                        
                        //遍历数组
                        $.each(res,function (index,obj) {
                            str +="<tr>";
                            str +="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
                            str +="<td>"+obj.name+"</td>";
                            str +="<td>"+obj.startDate+"</td>";
                            str +="<td>"+obj.endDate+"</td>";
                            str +="<td>"+obj.owner+"</td>";
                            str +="</tr>";
                        })

                        $("#RelationActivieModelTbaleBody").html(str);
                    }
                })
            })

        }

        //全选操作
       function checkAll(){
           //全选操作
           $("#chckAll").click(function () {
               //如果"全选"按钮是选中状态，则表中所有checkbox都选中
               /* if(this.checked == true){
                    $("#tbodyScope input[type='checkbox']").prop('checked',true);
                }else {
                    $("#tbodyScope input[type='checkbox']").prop('checked',false);
                }*/

               //等同上面的写法
               $("#RelationActivieModelTbaleBody input[type='checkbox']").prop("checked",this.checked);
           })

           //当单选个数达到全部个数时选中全部 缺少一个取消全选
           $("#RelationActivieModelTbaleBody").on("click",$("#RelationActivieModelTbaleBody input[type='checkbox']:checked"),function () {
               if ($("#RelationActivieModelTbaleBody input[type='checkbox']:checked").size() == $("#RelationActivieModelTbaleBody input[type='checkbox']").size()){
                   $("#chckAll").prop("checked",true);
               }else {
                   $("#chckAll").prop("checked",false);
               }
           })
       }

        //点击关联活动
        function RelatedMarketsBtn() {
            $("#RelatedMarketsBtn").click(function () {
                //重置 上次选择的多选框
                $("#chckAll").prop("checked",false);
                //清空搜索框
                $("#search_box").val("")
                var clueId = '${clue.id}' ;
                //发送Ajax请求未关联的数据
                $.ajax({
                    url:'workbench/clue/ClickCreateRelationClueAndActivity.do',
                    data:{
                        clueId:clueId
                    },
                    type:'post',
                    dataType:'json',
                    success:function (res) {
                        var str = "";
                        $.each(res,function (index,obj){
                            str += "<tr>";
                            str += "<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
                            str += " <td>"+obj.name+"</td>";
                            str += "<td>"+obj.startDate+"</td>";
                            str += "<td>"+obj.endDate+"</td>";
                            str += "<td>"+obj.owner+"</td>";
                            str += "</tr>";
                        })
                        $("#RelationActivieModelTbaleBody").html(str);
                    }
                })
                $("#bundModal").modal("show");
            })
        }
        //取消市场活动与当前线索的关联
        function cancelClueRelationActivity() {
            //鼠标滑上
            $("#clue_detail_activity_tbody").on("mouseover", 'tr td a',function () {
                $(this).css("color", "#eb507e");
            })

            //鼠标移除
            $("#clue_detail_activity_tbody").on("mouseout", 'tr td a',function () {
                $(this).css("color", "#2177b8");
            })

            //获取单击 'a'标签触发事件
            $("#clue_detail_activity_tbody").on('click','tr td a',function () {
                var a_object = $(this);
                var clueId = $(this).attr("clue_id");
                var activityId = $(this).attr("activity_id");

                if (window.confirm("确定要取消该联系吗？")){
                    $.ajax({
                        url:'workbench/clue/cancelClueRelationActivity.do',
                        data:{
                            clueId:clueId,
                            activityId:activityId
                        },
                        type:'post',
                        dataType:'json',
                        success:function (res) {
                            if (res.code=="1"){
                                //移除当前行元素
                                a_object.parent().parent().remove();
                            }else {
                                alert(res.msg);
                            }
                        }

                    })
                }
            })
        }

        // //按钮修饰
        function ButtonDecoration() {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });

            $("#remarkList").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            })

            $("#remarkList").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            })

            $("#remarkList").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            })

            $("#remarkList").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            })

            //获取删除图标并添加点击事件
            $("#remarkList").on("click","a[name='deleteA']",function () {
                var id = $(this).attr("remarkId");
                $.ajax({
                    url: 'workbench/clue/deleteClueRemark.do',
                    type: 'post',
                    dataType: 'json',
                    data: {
                        id:id
                    },
                    success:function (res) {
                        if(res.code=="1"){
                            //移除当前的DIV
                            $("#div_"+id).remove();
                        }else {
                            alert(res.msg);
                        }
                    }
                })
            })


            //点击修改图标 获取备注id 获取内容 写入模态窗口 弹出模态串口
            $("#remarkList").on("click","a[name='editA']",function () {

                var remark_id = $(this).attr("remarkId");
                var remark_content = $("#div_"+remark_id+" h5").text();

                //写入模态串口
                $("#noteContent").text(remark_content);
                $("#edit_id").val(remark_id);
                $("#editRemarkModal").modal("show");

            })

            //点击更新按钮
            $("#updateRemarkBtn").click(function () {

                var remark_id = $("#edit_id").val();
                var remark_content = $.trim($("#noteContent").val());

                $.ajax({
                    url:'workbench/clue/editClueRemark.do',
                    data:{
                        id:remark_id,
                        noteContent:remark_content
                    },
                    type:'post',
                    dataType:'json',
                    success:function (res) {
                        if (res.code == 1){
                            //回填内容 更改h5中的内容 更改创建时间为修改时间 创建为修改
                            $("#div_"+res.otherDate.id + " h5").text(res.otherDate.noteContent);
                            var str = res.otherDate.editTime+"由"+res.otherDate.editBy+"修改";
                            $("#div_"+res.otherDate.id + " small").text(str);
                            //关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                        }else {
                            alert(res.msg);
                            return;
                        }
                    }
                })
            })

            //点击保存市场备注信息
            $("#SavaActivityRemarkBtn").click(function () {
                //收集参数
                var remarContext = $("#remark").val();
                var clue_id= '${clue.id}';

                //验证参数
                if (remarContext ==""){
                    alert("备注内容不能为空！");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/clue/savaClueRemark.do',
                    type:'post',
                    dataType:'json',
                    data:{
                        clueId:clue_id,
                        noteContent:remarContext
                    },
                    success:function (res) {
                        if (res.code == "1"){
                            $("#remark").val("");
                            //拼接参数
                            var str1 = "";
                            str1 += "<div class=\"remarkDiv\" id=\"div_"+res.otherDate.id+"\" style=\"height: 60px;\">";
                            str1 +="<img title=\"${sessionScope.sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            str1 += "<div style=\"position: relative; top: -40px; left: 40px;\" >";
                            str1 += "<h5>"+res.otherDate.noteContent+"</h5>";
                            str1 += "<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}</b> <small style=\"color: gray;\">"+res.otherDate.createTime+"由${sessionScope.sessionUser.name}创建</small>";
                            str1 += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            str1 += "<a class=\"myHref\" name=\"editA\" remarkId=\""+res.otherDate.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            str1 += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            str1 += "<a class=\"myHref\" name=\"deleteA\" remarkId=\""+res.otherDate.id+"\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\" style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            str1 += " </div>";
                            str1 += "</div>";
                            str1 += "</div>";

                            $("#remarkDiv").before(str1);
                        }else {
                            alert(res.otherDate.msg);
                        }
                    }
                })
            });

        }
    </script>
</head>
<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
            </div>
            <div  class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="search_box" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
                            <span  class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input id="chckAll" type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="RelationActivieModelTbaleBody">

                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="contiontBtn" class="btn btn-primary">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit_id">
                    <div class="form-group">
                        <label for="noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>${clue.fullname}${clue.appellation}<small>${clue.company}</small></h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/toConvert.do?id=${clue.id}'"><span class="glyphicon glyphicon-retweet"></span> 转换</button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.source}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.state}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.contactSummary}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${clue.address}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkList" style="position: relative; top: 40px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${clueRemarks}" var="remark">
        <div class="remarkDiv" id="div_${remark.id}" style="height: 60px;">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;" >
                <h5>${remark.noteContent}</h5>
                <font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}</b> <small style="color: gray;"> ${remark.editFlag == '1' ? remark.editTime : remark.createTime}由${remark.editFlag == '1' ? remark.editBy : remark.createBy} ${remark.editFlag == '1' ? '修改' : '创建'}</small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteA" remarkId="${remark.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" class="btn btn-primary" id="SavaActivityRemarkBtn" >保存</button>
            </p>
        </form>
    </div>

</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td>操作</td>
                </tr>
                </thead>
                <tbody id="clue_detail_activity_tbody">
                    <c:forEach items="${activityList}" var="ac">
                        <tr>
                            <td>${ac.name}</td>
                            <td>${ac.startDate}</td>
                            <td>${ac.endDate}</td>
                            <td>${ac.owner}</td>
                            <td><a  style="text-decoration: none;" clue_id="${clue.id}" activity_id="${ac.id}"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a id="RelatedMarketsBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus" ></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>
