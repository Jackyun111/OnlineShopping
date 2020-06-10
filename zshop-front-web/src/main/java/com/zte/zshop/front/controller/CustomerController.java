package com.zte.zshop.front.controller;

import com.zte.zshop.entity.Customer;
import com.zte.zshop.exception.LoginErrorExcpetion;
import com.zte.zshop.service.CustomerService;
import com.zte.zshop.utils.ResponseResult;
import com.zte.zshop.vo.CustomerVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Author:helloboy
 * Date:2019-06-11 20:45
 * Description:<描述>
 */
@Controller
@RequestMapping("/front/customer")
public class CustomerController {

    @Autowired
    private CustomerService customerService;

    @RequestMapping("/login")
    @ResponseBody
    public ResponseResult login(String loginName,String password,HttpSession session){

        //System.out.println(loginName+password);
        try {
            Customer customer = customerService.loginByNameAndPass(loginName, password);
            session.setAttribute("customer",customer);
            return ResponseResult.success(customer);
        } catch (LoginErrorExcpetion e) {
           // e.printStackTrace();
            return ResponseResult.fail(e.getMessage());
        }
    }

    @RequestMapping("/loginOut")
    @ResponseBody
    public ResponseResult loginOut(HttpSession session){

        //注销会话
        session.invalidate();
        return ResponseResult.success("退出成功");
    }

    @RequestMapping("/checkPass")
    @ResponseBody
    public Map<String,Object> checkPass(String oldPass,HttpSession session){

        Customer customer = (Customer) session.getAttribute("customer");
        String pass = customer.getPassword();

        Map<String,Object> map = new HashMap<>();

        //System.out.println(pass+":"+oldPass);
        if (oldPass.equals(pass)){
            map.put("valid",true);
        }
        else {

            map.put("valid",false);
            map.put("message","密码不正确");
        }

        return map;

    }

    @RequestMapping("/checkLoginName")
    @ResponseBody
    public Map<String,Object> checkLoginName(String loginName){

        Map<String,Object> map = new HashMap<>();
        boolean res = customerService.checkLoginName(loginName);

        //如果名称不存在,则可以使用
        if (res){
            map.put("valid",true);
        }
        else {
            map.put("valid",false);
            map.put("message","登录账户("+loginName+")已经存在");
        }
        return map;

    }


    @RequestMapping("/checkName")
    @ResponseBody
    public Map<String,Object> checkName(String name){

        Map<String,Object> map = new HashMap<>();
        boolean res = customerService.checkName(name);

        //如果名称不存在,则可以使用
        if (res){
            map.put("valid",true);
        }
        else {
            map.put("valid",false);
            map.put("message","用户名("+name+")已经存在");
        }
        return map;

    }


    @RequestMapping("/signUp")
    @ResponseBody
    public ResponseResult signUp(CustomerVo customerVo){

        try {
            //sysuserService.add(sysuserVo);

            customerService.add(customerVo);
            return ResponseResult.success("添加成功");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseResult.fail("添加失败");
        }

    }




}














