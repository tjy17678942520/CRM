<%--
  Created by IntelliJ IDEA.
  User: 23705
  Date: 2023/5/4
  Time: 15:03
  To change this template use File | Settings | File Templates.
--%>
<%
    String baseUrl = request.getScheme() + "://"+request.getServerName() + ":" + request.getServerPort() + request.getContextPath()+ "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <base href="<%=baseUrl%>">
    <title>Title</title>

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

        $(function () {
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

            $("#remarkList").on("mouseover",".remarkDiv",function () {
                $(this).children("div").children("div").show();
            })

            $("#remarkList").on("mouseout",".remarkDiv",function () {
                $(this).children("div").children("div").hide();
            })

            $("#remarkList").on("mouseover",".myHref",function () {
                $(this).children("span").css("color", "red");
            })

            $("#remarkList").on("mouseout",".myHref",function () {
                $(this).children("span").css("color", "#E6E6E6");
            })

            //获取删除图标并添加点击事件
            $("#remarkList").on("click","a[name='deleteA']",function () {
               var id = $(this).attr("remarkId");
               $.ajax({
                   url: 'workbench/activity/deleteActivityRemark.do',
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
                    url:'workbench/activity/editActivityRemark.do',
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
                var activity_id = '${activity.id}';

                //验证参数
                if (remarContext ==""){
                    alert("备注内容不能为空！");
                    return;
                }

                //发送请求
                $.ajax({
                    url:'workbench/activity/savaActivityRemark.do',
                    type:'post',
                    dataType:'json',
                    data:{
                        activityId:activity_id,
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
                            str1 += "<font color=\"gray\">市场活动</font> <font color=\"gray\">-</font> <b>${activity.name}</b> <small style=\"color: gray;\">"+res.otherDate.createTime+"由${sessionScope.sessionUser.name}创建</small>";
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
        });

    </script>
</head>
<body>

<!-- 修改市场活动备注的模态窗口 -->
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
        <h3>市场活动-${activity.name}<small>${activity.startDate} ~ ${activity.endDate}</small></h3>
    </div>

</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>

    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">开始日期</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">成本</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>
                ${activity.description}
            </b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div id="remarkList" style="position: relative; top: 30px; left: 40px;">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <c:forEach items="${activityRemarks}" var="remark">
        <div class="remarkDiv" id="div_${remark.id}" style="height: 60px;">
        <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;" >
            <h5>${remark.noteContent}</h5>
            <font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> ${remark.editFlag == '1' ? remark.editTime : remark.createTime}由${remark.editFlag == '1' ? remark.editBy : remark.createBy} ${remark.editFlag == '1' ? '修改' : '创建'}</small>
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
<div style="height: 200px;"></div>
</body>
</html>
