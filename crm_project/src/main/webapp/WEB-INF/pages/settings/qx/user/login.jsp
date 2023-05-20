<%--
  Created by IntelliJ IDEA.
  User: 小涂
  Date: 2023/2/1
  Time: 17:03
  To change this template use File | Settings | File Templates.
--%>

<%
    //  http://127.0.0.1:8080/crm/settings/qx/user/toLogin.do
    String baseString = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=baseString%>">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //回车登录
            $(window).keydown(function (e) {
                if (e.keyCode == 13) {
                    $("#buttonLogin").click();
                }
            })
            //给登录按钮加事件
            $("#buttonLogin").click(function () {


                //获取提交信息
                var loginAct = $.trim($("#loginAct").val());
                var loginPwd = $.trim($("#loginPwd").val());
                var isRemPwd = $("#isRemPwd").prop("checked");

                //验证表单
                if (loginAct == '') {
                    $("#msg").html("账户名不能为空");
                    return;
                }

                if (loginPwd == '') {
                    $("#msg").html("密码不能为空");
                    return;
                }

                //发送请求
                $("#msg").html('正在验证中.....');
                //发送请求
                $.ajax({
                    url: 'settings/qx/user/login.do',
                    data: {
                        loginAct: loginAct,
                        loginPwd: loginPwd,
                        isRemPwd: isRemPwd
                    },
                    type: 'post',
                    dataType: 'json',
                    success: function (data) {
                        if (data.code == '1') {
                            window.location.href = "workbench/index.do";
                        } else {
                            $("#msg").html(data.msg);
                            return;
                        }
                    },

                })
            });
        })
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2023&nbsp;小涂爱码</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.html" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" id="loginAct" value="${cookie.loginAct.value}" type="text"
                           placeholder="用户名">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" id="loginPwd" value="${cookie.loginPwd.value}" type="password"
                           placeholder="密码">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
                            <input type="checkbox" id="isRemPwd" checked="checked">
                        </c:if>
                        <c:if test="${ empty cookie.loginAct and  empty cookie.loginPwd}">
                            <input type="checkbox" id="isRemPwd">
                        </c:if>
                        十天内免登录
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg"></span>
                </div>
                <button type="button" id="buttonLogin" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>
