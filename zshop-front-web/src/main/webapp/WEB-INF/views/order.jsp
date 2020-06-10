<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>确认订单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>

    <script>

        //返回
        function back(){

            location.href='${pageContext.request.contextPath}/front/product/toCart';
        }

        //生成订单
        function generateOrder(){
            //alert(1);
            $.post(
                    '${pageContext.request.contextPath}/front/product/generateOrder',
                    {'customerId':'${sessionScope.customer.id}','price':'${sessionScope.orderCart.totalMoney}'},
                    function(result){

                        if(result.status==1){
                            $('#orderNo').html(result.message);
                            $('#buildOrder').modal('show');
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

        //生成订单成功，点击“确定”返回订单页面
        function toOrder(){
            location.href='${pageContext.request.contextPath}/front/product/showOrder';
        }


    </script>
</head>

<body>
<% request.setAttribute("index",1);%>
<div class="navbar navbar-default clear-bottom">
    <div class="container">
        <jsp:include page="top.jsp"/>
    </div>
</div>
<!-- content start -->
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <div class="page-header" style="margin-bottom: 0px;">
                <h3>已结算订单</h3>
            </div>
        </div>
    </div>
    <table class="table table-hover table-striped table-bordered">
        <tr>
            <th>序号</th>
            <th>商品名称</th>
            <th>商品图片</th>
            <th>商品数量</th>
            <th>商品单价</th>
            <th>商品总价</th>
        </tr>
        <c:forEach items="${sessionScope.orderCart.items}" var="cart" varStatus="s">
        <tr>
            <td>${s.count}</td>
            <td>${cart.product.name}</td>
            <td><img src="${pageContext.request.contextPath}/front/product/showPic?image=${cart.product.image}" alt="" width="40" height="40"></td>
            <td>${cart.quantity}</td>
            <td>￥${cart.product.price}</td>
            <td>￥${cart.itemMoney}</td>
        </tr>
        </c:forEach>
        <tr>
            <td colspan="6" class="foot-msg">
                总计：<b> <span>￥${sessionScope.orderCart.totalMoney}</span></b>元
                <a href="#">
                    <button class="btn btn-primary pull-right" type="button" onclick="back()">
                        <span class="glyphicon glyphicon-repeat" aria-hidden="true"></span>&nbsp;返回购物车</button>
                </a>
                <button class="btn btn-success pull-right margin-right-15" data-toggle="modal" data-target="#buildOrder" onclick="generateOrder()">
                    <span class="glyphicon glyphicon-yen" aria-hidden="true"></span>&nbsp;生成订单</button>
            </td>
        </tr>
    </table>
</div>
<!-- content end-->
<div class="modal fade" id="buildOrder" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">提示消息</h4>
            </div>
            <div class="orderMsg">
                <p>
                    订单生成成功！！
                </p>
                <p>
                    订单号：<span id="orderNo">12345679</span>
                </p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="toOrder()">确定</button>
            </div>

        </div>
    </div>
</div>
<!-- footers start -->
<div class="footers">
    版权所有：中兴软件技术
</div>
<!-- footers end -->
</body>

</html>
