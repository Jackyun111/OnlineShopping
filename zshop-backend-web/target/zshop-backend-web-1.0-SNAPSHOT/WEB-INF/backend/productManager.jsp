<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>backend</title>
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/index.css" />
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/file.css" />
    <script src="${pageContext.request.contextPath}/js/jquery.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/userSetting.js"></script>
    <script src="${pageContext.request.contextPath}/layer/layer.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zshop.css">
    <script src="${pageContext.request.contextPath}/js/bootstrapValidator.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrapValidator.min.css"/>
    <script src="${pageContext.request.contextPath}/js/bootstrap-paginator.js"></script>
    <script>
        $(function(){
            //上传图像预览
            $('#product-image').on('change',function() {
                $('#img').attr('src', window.URL.createObjectURL(this.files[0]));
            });
            $('#pro-image').on('change',function() {
                $('#img2').attr('src', window.URL.createObjectURL(this.files[0]));
            });

            //服务器校验
            let successMsg="${successMsg}";
            let errorMsg="${errorMsg}";
            //console.log(successMsg+"a1")
            if(successMsg != ''){
                layer.msg(
                        successMsg, {
                    time:2000,
                    skin:"successMsg"
                });
            }
            if(errorMsg != ''){
                layer.msg(
                        errorMsg, {
                            time:2000,
                            skin:"errorMsg"
                        });
            }

            //使用bootatrap_validator插件进行客户端数据校验
            $('#frmAddProduct').bootstrapValidator(
                    {
                        feedbackIcons: {
                            valid: 'glyphicon glyphicon-ok',//成功后输出的图标
                            invalid: 'glyphicon glyphicon-remove',//失败后输出的图标
                            validating: 'glyphicon glyphicon-refresh'//长时间加载时输出的图标
                        },
                        fields:{
                            name: {
                                validators: {
                                    notEmpty: {
                                        message: '商品名称不能为空'
                                    },
                                    remote:{
                                        url:"${pageContext.request.contextPath}/backend/product/checkName"
                                    }
                                }
                            },
                            price:{
                                validators: {
                                    notEmpty: {
                                        message: '商品价格不能为空'
                                    },
                                    regexp:{
                                        regexp:/^[1-9]\d*\,\d*|[1-9]\d*$/,
                                        message:"请按正确格式输入价格"
                                    }
                                }
                            },
                            amount:{
                                validators: {
                                    notEmpty: {
                                        message: '请输入商品库存量'
                                    },
                                    regexp:{
                                        regexp:/^[1-9]\d*$/,
                                        message:"请按正确格式输入数量"
                                    }
                                }
                            },
                            file:{
                                validators: {
                                    notEmpty: {
                                        message: '请选择需要上传的图片'
                                    }
                                }
                            },
                            productTypeId:{
                                validators: {
                                    notEmpty: {
                                        message: '请选择商品类型'
                                    }
                                }
                            },
                            info:{
                                validators: {
                                    notEmpty: {
                                        message: '请输入商品信息'
                                    }
                                }
                            }
                        }
                    }
            );

            //修改商品界面校验
            //使用bootatrap_validator插件进行客户端数据校验
            $('#frmModifyProduct').bootstrapValidator(
                    {
                        feedbackIcons: {
                            valid: 'glyphicon glyphicon-ok',//成功后输出的图标
                            invalid: 'glyphicon glyphicon-remove',//失败后输出的图标
                            validating: 'glyphicon glyphicon-refresh'//长时间加载时输出的图标
                        },
                        fields:{
                            name: {
                                validators: {
                                    notEmpty: {
                                        message: '商品名称不能为空'
                                    },
                                    remote:{
                                        url:"${pageContext.request.contextPath}/backend/product/checkName"
                                    }
                                }
                            },
                            price:{
                                validators: {
                                    notEmpty: {
                                        message: '商品价格不能为空'
                                    },
                                    regexp:{
                                        regexp:/^[1-9]\d*\,\d*|[1-9]\d*$/,
                                        message:"请按正确格式输入"
                                    }
                                }
                            },
                            amount:{
                                validators: {
                                    notEmpty: {
                                        message: '请输入商品库存量'
                                    },
                                    regexp:{
                                        regexp:/^[1-9]\d*$/,
                                        message:"请按正确格式输入数量"
                                    }
                                }
                            },
                            productTypeId:{
                                validators: {
                                    notEmpty: {
                                        message: '请选择商品类型'
                                    }
                                }
                            },
                            info:{
                                validators: {
                                    notEmpty: {
                                        message: '请输入商品信息'
                                    }
                                }
                            }
                        }
                    }
            );


            //分页
            $('#pagination').bootstrapPaginator({
                //主版本号
                bootstrapMajorVersion: 3,

                //当前页
                currentPage:${data.pageNum},
                //总页数
                totalPages:${data.pages},
                //url
                pageUrl: function (type, page, current) {

                    return "${pageContext.request.contextPath}/backend/product/findAll?pageNum=" + page;

                },
                //面板文字
                //type：类型
                //page:当前页
                itemTexts: function (type, page, current) {
                    switch (type) {
                        case "first":
                            return "首页";
                        case "prev":
                            return "上一页";
                        case "next":
                            return "下一页";
                        case "last":
                            return "尾页";
                        case "page":
                            return page;
                    }
                }


            });
        });

        //显示修改商品页面
        function showProduct(id){
            //alert(id);
            $.post(
                    '${pageContext.request.contextPath}/backend/product/findById',{'id':id},function(result){

                        //console.log(result);
                        if(result.status == 1){
                            $('#pro-num').val(result.data.id);
                            $('#pro-name').val(result.data.name);
                            $('#pro-price').val(result.data.price);
                            $('#pro-typeId').val(result.data.productType.id);
                            $('#pro-amount').val(result.data.amount);
                            $('#product_info').val(result.data.info);
                            $('#img2').attr('src','${pageContext.request.contextPath}/backend/product/showPic?image='+result.data.image);
                        }
                    }
            );
        }

        //显示删除弹框
        function showDelModel(id){

            //alert(id);
            $('#productId').val(id);
            $('#delProduct').modal("show");
        }
        //删除商品
        function delProduct(){

            let id=$('#productId').val();
            //alert(id);
            $.post(
                 "${pageContext.request.contextPath}/backend/product/deleteById",
                    {"id":id},
                    function(result){
                        //console.log(result);
                        if(result.status == 1){
                            layer.msg(
                                    result.message,
                                    {
                                        time:1000,
                                        skin:'successMsg'
                                    },
                                    function(){
                                        location.href='${pageContext.request.contextPath}/backend/product/findAll?pageNum='+${data.pageNum};
                                    }
                            );
                        }
                        else{
                            layer.msg(
                                    result.message,
                                    {
                                        time:1000,
                                        skin:'errorMsg'
                                    }
                            );
                        }
                    }
            );
        }


        //修改商品状态
        function modifyStatus(id,btn){
            //alert(id);

            $.post(
                    '${pageContext.request.contextPath}/backend/product/modifyStatus',
                    {"id":id},
                    function(result){
                        let $td=$(btn).parent().prev();
                        if($td.text().trim()=='启用'){
                            $td.text('禁用');
                            $(btn).val('启用').removeClass("btn-danger").addClass("btn-success");
                        }
                        else{
                            $td.text('启用');
                            $(btn).val('禁用').removeClass("btn-success").addClass("btn-danger");
                        }
                    }
            );
        }



    </script>
