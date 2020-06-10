package com.zte.zshop.service;

import com.github.pagehelper.PageInfo;
import com.zte.zshop.dto.CustomerDto;
import com.zte.zshop.entity.Customer;
import com.zte.zshop.exception.LoginErrorExcpetion;
import com.zte.zshop.exception.PhoneNotFoundException;
import com.zte.zshop.params.CustomerParam;
import com.zte.zshop.vo.CustomerVo;
import org.apache.commons.fileupload.FileUploadException;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-05 11:05
 * Description:<描述>
 */
public interface CustomerService {

    public PageInfo<Customer> findAll(Integer pageNum, int pageSize);

    public Customer findById(Integer id);

    public void modifyCustomer(CustomerVo customerVo);

    public void changeStatus(Integer id);

    public List<Customer> findByParam(CustomerParam customerParam);

    public Customer loginByNameAndPass(String loginName, String password)throws LoginErrorExcpetion;

    public void modifyPassByNameAndPass(String customerName, String newPass);

    public Customer findByPhone(String phone) throws PhoneNotFoundException;

    public boolean checkLoginName(String loginName);

    public boolean checkName(String name);

    public void add(CustomerVo customerVo);

    public Customer addImage(CustomerDto customerDto)throws FileUploadException;
}
