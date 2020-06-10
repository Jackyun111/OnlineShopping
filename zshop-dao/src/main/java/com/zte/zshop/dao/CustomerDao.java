package com.zte.zshop.dao;

import com.zte.zshop.entity.Customer;
import com.zte.zshop.params.CustomerParam;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-05 14:40
 * Description:<描述>
 */
public interface CustomerDao {

    public List<Customer> selectAll();

    public Customer selectById(Integer id);

    public void update(Customer customer);

    public void updateStatus(@Param("id") Integer id,@Param("isValid") Integer isValid);

    public List<Customer> selectByParam(CustomerParam customerParam);

    public Customer selectByNameAndPass(@Param("loginName")String loginName, @Param("password")String password,@Param("isValid") int isValid);

    public void updatePassByNameAndPass(@Param("loginName")String customerName, @Param("password")String newPass);

    public Customer selectByPhone(String phone);

    public Customer selectByLoginName(String loginName);

    public Customer selectByName(String name);

    public void insertNewCustomer(Customer customer);

    public void insertImage(Customer customer);
}