</head>

<body>
<div class="panel panel-default" id="userPic">
    <div class="panel-heading">
        <h3 class="panel-title">商品管理</h3>
    </div>
    <div class="panel-body">
        <input type="button" value="添加商品" class="btn btn-primary" id="doAddPro">
        <br>
        <br>
        <div class="show-list text-center">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">编号</th>
                    <th class="text-center">商品</th>
                    <th class="text-center">图片</th>
                    <th class="text-center">价格</th>
                    <th class="text-center">库存量</th>
                    <th class="text-center">产品类型</th>
                    <th class="text-center">产品信息</th>
                    <th class="text-center">状态</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <c:forEach items="${data.list}" var="product">
                    <tr>
                        <td>${product.id}</td>
                        <td>《${product.name}》</td>
                        <td><img src="${pageContext.request.contextPath}/backend/product/showPic?image=${product.image}" alt="" width="40" height="40"></td>
                        <td>￥${product.price}</td>
                        <td>${product.amount}件</td>
                        <td>${product.productType.name}</td>
                        <td>
                            <textarea class="form-control" rows="1">&nbsp;&nbsp;&nbsp;${product.info}
                            </textarea>
                        </td>
                        <td>
                            <c:if test="${product.status==1}">启用</c:if>
                            <c:if test="${product.status==0}">禁用</c:if>
                        </td>
                        <td class="text-center">
                            <input type="button" class="btn btn-primary btn-sm doProModify" onclick="showProduct(${product.id})" value="修改">
                            <input type="button" class="btn btn-danger btn-sm doProDelete" onclick="showDelModel(${product.id})" value="删除">

                            <c:if test="${product.status==1}">
                                <input type="button" class="btn btn-danger btn-sm " value="禁用" onclick="modifyStatus(${product.id},this)">
                            </c:if>
                            <c:if test="${product.status==0}">
                                <input type="button" class="btn btn-success btn-sm " value="启用" onclick="modifyStatus(${product.id},this)">
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </table>
            <%--使用bootstrap-paginator实现分页--%>
            <ul id="pagination"></ul>
        </div>
    </div>
