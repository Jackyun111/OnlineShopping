package com.zte.zshop.service;

import com.github.pagehelper.PageInfo;
import com.zte.zshop.entity.Order;
import com.zte.zshop.vo.OrderVo;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-16 11:14
 * Description:<描述>
 */
public interface OrderService {

    //生成订单，添加到数据库
    public void addOder(OrderVo orderVo);


    public PageInfo<Order> findAll(Integer pageNum, int pageSize);

    public void removeOrder(Integer id);

    public Order detailOrder(Integer id);

    public PageInfo<Order> findOrderByCustomerId(Integer pageNum, int pageSize, Integer customerId);

    public Integer findOrderIdByOrderNo(String orderNo);

    public List<Order> findByCustomerId(Integer customerId);
}
