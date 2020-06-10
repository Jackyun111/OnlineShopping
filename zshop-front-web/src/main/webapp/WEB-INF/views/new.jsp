<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>jquery.spinner数字智能加减插件</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.spinner.css" />

    <style type="text/css">
        body{margin:20px;}
        .spinnerExample{margin:10px 0;}
    </style>

</head>
<body>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.8.0.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.spinner.js"></script>
<br/><br/><br/><br/>

<center>
    <input type="text" class="spinnerExample"/>
    <br/>
    <input type="text" class="spinnerExample"/>
    <br/>
    <input type="text" class="spinnerExample"/>
</center>

<script type="text/javascript">
    $('.spinnerExample').spinner({});
</script>


</body>
</html>