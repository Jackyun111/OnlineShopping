<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>我的购物车</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/layer/layer.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zshop.css">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.spinner.css" />
    <%--<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.0.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.spinner.js"></script>--%>

    <%--<style type="text/css">
        .spinnerExample{margin:10px 0;}
    </style>--%>

    <script>

        //显示删除模态框
        function showDelModel(id,count){
            //alert(id);
            $('#delCart').modal('show');
            //将数据放入隐藏表单
            $('#delItemId').val(id);
            $('#count').val(count);
        }

        //删除购物车商品记录
        function delCart(){

            //alert($('#delItemId').val);
            $.post(
                    '${pageContext.request.contextPath}/front/product/removeCart',
                    {"id":$('#delItemId').val()},
                    function(result){

                        if(result.status==1){
                            layer.msg(
                                    '删除成功',
                                    {
                                        time:1000,
                                        skin:'successMsg'
                                    },
                                    function(){
                                        //采用局部刷新方法
                                        let content = $('#count').val();

                                        //将对应tr删除
                                        $('#id_'+content).remove();

                                        //重新计算总价
                                        $('#totalMoney').html('￥'+result.data+'.0');
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
                                        //采用局部刷新方法
                                        let content = $('#count').val();

                                        //将对应tr删除
                                        $('#id_'+content).remove();

                                        //重新计算总价
                                        $('#totalMoney').html('￥'+0);
                                    }
                            );
                        }
                    }
            );
        }

        $(function(){

            //使用ajax技术修改单个商品数量
            //文本框数量改变触发事件
            $(':text').change(function(){
                //alert(1);
                //获取当前文本框值
                let quantityValue = $.trim(this.value);
                //正则表达
                let reg=/^\d+$/g;
                let quantity = -1;
                let flag = false;
                if(reg.test(quantityValue)){
                    quantity = parseInt(quantityValue);
                    //数量大于0才有意义
                    if(quantity>0){
                        flag = true;
                    }
                }
                //alert(flag);
                //如果输入数字<=0，提示用户
                if(!flag){
                    alert('输入的商品数量必须大于0');
                    //将之前最近一次的正确值写入文本框
                    $(this).val($(this).attr("class"));
                    return;
                }

                //单击"取消"按钮后
                let $tr = $(this).parent().parent();
                let title = $.trim($tr.find('td:eq(2)').text());
                if(!confirm("确定要修改["+title+"]的数量吗？")){
                    //将该值之前最近一次值写入文本
                    $(this).val($(this).attr('class'));
                    return;
                }else{
                    $(this).attr('class',$(this).val());
                }


                //使用ajax引擎更新购物车
                let url = '${pageContext.request.contextPath}/front/product/modifyCart';
                let idVal = $.trim(this.name);
                let args = {'id':idVal,'quantity':quantityValue,'time':new Date()};

                //获取第二个td
                let time_count = $(this).parent().parent().find('td:eq(1)').html();

                $.post(url,args,function(result){

                    //获得单个商品的总价和总价
                    //console.log(result);
                    let itemMoney = result.itemMoney;
                    let totalMoney = result.totalMoney;

                    $('#itemMoney_'+time_count).html('￥'+itemMoney+'.0');
                    $('#totalMoney').html('￥'+totalMoney+'.0');

                });
                //alert(time_count);
               // console.log(args)
            });

            //复选框全部选中或者部分选中
            $('#all').click(function(){
                //alert(1);
                //找到下面所有复选框
                //console.log($('table.table tr[id] input').length);
                $('table.table tr[id] input').prop('checked',$('#all').prop('checked'));

            });

            //批量删除
            $('#delSelected').click(function(){
                //alert(1);
                //如果没有选中任何记录，就提示用户进行选择
                if($('table.table tr[id] input:checked').length==0){
                    layer.msg(
                            '请选择需要删除的商品',
                            {
                                time:1000,
                                skin:'errorMsg'
                            }
                    );
                }else{
                    //获取被选中的id 数组
                    let ids=0;
                    $('table.table tr[id] input:checked').each(function(){

                        ids+=this.id+',';
                    });
                    //console.log(ids=ids.substr(0,ids.length-1));

                    ids=ids.substr(0,ids.length-1);
                    $.post(
                            '${pageContext.request.contextPath}/front/product/removeCartByIds',
                            {"ids":ids},
                            function(result){
                                if(result.status==1){
                                    layer.msg(
                                            '删除成功',
                                            {
                                                time:1000,
                                                skin:'successMsg'
                                            },
                                            function(){
                                                //局部刷新页面
                                                $('table.table tr[id] input:checked').parent().parent().remove();

                                                //重新计算总价
                                                $('#totalMoney').html('￥'+result.data+'.0');
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

                                                //局部刷新页面
                                                $('table.table tr[id] input:checked').parent().parent().remove();
                                                //重新计算总价
                                                $('#totalMoney').html('￥'+0);
                                            }
                                    );
                                }
                            }
                    );
                }
            });
        });

        //清空购物车
        function clearShoppingCart(){

            $.post(
                    '${pageContext.request.contextPath}/front/product/clearShoppingCart',
                    function(result){
                        if(result.status==1){

                            layer.msg(
                                    result.message,
                                    {
                                        time:1000,
                                        skin:'successMsg'
                                    },
                                    function(){

                                        //局部刷新，直接清除对应节点
                                        $('tr[id]').remove();

                                        $('#totalMoney').html('￥'+0);
                                    }
                            );
                        }
                    }
            );
        }

        //返回继续购物
        function continueShopping(){

            location.href='${pageContext.request.contextPath}/front/product/main';
        }

        //结算，生成订单
        function showOrder(){

            //首先统计复选框选中的个数，如果为0，则提示“请选择需要结算的商品”
            //如果选中个数大于0，则进行选择加入订单s
            let time = $('table.table tr[id] input:checked').length;
            //console.log(time);

            if(time == 0){

                //console.log(time+"请选择需要结算的商品");
                layer.msg(
                        '请选择需要结算的商品',
                        {
                            time:2000,
                            skin:'errorMsg'
                        }
                );

            }else{
                let productId = 0;
                let productQuantity = 0;
                let qua;
                let k;
                let obj = $('table.table tr[id] input');
                for(k in obj){
                    if(obj[k].checked){
                        qua = $(obj[k]).parent().parent().find('td:eq(4)').find('input').val();

                        productId += obj[k].value+',';
                        productQuantity += qua+',';
                    }
                }

                productId=productId.substr(0,productId.length-1);

                productQuantity=productQuantity.substr(0,productQuantity.length-1);
                //console.log(productId+"+"+productQuantity);

                $.post(
                        '${pageContext.request.contextPath}/front/product/makeOrder',
                        {"ids":productId,"quantitys":productQuantity},
                        function(result){
                            //console.log(result);

                            location.href='${pageContext.request.contextPath}/front/product/showOrder';

                        }
                );
            }


        }


        //减少数量按钮
        function decreaseQuantity(productId,btn){
            let num = $(btn).next().val();
            //alert(num);

            if(num < 2){
                $(btn).attr("disabled","disabled");
                layer.msg(
                        '商品数量不能小于0',
                        {
                            time:1000,
                            skin:'errorMsg'
                        },function(){
                            $(btn).removeAttr("disabled");
                        }
                );
            }
            else{
                $(btn).next().val(num-1);

                //使用ajax引擎更新购物车
                let url = '${pageContext.request.contextPath}/front/product/modifyCart';
                let idVal = productId;
                let quantityValue = num-1;
                let args = {'id':idVal,'quantity':quantityValue,'time':new Date()};

                //获取第二个td
                let time_count = $(btn).parent().parent().parent().find('td:eq(1)').html();

                $.post(url,args,function(result){

                    //获得单个商品的总价和总价
                    //console.log(result);
                    let itemMoney = result.itemMoney;
                    let totalMoney = result.totalMoney;

                    $('#itemMoney_'+time_count).html('￥'+itemMoney+'.0');
                    $('#totalMoney').html('￥'+totalMoney+'.0');

                });
                //alert(idVal+":"+quantityValue+":");


            }

        }


        //增加按钮
        function increaseQuantity(productId,btn){

            let num = $(btn).prev().val();
            //alert(num);

            if(num > 4){
                $(btn).attr("disabled","disabled");
                layer.msg(
                        '商品限购5件',
                        {
                            time:2000,
                            skin:'errorMsg'
                        },function(){
                            $(btn).removeAttr("disabled");
                        }
                );
            }
            else{
                //$('#quantity').val(num+1);

                $(btn).prev().val(parseInt(num)+1);

                //使用ajax引擎更新购物车
                let url = '${pageContext.request.contextPath}/front/product/modifyCart';
                let idVal = productId;
                let quantityValue = parseInt(num)+1;
                let args = {'id':idVal,'quantity':quantityValue,'time':new Date()};

                //获取第二个td
                let time_count = $(btn).parent().parent().parent().find('td:eq(1)').html();

                $.post(url,args,function(result){

                    //获得单个商品的总价和总价
                    //console.log(result);
                    let itemMoney = result.itemMoney;
                    let totalMoney = result.totalMoney;

                    $('#itemMoney_'+time_count).html('￥'+itemMoney+'.0');
                    $('#totalMoney').html('￥'+totalMoney+'.0');

                });

            }
        }


        //显示已经选择的订单
        function showSelectOrder(){
            location.href='${pageContext.request.contextPath}/front/product/showOrder';

        }

    </script>
