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

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//发送ajax请求 刷新界面
		sendAjax(1,10);

		//全选操作
		selectAll(false);

		//如每一个都选中 勾上全选按钮
		selectAll(true);

		//点击查询按钮 刷新ajax请求
		ConditionSearch();

		//日历插件
		dateTimepickerShow();

		//重置查询条件
		resetConditionSerach();

		//创建前初始化
		initCreateBefore();

		//点击保存
		createSavaInfo();

		//点击修改
		clickmodifyBtn();
	});

/*	function clickmodifyBtn(){
		$("#ModifyBtn").click(function () {
			$("#editContactsModal").modal("show");
			alert("aaa")
		})
	}*/

	//创建初始表单
	function initCreateBefore() {
		$("#createClueBtn").click(function () {
			//重置表单
			$("#create_form_data")[0].reset();
			$("#createContactsModal").modal("show");
		})
	}


	//创建保存
	function createSavaInfo() {
		$("#reate_save_btn").click(function () {
			var owner = $("#create-contactsOwner").val();
			var source = $("#create-clueSource").val();
			var fullname = $.trim($("#create-surname").val());
			var appellation	= $("#create-call").val();
			var job	= $("#create-job").val();
			var mphone	= $("#create-mphone").val();
			var email	= $("#create-email").val();
			var birthday	= $("#create-birth").val();
			var customerId	= $("#create-customerName").val();
			var description	= $.trim($("#create-describe").val());
			var contactSummary	= $.trim($("#create-contactSummary1").val());
			var nextContactTime	= $("#create-nextContactTime1").val();
			var address	= $.trim($("#create-address1").val());

			if (checkParameter(owner,fullname,email,mphone)) {
				$.ajax({
					url:'workbench/contacts/createContats.do',
					data:{
						owner:owner,
						source:source,
						fullname:fullname,
						appellation:appellation,
						job:job,
						mphone:mphone,
						email:email,
						birthday:birthday,
						customerId:customerId,
						description:description,
						contactSummary:contactSummary,
						nextContactTime:nextContactTime,
						address:address
					},
					type:'post',
					dataType: 'json',
					success:function (res) {
						if (res.code == "1"){
							sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'));
							$("#createContactsModal").modal("hide");
						}else {
							alert(res.msg);
							return;
						}
					}
				})
			}

		})






	}

	//判断参数合法性
	function checkParameter(owner,fullname,email,mphone) {
		if (owner == ""){
			alert("所有者不能为空！");
			$("#create-surname").focus();
			return false;
		}
		if (fullname == "") {
			alert("姓名不能为空！");
			$("#create-surname").focus();
			return false;
		}


		//使用正则判断是否合法
		if (email!=""){
			var regx = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if (!regx.test(email)){
				alert("邮箱格式不合法！");
				$("#create-email").focus();
				return false;
			}
		}


		if (mphone != ""){
			var myreg = /^1[3456789]\d{9}$/;

			if(mphone.length !=11){
				message = "请输入有效的手机号码！";
				alert(message);
				$("#create-mphone").focus();
				return false;
			}else if(!myreg.test(mphone)){
				message = "请输入有效的手机号码！";
				$("#create-mphone").focus();
				alert(message);
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

	//重置查询条件按钮
	function resetConditionSerach() {
		$("#resetConditionSearch").click(function () {

			var owner = $("#search-contactsOwner").val("");
			var fullname = $("#search_fullname").val("");
			var customerName = $("#searc_cus_name").val("");
			var source = $("#searc-clueSource").val("");
			var birthday = $("#searc-birthday").val("");

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

	//全选操作
	function selectAll(flag) {
		//第一种全部选上才勾选
		if (flag){
			$("#show_table_body_list").on("click",$("#show_table_body_list input[type='checkbox']"),function (){
				if ($("#show_table_body_list input[type='checkbox']:checked").size() == $("#show_table_body_list input[type='checkbox']").size()){
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
				$("#show_table_body_list input[type='checkbox']").prop("checked",this.checked);  })
		}



	}

	function sendAjax(beginNo,pageSize){
		//获取参数
		var owner = $("#search-contactsOwner").val();
		var fullname = $.trim($("#search_fullname").val());
		var customerName = $.trim($("#searc_cus_name").val());
		var source = $("#searc-clueSource").val();
		var birthday = $("#searc-birthday").val();

		$.ajax({
			url:'workbench/contacts/initData.do',
			data:{
				owner:owner,
				fullname:fullname,
				customerName:customerName,
				source:source,
				birthday:birthday,
				pageSize:pageSize,
				beginNo:beginNo
			},
			type:'post',
			dataType:'json',
			success:function (res) {
				var str = "";
				$.each(res.contacts,function (index,obj) {
					str += "<tr>";
					str += "<td><input id=\""+obj.id+"\" type=\"checkbox\" /></td>";
					str += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">"+obj.fullname+"</a></td>";
					str +=  "<td>"+obj.customerId+"</td>";
					str +=  "<td>"+obj.owner+"</td>";
					str +=  "<td>"+obj.source+"</td>";
					str +=  "<td>"+obj.birthday+"</td>";
					str +=  "</tr>";
				})
				$("#show_table_body_list").html(str);

				$("#chckAll").prop("checked",false);

				// 计算页数
				var totalPages = 1;
				if (res.count % pageSize == 0){
					totalPages = res.count / pageSize;
				}else {
					totalPages = parseInt(res.count / pageSize ) + 1;
				}
				//分页插件
				$("#mypagination").bs_pagination({
					currentPage: beginNo,
					rowsPerPage: pageSize, //每页条数
					totalPages: totalPages,//总页数
					totalRows: res.count,//总条数

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

	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="create_form_data" role="form">
					
						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-contactsOwner">
									<option></option>
									<c:forEach items="${users}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueSource">
									<option></option>
									<c:forEach items="${sourceList}" var="v">
										<option value="${v.id}">${v.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
								  <c:forEach items="${appellation}" var="a">
									  <option value="${a.id}">${a.value}</option>
								  </c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" readonly id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary1" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary1"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime1" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" readonly id="create-nextContactTime1">
								</div>
							</div>
						</div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="reate_save_btn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-contactsOwner">
									<option></option>
									<c:forEach items="${users}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-clueSource1" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueSource1">
								  <option></option>
									<c:forEach items="${sourceList}" var="v">
										<option value="${v.id}">${v.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
								  <option></option>
								  <c:forEach items="${appellation}" var="appellation">
									  <option value="${appellation.id}">${appellation.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label ">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control mydate" readonly id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建" value="动力节点">
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
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control mydate" readonly id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address2" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address2">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>联系人列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
						<select class="form-control" id="search-contactsOwner">
							<option></option>
							<c:forEach items="${users}" var="u">
								<option value="${u.id}">${u.name}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" id="search_fullname" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" id="searc_cus_name" type="text">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="searc-clueSource">
						  <option></option>
						  <c:forEach items="${sourceList}" var="s">
							  <option value="${s.id}">${s.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control mydate" id="searc-birthday" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="conditionSearch" class="btn btn-default">查询</button>
					<button type="button" id="resetConditionSearch" class="btn btn-default">重置</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createClueBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="ModifyBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="chckAll" type="checkbox" /></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<td>生日</td>
						</tr>
					</thead>
					<tbody id="show_table_body_list">

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