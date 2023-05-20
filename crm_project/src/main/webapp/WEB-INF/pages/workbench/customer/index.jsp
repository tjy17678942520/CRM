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
		sendAjax(1,10);
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		//日历插件
		dateTimepickerShow();

		//全选操作
		selectAll(false);
		//如每一个都选中 勾上全选按钮
		selectAll(true);

		//初始化新建表单
		alertCreateMadel();

		//创建
		buiderNewCustomer();

		//条件查询
		$("#search-condition-btn").click(function (){
			sendAjax(1,$("#mypagination").bs_pagination("getOption","rowsPerPage"));
		})

		//修改
		clickmodifyBtn();
	});

	//创建客户表单
	function buiderNewCustomer(){

		$("#create-save-btn").click(function () {

			//收集参数
			var owner          = $("#create-customerOwner").val();
			var customerName   = $.trim($("#create-customerName").val());
			var websize        = $.trim($('#create-website').val());
			var phone          = $.trim($("#create-phone").val());
			var contactSummary  = $.trim($("#create-contactSummary").val());
			var describe        = $.trim($("#create-describe").val());
			var nextContactTime = $.trim($("#create-nextContactTime").val());
			var address          = $.trim($("#create-address1").val());


			if(checkParameter(owner,customerName,websize,phone)){
				$.ajax({
					url:'workbench/customer/createCustomer.do',
					data:{
						owner           : owner          ,
						customerName    : customerName   ,
						websize         : websize        ,
						phone           : phone          ,
						contactSummary  : contactSummary ,
						describe        : describe       ,
						nextContactTime : nextContactTime,
						address         : address
					},
					dataType: 'json',
					type: 'post',
					success:function (res) {
						if (res.code == "1"){
							console.log(res);
							//请求成功分页查询
							sendAjax(1,$("#mypagination").bs_pagination('getOption','rowsPerPage'))
							//关闭模态窗口
							$("#createCustomerModal").modal("hide");
						}else {
							alert(res.msg);
						}
					}
				})
			}
		})

	}

	//点击创建按钮
	function alertCreateMadel(){
		$("#create-new-customer-btn").click(function () {
			//重置表单
			$("#create_form_data")[0].reset();
			$("#createCustomerModal").modal("show");
		})
	}


	//全选操作
	function selectAll(flag) {
		//第一种全部选上才勾选
		if (flag){
			$("#tbodySopeList").on("click",$("#tbodySopeList input[type='checkbox']"),function (){
				if ($("#tbodySopeList input[type='checkbox']:checked").size() == $("#tbodySopeList input[type='checkbox']").size()){
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
				$("#tbodySopeList input[type='checkbox']").prop("checked",this.checked);  })
		}



	}

	//修改
/*	function clickmodifyBtn(){
		$("#ModifyBtn").click(function () {
			$("#editCustomerModal").modal("show");
		})
	}*/
	//分页查询
	function sendAjax(beginNo,pageSize){
		//获取参数
		var owner = $("#search-customerOwner").val();
		var customerName = $.trim($("#search-customer-name").val());
		var phone = $.trim($("#search-phone").val());
		var websize = $("#search-website").val();

		console.log(websize);

		$.ajax({
			url:'workbench/customer/initData.do',
			data:{
				owner:owner,
				websize:websize,
				customerName:customerName,
				phone:phone,
				pageSize:pageSize,
				beginNo:beginNo
			},
			type:'post',
			dataType:'json',
			success:function (res) {
				var str = "";
				$.each(res.customerList,function (index,obj) {
					str += "<tr>";
					str +="<td><input type=\"checkbox\" id='"+obj.id+"' /></td>";
					str +="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/customer/detail';\">"+obj.name+"</a></td>";
					str +="<td>"+obj.owner+"</td>";
					str +="<td>"+obj.phone+"</td>";
					str +="<td>"+obj.website+"</td>";
					str += "</tr>";
				})
				$("#tbodySopeList").html(str);

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

	//检查参数
	function checkParameter(owner,fullname,website,phone) {
		if (owner == ""){
			alert("所有者不能为空！");
			$("#create-customerOwner").focus();
			return false;
		}
		if (fullname == "") {
			alert("名称不能为空！");
			$("#create-customerName").focus();
			return false;
		}


		//使用正则判断是否合法
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

		if (phone != "") {
			var regx_phone = /^(((\d{3,4}-)?[0-9]{7,8})|(1(3|4|5|6|7|8|9)\d{9}))$/;
			if (!regx_phone.test(phone)) {
				alert("座机号码不合法！");
				$('#create-phone').focus();
				return false;
			}
		}


		return true;
	}
</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="create_form_data" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
									<option></option>
									<c:forEach items="${users}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
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
                                    <input type="text" class="form-control  mydate" readonly id="create-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
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
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
									<c:forEach items="${users}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
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
                                <label for="create-nextContactTime2" class="col-sm-2 control-label ">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control mydate" id="create-nextContactTime2">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address">北京大兴大族企业湾</textarea>
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
				<h3>客户列表</h3>
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
				      <input class="form-control" id="search-customer-name" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
						<select class="form-control" id="search-customerOwner">
							<option></option>
							<c:forEach items="${users}" var="u">
								<option value="${u.id}">${u.name}</option>
							</c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" id="search-phone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="search-website" type="text">
				    </div>
				  </div>
				  
				  <button type="button" id="search-condition-btn" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="create-new-customer-btn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="ModifyBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input id="chckAll" type="checkbox" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="tbodySopeList">
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