</head>

<body>
<% request.setAttribute("index",1);%>
<div class="navbar navbar-default clear-bottom">
    <div class="container">
        <jsp:include page="top.jsp"/>
        <!-- navbar end -->
    </div>
</div>
<!-- content start -->
<div class="container">
    <div class="row">
        <div class="col-xs-12">
            <div class="page-header" style="margin-bottom: 0px;">
                <h3>我的购物车</h3>
            </div>
        </div>
    </div>
    <table class="table table-hover table-striped table-bordered">
        <tr>
            <th>
                <input type="checkbox" id="all">
            </th>
            <th>序号</th>
            <th>商品名称</th>
            <th>商品图片</th>
            <th>商品数量</th>
            <th>商品单价</th>
            <th>商品总价</th>
            <th>操作</th>
        </tr>
        <c:forEach items="${sessionScope.shoppingCart.items}" var="cart" varStatus="s">
        <tr id="id_${s.count}">
            <td>
                <input type="checkbox" id="${cart.product.id}" value="${cart.product.id}"/>
            </td>
            <td>${s.count}</td>
            <td>${cart.product.name}</td>
            <td> <img src="${pageContext.request.contextPath}/front/product/showPic?image=${cart.product.image}" alt="" width="40" height="40"></td>
            <%--&lt;%&ndash;<td>
                <input type="text" value="${cart.quantity}" name="${cart.product.id}" class="${cart.quantity}" size="5" id="">&ndash;%&gt;
            </td>--%>
            <td>
                <div class="spinner">
                    <button class="decrease" onclick="decreaseQuantity(${cart.product.id},this)" id="btd" name="btd">-</button>
                    <input type="text" class="spinnerExample value passive" maxlength="2" value="${cart.quantity}" id="quantity" name="${cart.product.id}">
                    <button class="increase" onclick="increaseQuantity(${cart.product.id},this)" id="bti">+</button>
                </div>
            </td>
            <td>￥${cart.product.price}</td>
            <td id="itemMoney_${s.count}">￥${cart.itemMoney}</td>
            <td>
                <button class="btn btn-success" type="button"> <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>修改</button>
                <button class="btn btn-danger" type="button" onclick="showDelModel(${cart.product.id},${s.count})">
                    <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
                </button>
            </td>
        </tr>
        </c:forEach>

        <tr>

            <td colspan="8" align="right">
                <button class="btn btn-success margin-right-15" type="button" onclick="continueShopping()">                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>&nbsp;继续购物</button>
                <button class="btn btn-danger margin-right-15" type="button" id="delSelected">
                    <span class="glyphicon glyphicon-remove" aria-hidden="true"></span>&nbsp;删除选中</button>
                </button>
                <button class="btn btn-danger  margin-right-15" type="button" onclick="clearShoppingCart()">                       <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>&nbsp;全部清空</button>
                <button class="btn btn-primary margin-right-15" type="button" onclick="showOrder()">
                    <span class="glyphicon glyphicon-yen " aria-hidden="true"></span>&nbsp;选择结算</button>
                <button class="btn btn-primary margin-right-15" type="button" onclick="showSelectOrder()">                          <span class="glyphicon glyphicon-sunglasses" aria-hidden="true"></span>&nbsp;查看结算</button>
            </td>
        </tr>
        <tr>
            <td colspan="8" align="right" class="foot-msg">
                总计： <b><span id="totalMoney">￥${sessionScope.shoppingCart.totalMoney}</span> </b>
            </td>
        </tr>
    </table>
