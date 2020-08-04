<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>博客类别管理页面</title>
	
	<!-- 导入jquery的js和css资源 -->
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/icon.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
	
	<!-- 自定义js函数 -->
	<script type="text/javascript">
		var url;
		/**弹出添加博客类别信息对话框*/
		function openBlogTypeAddDialog(){
			$("#dlg").dialog("open").dialog("setTitle","添加博客类别信息");
			url="${pageContext.request.contextPath}/admin/blogType/save.do";
		}
		
		/**弹出修改博客类别信息对话框*/
		function openBlogTypeModifyDialog(){
			var selectedRows=$("#dg").datagrid("getSelections");
			if(selectedRows.length!=1){
				$.messager.alert("系统提示","请选择一条要编辑的数据！");
				return;
			}
			var row = selectedRows[0];		
			$("#dlg").dialog("open").dialog("setTitle","编辑博客类别信息");
			$("#fm").form("load",row);
			url="${pageContext.request.contextPath}/admin/blogType/save.do?id="+row.id;
		}
	
		/**保存博客类别信息*/
		function saveBlogType(){
			$("#fm").form("submit",{
				url:url,
				onSubmit:function(){	//点击事件进行验证
					return $(this).form("validate");
				},
				success:function(result){	//判断保存结果
					var result=eval('('+result+')');
					if(result.success){
						$.messager.alert("系统提示","保存成功！");
						resetValue();
						//关闭对话框
						$("#dlg").dialog("close");
						//刷新查询结果
						$("#dg").datagrid("reload");
					}else{
						$.messager.alert("系统提示","保存失败！");
						return;
					}
				}
			});
		}
		
		/**重置弹出的对话框*/
		function resetValue(){
			$("#typeName").val("");
			$("#orderNo").val("");
		}
	
	
		/**关闭对话框*/
		function closeBlogTypeDialog(){
			$("#dlg").dialog("close");
			resetValue();
		}
		
		/**删除博客类别信息*/
		function deleteBlogType(){
			var selectedRows=$("#dg").datagrid("getSelections");
			if(selectedRows.length==0){
				$.messager.alert("系统提示","请至少选择一条要删除的数据！");
				return;
			}
			//选择的类型id放入数组
			var strIds=[];
			for(var i=0;i<selectedRows.length;i++){
				strIds.push(selectedRows[i].id);
			}
			var ids=strIds.join(",");	//拼接
			// 删除确认提示
			$.messager.confirm("系统提示","您确定要删除这<font color=red>"+selectedRows.length+"</font>条数据吗？",function(r){
				if(r){	//点击确定
					$.post("${pageContext.request.contextPath}/admin/blogType/delete.do",{ids:ids},function(result){
						if(result.success){	//调用删除成功
							if(result.exist){	// 要删除类型下有博客存在，不能直接删除
								$.messager.alert("系统提示",result.exist);
							}else{
								$.messager.alert("系统提示","数据已成功删除！");
							}
							$("#dg").datagrid("reload");	//刷新类型表格数据
						}else{
							$.messager.alert("系统提示","数据删除失败！");
						}
					},"json");
				}
			});
		}
	</script>
</head>

<body style="margin: 1px">
	<!-- 显示博客类型表 -->
	<table id="dg" title="博客类别管理" class="easyui-datagrid" fitcolumns="true" pagination="true" rownumbers="true"
		url="${pageContext.request.contextPath}/admin/blogType/list.do" fit="true" toolbar="#tb">
		<thead>
			<tr>
				<th field="cb" checkbox="true" align="center"></th>
				<th field="id" width="20" align="center">编号</th>
				<th field="typeName" width="100" align="center">博客类型名称</th>
				<th field="orderNo" width="100" align="center">排序序号</th>		
			</tr>
		</thead>
	</table>
	
	<!-- 顶部添加、修改、删除按钮 -->
	<div id="tb">
		<a href="javascript:openBlogTypeAddDialog()" class="easyui-linkbutton" iconCls="icon-add" plain="true">添加</a>
		<a href="javascript:openBlogTypeModifyDialog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
		<a href="javascript:deleteBlogType()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
	</div>
	
	<!-- 添加功能弹出的对话框 -->
	<div id="dlg" class="easyui-dialog" style="width:500px;height:180px;padding: 10px 20px"
		closed="true" buttons="#dlg-buttons">
		<form id="fm" method="post">
			<table cellspacing="8px">
				<tr>
					<td>博客类别名称:</td>
					<td><input type="text" id="typeName" name="typeName" class="easyui-validatebox" required="true"/></td>
				</tr>
				<tr>
					<td>博客类别排序:</td>
					<td><input type="text" id="orderNo" name="orderNo" class="easyui-validatebox" required="true" style="width:60px;"/>（类别根据排序序号从小到大排序）</td>
				</tr>
			</table>
		</form>
	</div>
	<div id="dlg-buttons">
		<a href="javascript:saveBlogType()" class="easyui-linkbutton" iconCls="icon-ok">保存</a>
		<a href="javascript:closeBlogTypeDialog()" class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>
</body>
</html>