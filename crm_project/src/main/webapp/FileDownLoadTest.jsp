<%--
  Created by IntelliJ IDEA.
  User: 23705
  Date: 2023/5/1
  Time: 17:18
  To change this template use File | Settings | File Templates.
--%>
<%
  String baseString = request.getScheme()+"://" + request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>测试文件下载</title>
    <base href="<%=baseString%>">
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
</head>
<body>
    <button type="button" id="downloadBtn">下载</button>
    <script type="text/javascript">
        $(function () {
            $("#downloadBtn").click(function () {
                window.location = "workbench/fileDownLoad.do";
            })
        })
    </script>
</body>
</html>
