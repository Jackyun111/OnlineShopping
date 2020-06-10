package com.zte.zshop.service;

import com.zte.zshop.entity.Item;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-20 15:03
 * Description:<描述>
 */
public interface ItemService {

    public void addNewOrder(Integer k, Integer quantity, String orderNo);

    public void addOrderIdByOrderNo(Integer orderId, String orderNo);

    public List<Item> findItems(Integer orderId);

    public List<Item> findByOrderId(Integer id);
}
