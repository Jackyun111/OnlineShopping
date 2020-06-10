package com.zte.zshop.service.impl;

import com.zte.zshop.dao.ItemDao;
import com.zte.zshop.dao.OrderDao;
import com.zte.zshop.dao.ProductDao;
import com.zte.zshop.entity.Item;
import com.zte.zshop.entity.Order;
import com.zte.zshop.entity.Product;
import com.zte.zshop.service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-20 15:04
 * Description:<描述>
 */
@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class ItemServiceImpl implements ItemService {

    @Autowired
    private ItemDao itemDao;

    @Autowired
    private ProductDao productDao;

    @Autowired
    private OrderDao orderDao;


    @Override
    public void addNewOrder(Integer k, Integer quantity, String orderNo) {

        Product product = productDao.selectById(k);

        Order order = orderDao.selectIdByNo(orderNo);

        Double price = product.getPrice();
        Double itemMoney = price*quantity;

        Item item = new Item();
        //item.setProduct(product);
        item.setProductId(product.getId());
        item.setNum(quantity);
        item.setPrice(itemMoney);
        item.setOrderNo(orderNo);
        item.setOrderId(order.getId());

        itemDao.insertNewItem(item);


    }

    @Override
    public void addOrderIdByOrderNo(Integer orderId, String orderNo) {

        itemDao.insertOrderIdByOrderNo(orderId,orderNo);
    }


    @Override
    public List<Item> findItems(Integer orderId) {

        List<Item> items = itemDao.selectByOrderId(orderId);
        Product product = new Product();
        Integer productId;
        for (Item item : items) {
            productId = item.getProductId();
            product = productDao.selectById(productId);
            item.setProductName(product.getName());
            item.setImage(product.getImage());
        }

        return items;
    }

    @Override
    public List<Item> findByOrderId(Integer id) {

        List<Item> items = itemDao.selectByOrderId(id);
        return items;
    }


}















