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
		$(function (){
			//查找市场活动 初始化数据
			searhAcitiy();

			//搜索框键盘弹起泛起请求模糊查询
			searchActivityEvenKeyUp();

			//点击单选按钮 回填数据
			checkedActivityResoure();

			//点击查询联系人 相关
			searchContacts();

			//收集参数创建

		})
		function searchContacts() {
			$("#searchContactsSearchLogo").click(function () {

				$.ajax({
					url:'workbench/contacts/queryAllContats.do',
					type:'post',
					dataType:'json',
					success:function (res) {
						var s = "";
						//回写数据到关联市场活动
						$.each(res,function (index,obj) {
							s+="<tr>"
							s+="<td><input type='radio' value=\""+obj.id+"\"  name=\""+obj.fullname+"\"/></td>";
							s+="<td>"+obj.fullname+"</td>";
							s+="<td>"+obj.email+"</td>";
							s+="<td>"+obj.mphone+"</td>";
							s+="</tr>";
						})
						$("#searchContactsShowList").html(s);
						$("#findContacts").modal("show");
					}

				})

				$("#searchContactsShowList").on("click",$("#searchContactsShowList input[type='radio']"),function () {
					//市场活动id
					var contactsId = $("#searchContactsShowList input[type='radio']:checked").val();
					//市场活动名字
					var contactsName = $("#searchContactsShowList input[type='radio']:checked").attr('name');

					//写入所拿到的数据
					$("#create-contactsName-id").val(contactsId);

					$("#create-contactsName").val(contactsName);

					$("#findContacts").modal("hide");
				})

				//动态搜索
				$("#findContactsInput").keyup(function () {

					var ContactsName = $("#findContactsInput").val();
					$.ajax({
						url:'workbench/contacts/queryContatsByName.do',
						data: {
							ContactsName:ContactsName
						},
						dataType:'json',
						type:'post',
						success:function (res) {
							var s = "";
							$.each(res,function () {
								//回写数据到关联市场活动
								$.each(res,function (index,obj) {
									s+="<tr>"
									s+="<td><input type='radio' value=\""+obj.id+"\"  name=\""+obj.fullname+"\"/></td>";
									s+="<td>"+obj.fullname+"</td>";
									s+="<td>"+obj.email+"</td>";
									s+="<td>"+obj.mphone+"</td>";
									s+="</tr>";
								})
								$("#searchContactsShowList").html(s);
								$("#findContacts").modal("show");
							})
						}

					})

				})
			})
		}

		function checkedActivityResoure() {
			$("#searchActivityShowList").on("click",$("#searchActivityShowList input[type='radio']"),function () {
				//市场活动id
				var activityId = $("#searchActivityShowList input[type='radio']:checked").val();
				//市场活动名字
				var activityName = $("#searchActivityShowList input[type='radio']:checked").attr('name');

				$("#activityResorseHideBox").val(activityId);

				$("#create-activitySrc").val(activityName);

				$("#findMarketActivity").modal("hide");
			})
		}
		
		function searchActivityEvenKeyUp() {
			$("#searchActivityInput").keyup(function () {
				var activityName = $("#searchActivityInput").val();
				$.ajax({
					url: 'workbench/activity/queryAtivtysByLikeName.do',
					data: {
						activityName: activityName
					},
					type: 'post',
					dataType: 'json',
					success: function (res) {
						var s = "";
						//回写数据到关联市场活动
						$.each(res,function (index,obj) {
							s+="<tr>"
							s+="<td><input type='radio' value=\""+obj.id+"\"  name=\""+obj.name+"\"/></td>";
							s+="<td>"+obj.name+"</td>";
							s+="<td>"+obj.startDate+"</td>";
							s+="<td>"+obj.endDate+"</td>";
							s+="<td>"+obj.owner+"</td>";
							s+="</tr>";
						})
						$("#searchActivityShowList").html(s);
					}
				})
			})
		}

		function searhAcitiy() {
			$("#searchAtivityLogo").click(function () {

				//查询市场活动信息
				$.ajax({
					url:'workbench/transaction/queryAllActivity.do',
					type:'post',
					dataType:'json',
					success:function (res) {
						var s = "";
						//回写数据到关联市场活动
						$.each(res,function (index,obj) {
							s+="<tr>"
							s+="<td><input type='radio' value=\""+obj.id+"\"  name=\""+obj.name+"\"/></td>";
							s+="<td>"+obj.name+"</td>";
							s+="<td>"+obj.startDate+"</td>";
							s+="<td>"+obj.endDate+"</td>";
							s+="</tr>";
						})
						$("#searchActivityShowList").html(s);
						$("#findMarketActivity").modal("show");
					}

				})
			})
		}
	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="searchActivityInput" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="searchActivityShowList">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="findContactsInput" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="searchContactsShowList">


						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
					<option></option>
				 <c:forEach items="${users}" var="users">
					 <option value="${users.id}">${users.name}</option>
				 </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
			  	<c:forEach items="${stage}" var="stage">
					<option value="${stage.id}">${stage.value}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionType}" var="transactionType">
						<option value="${transactionType.id}">${transactionType.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${source}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchAtivityLogo"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="activityResorseHideBox" value="">
				<input type="text" class="form-control" id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactsSearchLogo" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsName-id">
				<input type="text" class="form-control" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>