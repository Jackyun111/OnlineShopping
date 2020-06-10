package com.zte.zshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zte.zshop.constant.Constants;
import com.zte.zshop.dao.CustomerDao;
import com.zte.zshop.dto.CustomerDto;
import com.zte.zshop.entity.Customer;
import com.zte.zshop.exception.LoginErrorExcpetion;
import com.zte.zshop.exception.PhoneNotFoundException;
import com.zte.zshop.ftp.FTPConfig;
import com.zte.zshop.ftp.FTPUtils;
import com.zte.zshop.params.CustomerParam;
import com.zte.zshop.service.CustomerService;
import com.zte.zshop.utils.StringUtils;
import com.zte.zshop.vo.CustomerVo;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.fileupload.FileUploadException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.Date;
import java.util.List;

/**
 * Author:helloboy
 * Date:2019-06-05 11:05
 * Description:<描述>
 */
@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class CustomerServiceImpl implements CustomerService {


    @Autowired
    private CustomerDao customerDao;

    @Autowired
    private FTPConfig ftpConfig;

    @Override
    public PageInfo<Customer> findAll(Integer pageNum, int pageSize) {

        PageHelper.startPage(pageNum,pageSize);
        List<Customer> customers = customerDao.selectAll();

        PageInfo<Customer> pageInfo = new PageInfo<>(customers);

        return pageInfo;
    }

    @Override
    public Customer findById(Integer id) {

        return customerDao.selectById(id);
    }

    @Override
    public void modifyCustomer(CustomerVo customerVo) {

        Customer customer = new Customer();

        try {
            PropertyUtils.copyProperties(customer,customerVo);
            customerDao.update(customer);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public void changeStatus(Integer id) {

        Customer customer = customerDao.selectById(id);
        Integer isValid = customer.getIsValid();
        if (isValid == Constants.SYSUSER_VALID){
            isValid = Constants.SYSUSER_INVALID;
        }else {
            isValid = Constants.SYSUSER_VALID;
        }
        customerDao.updateStatus(id,isValid);
    }

    @Override
    public List<Customer> findByParam(CustomerParam customerParam) {


        return customerDao.selectByParam(customerParam);
    }

    @Override
    public Customer loginByNameAndPass(String loginName, String password) throws LoginErrorExcpetion {

        Customer customer = customerDao.selectByNameAndPass(loginName,password,Constants.CUSTOMER_VALID);

        if (customer==null){
            throw new LoginErrorExcpetion("登录失败,用户名或密码错误");
        }
        return customer;
    }

    @Override
    public void modifyPassByNameAndPass(String customerName, String newPass) {

        customerDao.updatePassByNameAndPass(customerName,newPass);
    }

    @Override
    public Customer findByPhone(String phone) throws PhoneNotFoundException {

        Customer customer= customerDao.selectByPhone(phone);
        if(customer==null){

            throw  new PhoneNotFoundException("该手机号尚未注册");
        }
        return customer;
    }

    @Override
    public boolean checkLoginName(String loginName) {

        Customer customer = customerDao.selectByLoginName(loginName);

        if (customer==null){
            return true;
        }
        return false;
    }

    @Override
    public boolean checkName(String name) {
        Customer customer = customerDao.selectByName(name);

        if (customer==null){
            return true;
        }
        return false;
    }

    @Override
    public void add(CustomerVo customerVo) {

        Customer customer = new Customer();

        try {

            PropertyUtils.copyProperties(customer,customerVo);

            customer.setIsValid(Constants.CUSTOMER_VALID);
            customer.setRegistDate(new Date());

            customerDao.insertNewCustomer(customer);

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public Customer addImage(CustomerDto customerDto) throws FileUploadException {

        //获取用户名
        String fileName= StringUtils.renameFileName(customerDto.getFileName());

        //获取上传路径
        //String filePath = productDto.getUploadPath()+"\\"+fileName;

        //获取二级目录
        String picSavePath = StringUtils.generateRandomDir(fileName);

        //上传文件
        String filePath="";

        try {
            //StreamUtils.copy(productDto.getInputStream(),new FileOutputStream(filePath));

            filePath= FTPUtils.pictureUploadByConfig(ftpConfig, fileName, picSavePath, customerDto.getInputStream());
        } catch (IOException e) {
            throw new FileUploadException("文件上传失败:"+e.getMessage());
        }

        //将值插入数据库中
        //dto--->pojo
        //Product product = new Product();
        Customer customer = new Customer();

        try {
            PropertyUtils.copyProperties(customer,customerDto);
            customer.setImage(filePath);

            customerDao.insertImage(customer);

            return customer;


        } catch (Exception e) {
            e.printStackTrace();

            return null;

        }


    }

}
















