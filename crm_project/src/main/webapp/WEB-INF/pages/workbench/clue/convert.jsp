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
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		//点击搜索图标初始化数据
		ClickSearchBtnLogo();

		//选者活动源之后回填数据
		checkedActivityResoure();
		
		//实现市场活动的键盘弹起发起请求
		searchActivityEvenKeyUp();

		//日历插件
		calendarShowPlugin();

		//点击转换
		clicConvertBtn();
	});

	function clicConvertBtn() {
		$("#submitConvertBtn").click(function () {
			//收集参数
			var	clueId        = '${clue.id}';
			var	name          = $.trim($("#tradeName").val());
			var	money         = $.trim($("#amountOfMoney").val());
			var	stage         = $("#stage").val();
			var	expectedDate  = $("#expectedClosingDate").val();
			var	activityId    = $("#activityResorseHideBox").val();
			var	isCreateTran  = $("#isCreateTransaction").prop("checked");

			if (isCreateTran == true) {
				//非负整数 判断
				var regx = /^(([1-9]\d*)|0)$/;
				if (!regx.test(money)){
					alert("成本必须大于零！");
					$("#amountOfMoney").html("");
					return false;
				}
			}
			$.ajax({
				url:'workbench/clue/saveConvertClue.do',
				data: {
					 clueId      :clueId      ,
					 name        :name        ,
					 money       :money       ,
					 stage       :stage       ,
					 expectedDate:expectedDate,
					 activityId  :activityId  ,
					 isCreateTran:isCreateTran
				},
				type:'post',
				dataType:'json',
				success:function (res) {
					if (res.code == "1") {
						//存在DicValueController 中
						window.location = "workbench/clue/index.do";
					}else {
						alert(res.msg);
					}
				}
			})
		})
	}


	//日历插件
	function calendarShowPlugin() {
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


	//实现市场活动的键盘弹起发起请求
	function searchActivityEvenKeyUp() {
		$("#searchActivityInput").keyup(function () {
			var activityName = $("#searchActivityInput").val();
			$.ajax({
				url: 'workbench/activity/queryAtivtysByLikeName.do',
				data:{
					activityName:activityName
				},
				type: 'post',
				dataType: 'json',
				success:function (res) {
					var str = "";
					$.each(res,function (index,obj) {
						str+="<tr>";
						str+="<td><input type=\"radio\" name=\""+obj.name+"\" value=\""+obj.id+"\"/></td>";
						str+="<td>"+obj.name+"</td>";
						str+="<td>"+obj.startDate+"</td>";
						str+="<td>"+obj.endDate+"</td>";
						str+="<td>"+obj.owner+"</td>";
						str+="</tr>";
					})
					$("#searchListBox").html(str);
				}
			})
		})
	}
	
	//选者活动源之后回填数据
	function checkedActivityResoure() {
		$("#searchListBox").on("click",$("#searchListBox input[type='radio']"),function () {
			//市场活动id
			var activityId = $("#searchListBox input[type='radio']:checked").val();
			//市场活动名字
			var activityName = $("#searchListBox input[type='radio']:checked").attr('name');

			$("#activityResorseHideBox").val(activityId);

			$("#activityResorse").val(activityName);

			$("#searchActivityModal").modal("hide");
		})
	}
	
	//点击搜索图标初始化数据
	function ClickSearchBtnLogo() {
		$("#searchImgLogo").click(function () {
			//清空搜索搜索框
			$("#searchActivityInput").val("");
			//查询所有市场活动源
			$.ajax({
				url:'workbench/activity/queryAtivtys.do',
				type:'post',
				dataType:'json',
				success:function (res) {
					var str = "";
					$.each(res,function (index,obj) {
						str+="<tr>";
						str+="<td><input type=\"radio\" name=\""+obj.name+"\" value=\""+obj.id+"\"/></td>";
						str+="<td>"+obj.name+"</td>";
						str+="<td>"+obj.startDate+"</td>";
						str+="<td>"+obj.endDate+"</td>";
						str+="<td>"+obj.owner+"</td>";
						str+="</tr>";
					})
					$("#searchListBox").html(str);
				}
			})
			$("#searchActivityModal").modal("show");
		})
	}
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchActivityInput" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="searchListBox">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullname}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullname}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" value="${clue.company}-">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control mydate" readonly id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
		    	<c:forEach items="${stage}" var="s">
					<option value="${s.id}">${s.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activityResorse">市场活动源&nbsp;&nbsp;<a  id="searchImgLogo" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
		    <input type="text" class="form-control" id="activityResorse" placeholder="点击上面搜索" readonly>
			  <input type="hidden" id="activityResorseHideBox" value="">
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" id="submitConvertBtn" type="button" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>