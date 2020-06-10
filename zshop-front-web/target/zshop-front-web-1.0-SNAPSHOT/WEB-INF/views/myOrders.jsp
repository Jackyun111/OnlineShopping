<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>我的订单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/zshop.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap-paginator.js"></script>
    <script src="${pageContext.request.contextPath}/layer/layer.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zshop.css">

    <script>

        $(function(){

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

                    return "${pageContext.request.contextPath}/front/product/toOrders?pageNum=" + page;

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

            let orderId = $('#orderId').val();
            //alert(orderId);
            console.log(orderId);
            if(orderId != null){
                $.post(
                        '${pageContext.request.contextPath}/front/order/findOrderItem',
                        {"orderId":orderId},
                        function(result){

                        }
                );

               //location.href='${pageContext.request.contextPath}/front/order/findOrderItem'

            }

        });


        function delOrder(id){
            //alert(id);
            /*$.post(
                    }'
            );*/

        }


    </script>

</head>

<body>
<% request.setAttribute("index",2);%>
<div class="navbar navbar-default clear-bottom">
    <div class="container">

        <!-- navbar start -->

        <jsp:include page="top.jsp"/>
        <!-- navbar end -->
    </div>
</div>
<!-- content start -->
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <div class="page-header" style="margin-bottom: 0px;">
                <h3>我的订单</h3>
            </div>
        </div>
    </div>
    <table class="table table-hover   orderDetail">

        <c:forEach items="${data.list}" var="order">
        <tr>
            <td colspan="5">
                <span>【订单编号】：<a href="${pageContext.request.contextPath}/front/order/orderDetail?orderId=${order.id}&orderNo=${order.no}">${order.no}</a></span>
                <span>【成交时间】：${order.registDate}</span>

                <input type="hidden" value="${order.id}" id="orderId">
            </td>
        </tr>

        <tr>
            <td><img src="${pageContext.request.contextPath}/images/shop1.jpg" alt=""></td>
            <td class="order-content">
                <p>
                    ${items.num}
                </p>
                <p>颜色：单件粉色上衣</p>
                <p>尺码：s</p>
            </td>
            <td>
                ￥180.00
            </td>
            <td>
                2
            </td>
            <td class="text-color">
                ￥360.00
            </td>
        </tr>

        <tr>
            <td colspan="5">
                <span class="pull-right"><button class="btn btn-danger" onclick="delOrder(${order.id})">删除订单</button></span>
                <span class="">总计:<span class="text-color">￥450</span></span>
            </td>
        </tr>
        </c:forEach>
    </table>
    <%--使用bootstrap-paginator实现分页--%>
    <div class="text-center">
        <ul id="pagination"></ul>
    </div>
</div>
<!-- content end-->
<!-- footers start -->
<div class="footers">
    版权所有：中兴软件技术
</div>
<!-- footers end -->
</body>

</html>
