package com.zte.zshop.constant;

/**
 * Author:helloboy
 * Date:2019-05-16 11:38
 * Description:<描述>
 */
public class Constants {

    //当前页
    public static final int PAGE_NO=1;
    //页大小
    public static final int PAGE_SIZE=5;

    //响应状态码:1 成功
    public static final int RESPONSE_STATUS_SUCCESS=1;
    //响应状态码:2 失败
    public static final int RESPONSE_STATUS_FAILURE=2;
    //响应状态码:3 未授权
    public static final int RESPONSE_NO_PERMISSION=3;
    //商品类型是否启用 1---启用
    public static final int PRODUCT_TYPE_ENABLE=1;
    //商品类型是否启用 0---禁用
    public static final int PRODUCT_TYPE_DISABLE=0;
    //商品是否启用
    public static final int PRODUCT_ENABLE=1;

    public static final int PRODUCT_DISABLE=0;

    //系统用户的有效状态1:表示有效
    public static final int SYSUSER_VALID=1;
    //系统用户的有效状态0:表示无效
    public static final int SYSUSER_INVALID=0;

    //前台每页记录数
    public static final int PAGE_SIZE_FRONT=4;

    //用户状态
    public static final int CUSTOMER_VALID=1;

    //订单未发货
    public static final int ORDER_NOT_SEND=0;
    //订单已发货
    public static final int ORDER_SENT=1;

}
