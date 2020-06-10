package com.zte.zshop.entity;

import java.io.Serializable;

/**
 * Author:helloboy
 * Date:2019-05-18 15:40
 * Description:<描述>
 */
public class Product implements Serializable{

    private Integer id;

    private String name;

    private Double price;

    private String info;

    private String image;

    private Integer status;

    private Integer amount;

    private ProductType productType;

    public Product() {
    }

    public Product(Integer id, ProductType productType, Integer amount, Integer status, String image, String info, Double price, String name) {
        this.id = id;
        this.productType = productType;
        this.amount = amount;
        this.status = status;
        this.image = image;
        this.info = info;
        this.price = price;
        this.name = name;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public ProductType getProductType() {
        return productType;
    }

    public void setProductType(ProductType productType) {
        this.productType = productType;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", price=" + price +
                ", info='" + info + '\'' +
                ", image='" + image + '\'' +
                ", status=" + status +
                ", amount=" + amount +
                ", productType=" + productType +
                '}';
    }
}
