package com.zte.zshop.entity;

import java.io.Serializable;

/**
 * Author:helloboy
 * Date:2019-06-20 15:00
 * Description:<描述>
 */
public class Item implements Serializable{

    private Integer id;

    private Integer num;

    private Double price;

    private Integer orderId;

    private String orderNo;

    private Integer productId;

    private String productName;

    private String image;

    public Item() {
    }

    public Item(Integer id, String image, String productName, Integer productId, String orderNo, Integer orderId, Double price, Integer num) {
        this.id = id;
        this.image = image;
        this.productName = productName;
        this.productId = productId;
        this.orderNo = orderNo;
        this.orderId = orderId;
        this.price = price;
        this.num = num;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public Integer getNum() {
        return num;
    }

    public void setNum(Integer num) {
        this.num = num;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