</div>

<!-- 添加商品 start -->
<div class="modal fade" tabindex="-1" id="Product">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <form action="${pageContext.request.contextPath}/backend/product/add" class="form-horizontal" enctype="multipart/form-data" method="post" id="frmAddProduct">

            <input type="hidden" name="pageNum" value="${data.pageNum}">
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">添加商品</h4>
                </div>
                <div class="modal-body text-center row">
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label for="product-name" class="col-sm-4 control-label">商品名称：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="product-name" name="name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-price" class="col-sm-4 control-label">商品价格：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="product-price" name="price">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-price" class="col-sm-4 control-label">库存量：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="product-amount" name="amount">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-image" class="col-sm-4 control-label">商品图片：</label>
                            <div class="col-sm-8">
                                <a href="javascript:;" class="file">选择文件
                                    <input type="file" name="file" id="product-image">
                                </a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-type" class="col-sm-4 control-label">商品类型：</label>
                            <div class="col-sm-8">
                                <select class="form-control" name="productTypeId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${productTypes}" var="productType">
                                        <option value="${productType.id}">${productType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-price" class="col-sm-4 control-label">产品信息：</label>
                            <div class="col-sm-8">
                                <textarea class="form-control" id="product-info" name="info" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <!-- 显示图像预览 -->
                        <img style="width: 180px;height: 220px;margin-top: 25px;" id="img">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary" type="submit">添加</button>
                    <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- 添加商品 end -->

<!-- 修改商品 start -->
<div class="modal fade" tabindex="-1" id="myProduct">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <form action="${pageContext.request.contextPath}/backend/product/modify" enctype="multipart/form-data" method="post" class="form-horizontal" id="frmModifyProduct">

            <input type="hidden" name="pageNum" value="${data.pageNum}">
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">修改商品</h4>
                </div>
                <div class="modal-body text-center row">
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label for="pro-num" class="col-sm-4 control-label">商品编号：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-num" name="id" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-name" class="col-sm-4 control-label">商品名称：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-name" name="name">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">商品价格：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-price" name="price">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">库存量：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-amount" name="amount">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-image" class="col-sm-4 control-label">商品图片：</label>
                            <div class="col-sm-8">
                                <a class="file">
                                    选择文件 <input type="file" name="file" id="pro-image">
                                </a>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-type" class="col-sm-4 control-label">商品类型：</label>
                            <div class="col-sm-8">
                                <select class="form-control" name="productTypeId" id="pro-typeId">
                                    <option value="">请选择</option>
                                    <c:forEach items="${productTypes}" var="productType">
                                        <option value="${productType.id}">${productType.name}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-price" class="col-sm-4 control-label">产品信息：</label>
                            <div class="col-sm-8">
                                <textarea class="form-control" id="product_info" name="info" rows="2"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <!-- 显示图像预览 -->
                        <img style="width: 180px;height: 220px;margin-top: 25px;" id="img2">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary updatePro" type="submit">修改</button>
                    <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- 修改商品 end -->

<!-- 删除提示框 start -->
<div class="modal fade" tabindex="-1" id="delProduct">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-sm">
        <!-- 内容声明 -->
        <div class="modal-content">
            <!-- 头部、主体、脚注 -->
            <div class="modal-header">
                <button class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">消息提示</h4>
            </div>
            <div class="modal-body text-center">
                <h4>确认要删除该商品吗？</h4>
                <input type="hidden" id="productId">
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary updateProType" onclick="delProduct()" data-dismiss="modal">删除</button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<!-- 删除提示框 end -->
</body>

</html>