</div>
<!-- content end-->
<!-- footers start -->
<div class="footers">
    版权所有：中兴软件技术
</div>
<!-- footers end -->
<!-- 修改密码模态框 -->
<div class="modal fade" id="modifyPasswordModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">修改密码</h4>
            </div>
            <form action="" class="form-horizontal" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">原密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">新密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">重复密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <button type="reset" class="btn btn-warning">重&nbsp;&nbsp;置</button>
                    <button type="submit" class="btn btn-warning">修&nbsp;&nbsp;改</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- 登录模态框 -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">登&nbsp;陆</h4>
            </div>
            <form action="" class="form-horizontal" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登录帐号：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">验证码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                        <div class="col-sm-2 input-height">
                            1234
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <button type="reset" class="btn btn-warning">重&nbsp;&nbsp;置</button>
                    <button type="submit" class="btn btn-warning">登&nbsp;&nbsp;陆</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- 注册模态框 -->
<div class="modal fade" id="registModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">会员注册</h4>
            </div>
            <form action="" class="form-horizontal" method="post">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户姓名:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登陆账号:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登录密码:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">联系电话:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">联系地址:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <button type="reset" class="btn btn-warning">重&nbsp;&nbsp;置</button>
                    <button type="submit" class="btn btn-warning">注&nbsp;&nbsp;册</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- 删除提示框 start -->
<div class="modal fade" tabindex="-1" id="delCart">

    <input type="hidden" id="delItemId"/>
    <input type="hidden" id="count"/>
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
                <input type="hidden" id="productTypeId">
            </div>
            <div class="modal-footer">
                <button class="btn btn-primary updateProType" onclick="delCart()" data-dismiss="modal">删除</button>
                <button class="btn btn-primary cancel" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>
<!-- 删除提示框 end -->
</body>

</html>
