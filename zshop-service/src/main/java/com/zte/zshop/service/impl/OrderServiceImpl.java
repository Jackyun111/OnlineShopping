package com.zte.zshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zte.zshop.constant.Constants;
import com.zte.zshop.dao.OrderDao;
import com.zte.zshop.entity.Customer;
import com.zte.zshop.entity.Order;
import com.zte.zshop.service.OrderService;
import com.zte.zshop.vo.OrderVo;
import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-16 11:15
 * Description:<描述>
 */
@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Override
    public void addOder(OrderVo orderVo) {

        Order order = new Order();

        try {
            //复制属性
            PropertyUtils.copyProperties(order,orderVo);

            //设置客户ID
            Customer customer = new Customer();
            customer.setId(orderVo.getCustomerId());

            order.setCustomer(customer);
            order.setStatus(Constants.ORDER_NOT_SEND);

            orderDao.insert(order);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public PageInfo<Order> findAll(Integer pageNum, int pageSize) {

        PageHelper.startPage(pageNum,pageSize);
        List<Order> orders = orderDao.selectAll();
        PageInfo<Order> pageInfo = new PageInfo<>(orders);

        return pageInfo;
    }

    @Override
    public void removeOrder(Integer id) {

        orderDao.delOrder(id);
    }

    @Override
    public Order detailOrder(Integer id) {

        return orderDao.selectById(id);
    }

    @Override
    public PageInfo<Order> findOrderByCustomerId(Integer pageNum, int pageSize, Integer customerId) {

        PageHelper.startPage(pageNum,pageSize);
        List<Order> orders = orderDao.selectByCustomerId(customerId);
        PageInfo<Order> pageInfo = new PageInfo<>(orders);
        return pageInfo;
    }

    @Override
    public Integer findOrderIdByOrderNo(String orderNo) {

        return orderDao.selectOrderIdByOrderNo(orderNo);
    }

    @Override
    public List<Order> findByCustomerId(Integer customerId) {

        List<Order> orders = orderDao.selectByCustomerId(customerId);

        return orders;
    }

}












