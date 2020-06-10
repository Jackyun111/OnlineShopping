package com.zte.zshop.backend.controller;

import com.github.pagehelper.PageInfo;
import com.zte.zshop.constant.Constants;
import com.zte.zshop.entity.Order;
import com.zte.zshop.service.OrderService;
import com.zte.zshop.utils.ResponseResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Author:helloboy
 * Date:2019-06-19 9:51
 * Description:<描述>
 */
@Controller
@RequestMapping("/backend/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @RequestMapping("/findAll")
    public String findAll(Integer pageNum,Model model){

        if (ObjectUtils.isEmpty(pageNum)){
            pageNum= Constants.PAGE_NO;
        }
        PageInfo<Order> pageInfo =orderService.findAll(pageNum, Constants.PAGE_SIZE);
        model.addAttribute("data",pageInfo);

        return "orderManager";
    }

    //删除订单
    @RequestMapping("/deleOrder")
    @ResponseBody
    public ResponseResult deleOrder(Integer id){

        orderService.removeOrder(id);
        return ResponseResult.success("删除订单成功");

    }


    //订单详情
    @RequestMapping("/detailOrder")
    @ResponseBody
    public ResponseResult detailOrder(Integer id){

        Order order = orderService.detailOrder(id);
        //System.out.println(id);
        //System.out.println(order);
        return ResponseResult.success(order);

    }

}
