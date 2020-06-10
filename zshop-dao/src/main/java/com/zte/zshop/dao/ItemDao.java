package com.zte.zshop.dao;

import com.zte.zshop.entity.Item;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-20 15:05
 * Description:<描述>
 */
public interface ItemDao {


    public void insertItem(Item item);

    public void insertItemOrderNo(String orderNo);

    public void insertNewItem(Item item);

    public void insertOrderIdByOrderNo(@Param("orderId")Integer orderId,@Param("orderNo") String orderNo);

    public List<Item> selectByOrderId(Integer orderId);
}
