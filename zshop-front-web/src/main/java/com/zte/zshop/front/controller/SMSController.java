package com.zte.zshop.front.controller;

import com.zte.zshop.constant.Constants;
import com.zte.zshop.entity.Customer;
import com.zte.zshop.exception.PhoneNotFoundException;
import com.zte.zshop.service.CustomerService;
import com.zte.zshop.utils.HttpClientUtils;
import com.zte.zshop.utils.ResponseResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

/**
 * Author:helloboy
 * Date:2019-06-19 15:24
 * Description:<描述>
 */
@Controller
@RequestMapping("/sms")
public class SMSController {

    @Value("${sms.url}")
    private String url;

    @Value("${sms.key}")
    private String key;

    @Value("${sms.tpl_id}")
    private String tplId;

    @Value("${sms.tpl_value}")
    private String tplVal;

    @Autowired
    private CustomerService customerService;

    @RequestMapping("/sendMessage")
    @ResponseBody
    public ResponseResult sendMessage(String phone,HttpSession session){

        try {
            //生成随机六位数
            int randCode = (int) ((Math.random() * 9 + 1) * 100000);
            session.setAttribute("randCode",randCode);

            Map<String,String> map = new HashMap<>();
            map.put("mobile",phone);
            map.put("tpl_id",tplId);
            map.put("tpl_value",tplVal+randCode);
            map.put("key",key);

            //发送消息
            HttpClientUtils.doPost(url,map);

            return ResponseResult.success("验证码发送成功");
        } catch (Exception e) {
            //e.printStackTrace();

            return ResponseResult.fail("验证码发送失败");
        }
    }


    @RequestMapping("/loginBySMS")
    @ResponseBody
    public ResponseResult loginBySMS(String phone,int verificationCode,HttpSession session){

        ResponseResult result=  ResponseResult.fail("");

        try {
            //判断手机号是否注册
            Customer customer= customerService.findByPhone(phone);

            //判断验证码是否存在
            Object randCode = session.getAttribute("randCode");
            if(!ObjectUtils.isEmpty(randCode)){
                //判断验证码是否正确
                int code=(int)randCode;
                if(code==verificationCode){

                    //重新设置你好：XX
                    session.setAttribute("customer",customer);
                    result.setData(customer);
                    result.setStatus(Constants.RESPONSE_STATUS_SUCCESS);

                }
                else{
                    result.setMessage("验证码不正确");
                }
            }
            else{
                result.setMessage("验证码不存在或者已经过期，请重新输入");
            }
        } catch (PhoneNotFoundException e) {
            //e.printStackTrace();
            result.setMessage(e.getMessage());
        }
        return  result;


    }
}

















