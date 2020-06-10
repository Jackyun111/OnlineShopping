<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>在线购物商城</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet"  href="${pageContext.request.contextPath}/css/file.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/iconfont/iconfont.css">
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/zshop.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap-paginator.js"></script>
    <script src="${pageContext.request.contextPath}/layer/layer.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zshop.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.spinner.css" />
    <%--<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.spinner.js"></script>
--%>

    <script>

        $(function(){

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

            //分页
            $('#pagination').bootstrapPaginator({
                //主版本号
                bootstrapMajorVersion: 3,
                //当前页
                currentPage:${data.pageNum},
                //总页数
                totalPages:${data.pages},
                //url
                /*pageUrl: function (type, page, current) {

                 return "${pageContext.request.contextPath}/front/product/main?pageNum=" + page;

                 },*/
                onPageClicked:function(event,originalEvent,type,page){

                    $('#pageNum').val(page);
                    $('#frmDoQuery').submit();

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

            //商品数量改变时，单个商品总价改变函数
            $('#quantitySelect').change(function(){

                let num = $(this).children('option:selected').val();

                let money = $('#pro-price').text();
                money=money.substr(1,money.length);

                let itemMoney = parseInt(num)*parseInt(money);
               // alert(itemMoney);
                $('#itemMoney').html('￥'+itemMoney+'.0');

            });

        });

        //添加购物车功能
        function addToCart(id){

            //alert(id);
            $.post(
                    '${pageContext.request.contextPath}/front/product/addToCart',
                    {"id":id},
                    function(result){
                        if(result.status == 1){
                            layer.msg(
                                    result.message,
                                    {
                                        time:1000,
                                        skin:'successMsg'
                                    }
                            );
                        }else{
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

        //商品详情页面
        function productDetile(productId,btn){
            //alert(1);
            //location.href='${pageContext.request.contextPath}/front/product/toDetail';
            //alert(productId);

            $.post(
                    '${pageContext.request.contextPath}/front/product/findById',{'id':productId},function(result){

                        //console.log(result);
                        if(result.status == 1){
                            $('#pro-name').text(result.data.name);
                            $('#pro-price').text('￥'+result.data.price);
                            $('#pro-typeName').text(result.data.productType.name);
                            $('#itemMoney').text('￥'+result.data.price);
                            $('#pro-info').text(result.data.info);
                            $('#pro-amount').text(result.data.amount+' 件');
                            $('#img2').attr('src','${pageContext.request.contextPath}/front/product/showPic?image='+result.data.image);
                        }
                    }
            );
            $('#productId').val(productId);
            $('#productDetail').modal('show');

        }

        //添加到购物车
        function addProductsToCart(){

            //alert(1);
            //alert($('#productId').val());
            //alert($('#quantitySelect').val());
            //获得选择商品ID和购买数量
            let productId = $('#productId').val();
            let productQuantity = $('#quantitySelect').val();

            $.post(
                    '${pageContext.request.contextPath}/front/product/addProductsToCart',
                    {"id":productId,"quantity":productQuantity},
                    function(result){
                        if(result.status == 1){
                            layer.msg(
                                    result.message,
                                    {
                                        time:1000,
                                        skin:'successMsg'
                                    },
                                    function(){
                                        $('#productDetail').modal('hide');
                                    }
                            );
                        }else{
                            layer.msg(
                                    result.message,
                                    {
                                        time:1000,
                                        skin:'errorMsg'
                                    },
                                    function(){
                                        $('#productDetail').modal('hide');
                                    }
                            );
                        }
                    }
            );
        }


        function mindSignIn(){

            //alert(1);
            layer.msg(
                    '请先登录账户',
                    {
                        time:2000,
                        skin:'errorMsg'
                    }
            );
        }


        function mindSignIn2(){

            //alert(1);
            layer.msg(
                    '请先登录账户',
                    {
                        time:2000,
                        skin:'errorMsg'
                    },
                    function(){
                        $('#productDetail').modal('hide');
                    }
            );
        }





    </script>

</head>

<body>
<% request.setAttribute("index",0);%>
<div id="wrapper">
    <!-- navbar start -->

    <jsp:include page="top.jsp"/>
    <!-- navbar end -->
    <!-- content start -->
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <div class="page-header" style="margin-bottom: 0px;">
                    <h3>商品列表</h3>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <div class="row">
            <div class="col-xs-12">
                <form class="form-inline hot-search" action="${pageContext.request.contextPath}/front/product/main" method="post" id="frmDoQuery">

                    <input type="hidden" id="pageNum" name="pageNum" value="${data.pageNum}">
                    <div class="form-group">
                        <label class="control-label">商品：</label>
                        <input type="text" class="form-control" name="name" value="${productParam.name}" placeholder="商品名称">
                    </div>
                    &nbsp;
                    <div class="form-group">
                        <label class="control-label">价格：</label>
                        <input type="text" class="form-control" name="minPrice" value="${productParam.minPrice}" placeholder="最低价格"> --
                        <input type="text" class="form-control" name="maxPrice" value="${productParam.maxPrice}" placeholder="最高价格">
                    </div>
                    &nbsp;
                    <div class="form-group">
                        <label class="control-label">种类：</label>
                        <select class="form-control input-sm" name="productTypeId">
                            <option value="-1" selected="selected">查询全部</option>
                            <c:forEach items="${productTypes}" var="productType">
                             <option value="${productType.id}" <c:if test="${productType.id==productParam.productTypeId}">selected</c:if> >${productType.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    &nbsp;
                    <div class="form-group">
                        <button type="submit" class="btn btn-warning">
                            <i class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <div class="content-back">
        <div class="container text-center" id="a">
            <div class="row">
                <c:forEach items="${data.list}" var="product">
                <div class="col-xs-3  hot-item">
                    <div class="panel clear-panel">
                        <div class="panel-body">
                            <div class="art-back clear-back">
                                <div class="add-padding-bottom" onclick="productDetile(${product.id},this)">
                                    <img src="${pageContext.request.contextPath}/front/product/showPic?image=${product.image}" class="shopImg">
                                </div>
                                <h4><a href="">${product.name}</a></h4>
                                <div class="user clearfix pull-right">
                                    ￥${product.price}
                                </div>
                                <div class="desc">
                                    ${fn:substring(product.info, 0, 20)}
                                </div>
                                <c:choose>

                                    <c:when test="${empty customer}">
                                        <div class="attention pull-right" onclick="mindSignIn()">
                                            加入购物车 <i class="icon iconfont icon-gouwuche"></i>
                                        </div>

                                    </c:when>
                                    <c:otherwise>

                                        <div class="attention pull-right" onclick="addToCart(${product.id})">
                                            加入购物车 <i class="icon iconfont icon-gouwuche"></i>
                                        </div>

                                    </c:otherwise>

                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                </c:forEach>


            </div>
            <%--使用bootstrap-paginator实现分页--%>
            <ul id="pagination"></ul>
        </div>
    </div>
    <!-- content end-->

    <!-- footers end -->
</div>

<!-- 商品详情 start -->
<div class="modal fade" tabindex="-1" id="productDetail">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <form action="" enctype="multipart/form-data" method="post" class="form-horizontal" id="frmModifyProduct">

            <input type="hidden" name="pageNum" value="${data.pageNum}">
            <input type="hidden" id="productId" value="">
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">商品详情</h4>
                </div>
                <div class="modal-body text-center row">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <!-- 显示图像预览 -->
                            <img style="width: 170px;height: 190px;" id="img2">
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-5 control-label">购买数量：</label>
                            <div class="col-sm-4">
                                <select class="form-control" value="" id="quantitySelect">
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-5 control-label">总价：</label>
                            <div class="col-sm-4">
                                <p style="margin-top: 6px;" id="itemMoney">￥120元</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label for="pro-name" class="col-sm-4 control-label">商品名称：</label>
                            <div class="col-sm-7">
                                <p style="margin-top: 6px;" id="pro-name">使命召唤</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">商品价格：</label>
                            <div class="col-sm-7">
                                <p style="margin-top: 6px;" id="pro-price">￥120元</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="product-type" class="col-sm-4 control-label">商品类型：</label>
                            <div class="col-sm-7">
                                <p style="margin-top: 6px;" id="pro-typeName">游戏：第一人称射击类</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-info" class="col-sm-4 control-label">详情简介：</label>
                            <div class="col-sm-7" >
                                <textarea class="form-control" style="min-width: 90%;" rows="3" id="pro-info">
                                </textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">发货期：</label>
                            <div class="col-sm-7">
                                <p style="margin-top: 6px;">7天发货/无理由退换货</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">剩余库存：</label>
                            <div class="col-sm-7">
                                <p style="margin-top: 6px;" id="pro-amount"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">

                    <c:choose>
                        <c:when test="${empty customer}">
                            <button class="btn btn-success" type="button" onclick="mindSignIn2()">
                                <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>&nbsp;&nbsp;加入购物车</button>

                        </c:when>
                        <c:otherwise>
                    <button class="btn btn-success" type="button" onclick="addProductsToCart()">
                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>&nbsp;&nbsp;加入购物车</button>
                        </c:otherwise>

                    </c:choose>
                    <button class="btn btn-danger cancel" data-dismiss="modal">
                        <span class="glyphicon glyphicon-sunglasses" aria-hidden="true"></span>&nbsp;&nbsp;我再看看</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- 商品详情 end -->


</body>

</html>
