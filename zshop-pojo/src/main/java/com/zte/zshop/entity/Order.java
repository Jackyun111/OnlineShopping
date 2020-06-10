package com.zte.zshop.entity;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Author:helloboy
 * Date:2019-06-16 11:05
 * Description:<描述>
 */
public class Order implements Serializable {

    private Integer id;

    private String no;

    private Double price;

    private Integer status;

    private Date createDate;

    private Customer customer;

    public Order() {
    }

    public Order(String no, Integer id, Double price, Integer status, Date createDate, Customer customer) {
        this.no = no;
        this.id = id;
        this.price = price;
        this.status = status;
        this.createDate = createDate;
        this.customer = customer;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getNo() {
        return no;
    }

    public void setNo(String no) {
        this.no = no;
    }

    public String getRegistDate(){
        return new SimpleDateFormat("yyyy年MM月dd日HH时mm分").format(createDate);
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", no='" + no + '\'' +
                ", price=" + price +
                ", status=" + status +
                ", createDate=" + createDate +
                ", customer=" + customer +
                '}';
    }
}
