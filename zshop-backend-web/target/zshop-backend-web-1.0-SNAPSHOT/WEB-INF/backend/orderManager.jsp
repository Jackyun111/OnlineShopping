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

                    return "${pageContext.request.contextPath}/backend/order/findAll?pageNum=" + page;

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


        //显示删除订单提示框
        function delOrder(orderId){

            //alert(orderId);
            $('#orderId').val(orderId);
            $('#delOrderModel').modal('show');
        }

        //删除订单
        function deleteOrder(){

            let id = $('#orderId').val();
            //alert(id);
            $.post(
                    '${pageContext.request.contextPath}/backend/order/deleOrder',
                    {"id":id},
                    function(result){
                        if(result.status==1){
                            layer.msg(
                                    result.message,
                                    {
                                        time:2000,
                                        skin:'successMsg'
                                    },
                                    function(){
                                        location.href='${pageContext.request.contextPath}/backend/order/findAll?pageNum='+${data.pageNum};
                                    }
                            );
                        }else{
                            layer.msg(
                                    result.message,
                                    {
                                        time:2000,
                                        skin:'errorMsg'
                                    }
                            );
                        }
                    }
            );
        }

        //订单详情
        function detailOrder(orderId){

            //alert(orderId);
            $.post(
                    '${pageContext.request.contextPath}/backend/order/detailOrder',
                    {"id":orderId},
                    function(result){
                        //console.log(result);
                        $('#order-num').val(result.data.id);
                        $('#order-no').val(result.data.no);
                        $('#order-time').val(result.data.registDate);
                        $('#pro-price').val(result.data.price);
                        $('#pro-person').val(result.data.customer.name);

                    }
            );
            $('#orderDetail').modal('show');

        }


    </script>
</head>

<body>
<div class="panel panel-default" id="userPic">
    <div class="panel-heading">
        <h3 class="panel-title">订单管理</h3>
    </div>
    <div class="panel-body">
        <br>
        <div class="show-list text-center">
            <table class="table table-bordered table-hover" style='text-align: center;'>
                <thead>
                <tr class="text-danger">
                    <th class="text-center">订单序号</th>
                    <th class="text-center">订单号</th>
                    <th class="text-center">下单日期</th>
                    <th class="text-center">订单状态</th>
                    <th class="text-center">操作</th>
                </tr>
                </thead>
                <tbody id="tb">
                <c:forEach items="${data.list}" var="order" varStatus="s">
                <tr>
                    <td>${order.id}</td>
                    <td>${order.no}</td>
                    <td>${order.registDate}</td>
                    <td>
                        <c:if test="${order.status==1}">已发货</c:if>
                        <c:if test="${order.status==0}">未发货</c:if>
                    </td>
                    <td class="text-center">
                        <button class="btn btn-primary" type="button" onclick="detailOrder(${order.id})">
                            <span class="glyphicon glyphicon-erase" aria-hidden="true"></span>详情</button>
                        <button class="btn btn-success" type="button" onclick="addProductsToCart()">
                            <span class="glyphicon glyphicon-send" aria-hidden="true"></span>&nbsp;发货</button>
                        <button class="btn btn-danger cancel" onclick="delOrder(${order.id})">
                            <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>删除</button>
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

<!-- 删除提示框 start -->
<div class="modal fade" tabindex="-1" id="delOrderModel">
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
                <h4>确认要【删除该订单】吗？</h4>
                <input type="hidden" id="orderId">
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary updateProType" onclick="deleteOrder()" data-dismiss="modal">确认</button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<!-- 删除提示框 end -->

<!-- 订单详情 start -->
<div class="modal fade" tabindex="-1" id="orderDetail">
    <!-- 窗口声明 -->
    <div class="modal-dialog modal-lg">
        <!-- 内容声明 -->
        <form action="" class="form-horizontal">
            <div class="modal-content">
                <!-- 头部、主体、脚注 -->
                <div class="modal-header">
                    <button class="close" data-dismiss="modal">&times;</button>
                    <h4 class="modal-title">订单详情</h4>
                </div>
                <div class="modal-body text-center row">
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label for="order-num" class="col-sm-4 control-label">订单序号：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="order-num" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="order-no" class="col-sm-4 control-label">订单号：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="order-no" value="" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-person" class="col-sm-4 control-label">下单人：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-person" value="" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">下单时间：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="order-time" value="" readonly>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">商品名称：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="pro-productName">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">商品价格：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="proPrice">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="pro-price" class="col-sm-4 control-label">购买数量：</label>
                            <div class="col-sm-2">
                                <select class="form-control" value="amount" id="quantitySelect">
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                            <label for="pro-price" class="col-sm-3 control-label">订单价格：</label>
                            <div class="col-sm-3">
                                <input type="text" class="form-control" id="pro-price">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="receicePersion" class="col-sm-4 control-label">收件人：</label>
                            <div class="col-sm-8">
                                <input type="text" class="form-control" id="receicePersion">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="receiceAddress" class="col-sm-4 control-label">收件地址：</label>
                            <div class="col-sm-8">
                                <textarea class="form-control" rows="3" id="receiceAddress">

                                </textarea>
                            </div>
                        </div>

                    </div>
                    <div class="col-sm-4">
                        <!-- 显示图像预览 -->
                        <img style="width: 160px;height: 180px;" id="img2">
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-primary updatePro">修改</button>
                    <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
                </div>
            </div>
        </form>
    </div>
</div>
<!-- 订单详情请 end -->
</body>

</html>
