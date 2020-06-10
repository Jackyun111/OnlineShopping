package com.zte.zshop.dao;

import com.zte.zshop.entity.Order;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-16 11:16
 * Description:<描述>
 */
public interface OrderDao {

    //订单生成，插入数据库
    public void insert(Order order);

    public List<Order> selectAll();

    public void delOrder(Integer id);

    public Order selectById(Integer id);

    public List<Order> selectByCustomerId(Integer customerId);

    public Integer selectOrderIdByOrderNo(String orderNo);

    public Order selectIdByNo(String orderNo);
}
