<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <script src="${pageContext.request.contextPath}/js/template.js"></script>
    <script src="${pageContext.request.contextPath}/layer/layer.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/zshop.css">
    <script src="${pageContext.request.contextPath}/js/bootstrapValidator.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrapValidator.min.css"/>
    <%--定义一个js模板--%>
    <script id="welcome" type="text/html">

        <li class="userName">
            您好：{{name}}
        </li>
        <li class="dropdown">
            <a href="#" class="dropdown-toggle user-active" data-toggle="dropdown" role="button">
                <img class="img-circle" src="${pageContext.request.contextPath}/images/user.jpeg" height="30" />
                <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
                <li>
                    <a href="#" data-toggle="modal" data-target="#modifyPasswordModal">
                        <i class="glyphicon glyphicon-cog"></i>修改密码
                    </a>
                </li>
                <li>
                    <a href="#" onclick="loginOut()">
                        <i class="glyphicon glyphicon-off"></i> 退出
                    </a>
                </li>
            </ul>
        </li>

    </script>

    <script id="loginOut" type="text/html">

        <li>
            <a href="#" data-toggle="modal" data-target="#loginModal">登陆</a>
        </li>
        <li>
            <a href="#" data-toggle="modal" data-target="#registModal">注册</a>
        </li>

    </script>

    <script>

        //登录
        function loginByAccount(){

            /*$('#frmLoginByAccount').submit();*/
            $.post(
                    '${pageContext.request.contextPath}/front/customer/login',
                    $('#frmLoginByAccount').serialize(),
                    function(result){
                        //console.log(result);
                        if(result.status==1){

                            location.href='${pageContext.request.contextPath}/front/product/main';



                            //局部刷新页面
                            //通过template引擎获取整段html页面
                            /*let content=template('welcome',result.data);
                            //将登录模态框关闭
                            $('#loginModal').modal('hide');
                            //将对应的模板写入对应的节点
                            $('#navInfo').html(content);*/
                        }
                        else{
                            $('#loginInfo').html(result.message);
                        }
                    }
            );
        }

        //退出登录
        function loginOut(){
            //alert(1);
            $.post(
                    '${pageContext.request.contextPath}/front/customer/loginOut',
                    function(result){
                            if(result.status==1){
                                /*let content = template('loginOut');
                                $('#navInfo').html(content);*/
                                location.href='${pageContext.request.contextPath}/front/product/main';
                            }
                    }
            );
        }

        $(function(){

            //获取当前页面对应的index
            let curIndex = ${requestScope.index};
            //找到所有的class=nav的元素的li子元素
            $('ul.nav li').each(function(i){
                //将导航栏背景清空
                $(this).removeClass("active");
                //如果是当前页面就是该页，背景色高亮显示
                if(curIndex==i) {
                    $(this).addClass("active");
                }
            });



            //使用bootatrap_validator插件进行客户端数据校验
            $('#frmModifyPass').bootstrapValidator(
                    {
                        feedbackIcons: {
                            valid: 'glyphicon glyphicon-ok',//成功后输出的图标
                            invalid: 'glyphicon glyphicon-remove',//失败后输出的图标
                            validating: 'glyphicon glyphicon-refresh'//长时间加载时输出的图标
                        },
                        fields:{
                            oldPass: {
                                validators: {
                                    notEmpty: {
                                        message: '原密码不能为空'
                                    },
                                    remote:{
                                        url:"${pageContext.request.contextPath}/front/customer/checkPass"
                                    }
                                }
                            },
                            newPass:{
                                validators: {
                                    notEmpty: {
                                        message: '新密码不能为空'
                                    }
                                }
                            },
                            repeatePass:{
                                validators: {
                                    notEmpty: {
                                        message: '重复密码不能为空'
                                    },
                                    identical: {
                                        field: 'newPass',
                                        message: '两次输入的密码不相符'
                                    }
                                }
                            }
                        }
                    }
            );


            //使用bootatrap_validator插件进行客户端数据校验
            $('#frmLoginUp').bootstrapValidator(
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
                                        message: '用户名不能为空'
                                    },
                                    remote:{
                                        url:"${pageContext.request.contextPath}/front/customer/checkName"
                                    }
                                }
                            },
                            loginName:{
                                validators: {
                                    notEmpty: {
                                        message: '登录账户不能为空'
                                    },
                                    remote:{
                                        url:"${pageContext.request.contextPath}/front/customer/checkLoginName"
                                    }
                                }
                            },
                            password:{
                                validators: {
                                    notEmpty: {
                                        message: '重复密码不能为空'
                                    }
                                }
                            },
                            phone:{
                                validators: {
                                    notEmpty: {
                                        message: '电话不能为空'
                                    }
                                }
                            }
                        }
                    }
            );

        });


        //发送短信
        function sendMessage(btn){

            //alert(1);
            //alert($('#phone').val());
            $.post(
                    '${pageContext.request.contextPath}/sms/sendMessage',
                    {"phone":$('#phone').val()},
                    function(result){
                        console.log(result);

                        if(result.status==1){
                            let time=20;
                            let timer=setInterval(function(){
                                if(time>0) {
                                    //将按钮禁用
                                    $(btn).prop('disabled', true);


                                    //重新设置button的值
                                    $(btn).html('重新发送(' + time + ')');


                                    //计数
                                    time--;
                                }
                                else{
                                    //将按钮启用
                                    $(btn).prop('disabled', false);
                                    //重新设置button的值
                                    $(btn).html('重新发送');

                                    //停用计时器
                                    clearInterval(timer);

                                }
                            },1000);

                        }

                    }
            );

        }


        //
        /*function loginBySMS(){

            //alert(1);
            $.post('${pageContext.request.contextPath}/sms/loginBySMS',
                    $('#frmSms').serialize(),
                    function(result){

                        console.log(result);
                        /!*if(result.status==1){
                            //将登录模态框关闭
                            $('#loginModal').modal('hide');


                            //重新设置值：你好:XX
                            let content=template('welcome',result.data);
                            //console.log(content);
                            $('#navInfo').html(content);




                        }
                        else{

                            //将短信登录模态框设置提示消息
                            $('#loginInfoSms').html(result.message);

                        }*!/


                    });

        }*/



        //
        function signUp(){


            let bv=$('#frmLoginUp').data('bootstrapValidator');
            bv.validate();

            if(bv.isValid()){

                //alert(1);

                $.post(
                        '${pageContext.request.contextPath}/front/customer/signUp',
                        $('#frmLoginUp').serialize(),
                        function(result){
                            console.log(result);
                            if(result.status==1){
                                layer.msg(
                                        result.message,
                                        {
                                            time:1000,
                                            skin:'successMsg'
                                        },
                                        function(){
                                            location.href='${pageContext.request.contextPath}/front/product/main?pageNum='+1;
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
        }




    </script>



</head>
<body>
<div class="navbar navbar-default clear-bottom">

    <input type="hidden" id="customerId" value="">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand logo-style" href="http://edu.51cto.com/center/lec/info/index?user_id=12392007">
                <img class="brand-img" src="${pageContext.request.contextPath}/images/com-logo1.png" alt="logo" height="70">
            </a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li class="active">
                    <a href="${pageContext.request.contextPath}/front/product/main">
                        <span class="glyphicon glyphicon-home"></span>&nbsp;商城主页</a>
                </li>

                <c:choose>
                    <c:when test="${!empty customer}">

                <li>
                    <a href="${pageContext.request.contextPath}/front/product/toCart">
                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>&nbsp;购物车</a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/front/product/toOrders">
                        <span class="glyphicon glyphicon-list" aria-hidden="true"></span>&nbsp;我的订单</a>
                </li>
                <li class="dropdown">
                    <a href="${pageContext.request.contextPath}/front/product/toCenter">
                        <span class="glyphicon glyphicon-user" aria-hidden="true"></span>&nbsp;会员中心</a>
                </li>

                    </c:when>
                    <c:otherwise>
                        <li></li>
                        <li></li>
                    </c:otherwise>

                </c:choose>
            </ul>
            <ul class="nav navbar-nav navbar-right" id="navInfo">

                <c:choose>
                    <c:when test="${empty customer}">
                        <li>
                            <a href="#" data-toggle="modal" data-target="#loginModal">登陆</a>
                        </li>
                        <li>
                            <a href="#" data-toggle="modal" data-target="#registModal">注册</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="userName">
                            您好：${customer.name}
                        </li>
                        <li class="dropdown">
                            <a href="#" class="dropdown-toggle user-active" data-toggle="dropdown" role="button">
                                <img class="img-circle" src="${pageContext.request.contextPath}/front/product/showPic?image=${customer.image}" height="30" />
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li>
                                    <a href="#" data-toggle="modal" data-target="#modifyPasswordModal">
                                        <i class="glyphicon glyphicon-cog"></i>修改密码
                                    </a>
                                </li>
                                <li>
                                    <a href="#" onclick="loginOut()">
                                        <i class="glyphicon glyphicon-off"></i> 退出
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:otherwise>
                </c:choose>

            </ul>
        </div>
    </div>
</div>


<!-- 修改密码模态框 start -->
<div class="modal fade" id="modifyPasswordModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">修改密码</h4>
            </div>
            <form action="${pageContext.request.contextPath}/front/product/modifyPass" class="form-horizontal" method="post" id="frmModifyPass">

                <input type="hidden" value="${sessionScope.customer.loginName}" name="customerName">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">原密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="oldPass">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">新密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="newPass" id="newPass">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">重复密码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="repeatePass" id="repeatePass">
                            <small id="errorMsg" class="text-center"></small>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="reset" class="btn btn-primary">重&nbsp;&nbsp;置</button>
                    <button type="submit" class="btn btn-success">修&nbsp;&nbsp;改</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- 修改密码模态框 end -->

<!-- 登录模态框 start  -->
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <!-- 用户名密码登陆 start -->
        <div class="modal-content" id="login-account">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">用户名密码登录</h4>&nbsp;&nbsp;<small class="text-danger" id="loginInfo"></small>
            </div>
            <form action="" class="form-horizontal" method="post" id="frmLoginByAccount">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户名：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="loginName" placeholder="请输入用户名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">密&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="password" placeholder="请输入密码">
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="text-align: center">
                    <a class="btn-link" id="btn-sms-back">短信快捷登录</a>
                    <button type="button" class="btn btn-primary" onclick="loginByAccount()">登&nbsp;&nbsp;陆</button> &nbsp;&nbsp;
                    <button type="button" class="btn btn-danger" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <a class="btn-link">忘记密码？</a> &nbsp;
                </div>
            </form>
        </div>
        <!-- 用户名密码登陆 end -->
        <!-- 短信快捷登陆 start -->
        <div class="modal-content" id="login-sms" style="display: none;">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">短信快捷登陆</h4>
            </div>
            <form class="form-horizontal" method="post" id="frmSms">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">手机号：</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" id="phone" name="phone" placeholder="请输入手机号">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">验证码：</label>
                        <div class="col-sm-4">
                            <input class="form-control" type="text" name="verificationCode" placeholder="请输入验证码">
                        </div>
                        <div class="col-sm-2">
                            <button class="pass-item-timer" type="button" onclick="sendMessage(this)">发送验证码</button>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="text-align: center">
                    <a class="btn-link" id="btn-account-back">用户名密码登录</a>
                    <button type="submit" class="btn btn-primary" onclick="loginBySMS()">登&nbsp;&nbsp;陆</button> &nbsp;&nbsp;
                    <button type="button" class="btn btn-danger" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                    <a class="btn-link">忘记密码？</a> &nbsp;
                </div>
            </form>
        </div>
        <!-- 短信快捷登陆 end -->
    </div>
</div>
<!-- 登录模态框 end  -->

<!-- 注册模态框 start -->
<div class="modal fade" id="registModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel1">会员注册</h4>
            </div>
            <form action="" class="form-horizontal" method="post" id="frmLoginUp">
                <div class="modal-body">
                    <div class="form-group">
                        <label class="col-sm-3 control-label">用户姓名:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="name">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登陆账号:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="loginName">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">登录密码:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="password" name="password">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">联系电话:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-3 control-label">联系地址:</label>
                        <div class="col-sm-6">
                            <input class="form-control" type="text" name="address">
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-success" onclick="signUp()">注&nbsp;&nbsp;册</button>
                    <button type="reset" class="btn btn-primary">重&nbsp;&nbsp;置</button>
                    <button type="button" class="btn btn-danger" data-dismiss="modal" aria-label="Close">关&nbsp;&nbsp;闭</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- 注册模态框 end -->

</body>
</html>
