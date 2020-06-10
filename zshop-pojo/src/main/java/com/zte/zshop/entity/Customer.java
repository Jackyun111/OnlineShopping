package com.zte.zshop.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * Author:helloboy
 * Date:2019-06-05 11:16
 * Description:<描述>
 */
public class Customer implements Serializable{

    private Integer id;

    private String name;

    private String loginName;

    private String password;

    private String phone;

    private String address;

    private Integer isValid;

    private Date registDate;

    private String image;

    public Customer() {
    }

    public Customer(Integer id, String image, Date registDate, Integer isValid, String address, String phone, String password, String loginName, String name) {
        this.id = id;
        this.image = image;
        this.registDate = registDate;
        this.isValid = isValid;
        this.address = address;
        this.phone = phone;
        this.password = password;
        this.loginName = loginName;
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

    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Integer getIsValid() {
        return isValid;
    }

    public void setIsValid(Integer isValid) {
        this.isValid = isValid;
    }

    public Date getRegistDate() {
        return registDate;
    }

    public void setRegistDate(Date registDate) {
        this.registDate = registDate;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    /*public String getDate(){
        return new SimpleDateFormat("yyyy年MM月dd日").format(registDate);
    }*/

    @Override
    public String toString() {
        return "Customer{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", loginName='" + loginName + '\'' +
                ", password='" + password + '\'' +
                ", phone='" + phone + '\'' +
                ", address='" + address + '\'' +
                ", isValid=" + isValid +
                ", registDate=" + registDate +
                ", image='" + image + '\'' +
                '}';
    }
}
