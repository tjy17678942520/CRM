<%--
  Created by IntelliJ IDEA.
  User: 小涂
  Date: 2023/1/30
  Time: 9:55
  To change this template use File | Settings | File Templates.
--%>

<%
    //  http://127.0.0.1:8080/crm/settings/qx/user/toLogin.do
    String baseString = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <base href="<%=baseString%>">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

</head>
<body>
<img src="image/home.png" style="position: relative;top: -10px; left: -10px;"/>
</body>
</html>