package com.zte.zshop.front.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zte.zshop.cart.ShoppingCart;
import com.zte.zshop.cart.ShoppingCartItem;
import com.zte.zshop.constant.Constants;
import com.zte.zshop.dto.CustomerDto;
import com.zte.zshop.entity.*;
import com.zte.zshop.front.VO.CustomerVO;
import com.zte.zshop.front.cart.ShoppingCartUtils;
import com.zte.zshop.params.ProductParam;
import com.zte.zshop.service.*;
import com.zte.zshop.utils.ResponseResult;
import com.zte.zshop.vo.OrderVo;
import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLConnection;
import java.util.*;

/**
 * Author:helloboy
 * Date:2019-05-30 14:49
 * Description:<描述>
 */
@Controller
@RequestMapping("/front/product")
public class ProductController {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductTypeService productTypeService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private ItemService itemService;

    @Autowired
    private CustomerService customerService;

    @ModelAttribute("productTypes")
    public List<ProductType> loadProductTypes(){
        List<ProductType> productTypes = productTypeService.findEnable(Constants.PRODUCT_TYPE_ENABLE);
        return productTypes;
    }

    @RequestMapping("/main")
    public String main(Integer pageNum,ProductParam productParam,Model model){

        String name = productParam.getName();
        Integer productTypeId = productParam.getProductTypeId();
        Double minPrice = productParam.getMinPrice();
        Double maxPrice = productParam.getMaxPrice();

        if (ObjectUtils.isEmpty(pageNum)){
            pageNum= Constants.PAGE_NO;
        }

        //productParam.setStatus(Constants.PRODUCT_ENABLE);
        //设置前台每页显示4条记录
        PageHelper.startPage(pageNum, Constants.PAGE_SIZE_FRONT);
        List<Product> products = productService.findByParam(productParam);
        PageInfo<Product> pageInfo = new PageInfo<>(products);
        model.addAttribute("data",pageInfo);
        model.addAttribute("productParam",productParam);

        //System.out.println("name:"+name+"productTypeId:"+productTypeId+"minPrice:"+minPrice+"maxPrice:"+maxPrice);

        return "main";
    }

    //显示图片
    //逻辑：将图片输出到页面级输出流
    @RequestMapping("/showPic")
    public void showPic(String image,OutputStream out)throws IOException {

        URL url = new URL(image);
        URLConnection urlConnection = url.openConnection();
        InputStream is = urlConnection.getInputStream();
        BufferedOutputStream bos = new BufferedOutputStream(out);
        //创建一个缓冲块，一个读取4k
        byte[] data = new byte[4096];
        int size = 0;
        size=is.read(data);
        while (size!=-1){
            bos.write(data,0,size);
            size=is.read(data);
        }
        is.close();
        bos.flush();
        bos.close();
    }

    //显示我的订单页面
    @RequestMapping("/toOrders")
     public String toOrders(Integer pageNum,Model model,HttpSession session){

        Customer customer = (Customer) session.getAttribute("customer");
        Item item = new Item();

        Map<Integer,Object> map = new HashMap<>();

        //Integer customerId = customer.getId();

        if (ObjectUtils.isEmpty(pageNum)){
            pageNum=Constants.PAGE_NO;
        }

        Integer customerId = customer.getId();
        PageInfo<Order> pageInfo = orderService.findOrderByCustomerId(pageNum,1,customerId);


        List<Order> orders = orderService.findByCustomerId(customerId);
        //Integer i=0;
        List<Item> items = new ArrayList<>();

        for (Order order : orders) {
            items = itemService.findByOrderId(order.getId());

        }

        item = items.get(0);
        model.addAttribute("data",pageInfo);
        model.addAttribute("items",item);


        return "myOrders";
    }

    //显示购物车页面
    @RequestMapping("/toCart")
    public String toCart(){

        return "cart";


    }

    //显示购物车页面
    @RequestMapping("/toCenter")
    public String toCenter(){

        return "center";
    }

    //添加购物车功能
    @RequestMapping("/addToCart")
    @ResponseBody
    public ResponseResult addToCart(Integer id,HttpSession session){

        //获取购物车对象
        ShoppingCart sc = ShoppingCartUtils.getShoppingCart(session);
        /*ShoppingCart shoppingCart = (ShoppingCart) session.getAttribute("shoppingCart");
        System.out.println(shoppingCart.getProductNumber());*/

        
        //调用service方法
        boolean flag = productService.addToCart(id,sc);

        //System.out.println(sc.getProductNumber());
        if (flag){
            return ResponseResult.success("添加成功");
        }
        return ResponseResult.fail("商品数量不能超过5件");
    }

    //删除购物车
    @RequestMapping("/removeCart")
    @ResponseBody
    public ResponseResult removeCart(Integer id,HttpSession session){

        ShoppingCart shoppingCart = ShoppingCartUtils.getShoppingCart(session);

        productService.removeItemById(shoppingCart,id);

        if (shoppingCart.isEmpty()){
            return ResponseResult.fail("购物车为空");
        }

        //重新计算总价
        Double totalMoney = shoppingCart.getTotalMoney();

        return ResponseResult.success(totalMoney);

    }

    //删除购物车,根据选中项
    @RequestMapping("/removeCartByIds")
    @ResponseBody
    public ResponseResult removeCartByIds(int[] ids,HttpSession session){

        ShoppingCart shoppingCart = ShoppingCartUtils.getShoppingCart(session);

        productService.removeItemByIds(shoppingCart, ids);

        if (shoppingCart.isEmpty()){
            return ResponseResult.fail("购物车为空");
        }

        //重新计算总价
        Double totalMoney = shoppingCart.getTotalMoney();

        /*for (int id:ids){
            System.out.println(id);
        }*/

        //System.out.println("ids="+ids);
        return ResponseResult.success("删除成功",totalMoney);

        //return ResponseResult.success("删除成功");

    }

    //修改购物车
    @RequestMapping("/modifyCart")
    @ResponseBody
    public Map<String,Object> modifyCart(Integer id,Integer quantity,HttpSession session){

        ShoppingCart shoppingCart = ShoppingCartUtils.getShoppingCart(session);

        productService.modifyCart(shoppingCart, id, quantity);

        //System.out.println("id:"+id+"quantity:"+quantity);

        //返回json数据
        //设置两个值，单个商品的总价和总价
        Map<String,Object> result = new HashMap<>();
        result.put("itemMoney",shoppingCart.getProducts().get(id).getItemMoney());
        result.put("totalMoney",shoppingCart.getTotalMoney());
        return result;

    }

    @RequestMapping("/clearShoppingCart")
    @ResponseBody
    public ResponseResult clearShoppingCart(HttpSession session){

        ShoppingCart shoppingCart = ShoppingCartUtils.getShoppingCart(session);
        productService.removeShoppingCart(shoppingCart);
        return ResponseResult.success("清空购物车成功");

    }

    @RequestMapping("/showOrder")
    public String showOrder(){

        return "order";
    }

    //生成购物车结算订单
    @RequestMapping("/generateOrder")
    @ResponseBody
    public ResponseResult generateOrder(OrderVo orderVo,HttpSession session){

        /*//生成订单
        String orderNo = ShoppingCartUtils.getOrderIdByItem();

        ShoppingCart shoppingCart = ShoppingCartUtils.getOrderCart(session);
        ShoppingCartItem shoppingCartItem = new ShoppingCartItem();
        Integer quantity = 0;
        Set<Integer> ks = shoppingCart.getProducts().keySet();
        for (Integer k:ks){

            shoppingCartItem = shoppingCart.getProducts().get(k);
            quantity = shoppingCartItem.getQuantity();
            System.out.println(k+":"+quantity+":"+orderNo);

        }*/


        try {
            //生成订单
            String orderNo = ShoppingCartUtils.getOrderIdByItem();

            orderVo.setNo(orderNo);
            orderVo.setCreateDate(new Date());
            //数据插入数据库
            orderService.addOder(orderVo);

            ShoppingCart shoppingCart = ShoppingCartUtils.getOrderCart(session);
            ShoppingCartItem shoppingCartItem = new ShoppingCartItem();
            Integer quantity = 0;
            Set<Integer> ks = shoppingCart.getProducts().keySet();
            for (Integer k:ks){

                shoppingCartItem = shoppingCart.getProducts().get(k);
                quantity = shoppingCartItem.getQuantity();
                System.out.println(k+":"+quantity+":"+orderNo);

                itemService.addNewOrder(k,quantity,orderNo);

            }

            return ResponseResult.success(orderNo);
        } catch (Exception e) {
            //e.printStackTrace();

            return ResponseResult.fail("生成订单失败");
        }

    }


    @RequestMapping("/toDetail")
    public String toDetail(){
        return "new";
    }

    @RequestMapping("/findById")
    @ResponseBody
    public ResponseResult findById(Integer id){

        Product product = productService.findByFrontId(id);
        return ResponseResult.success(product);

    }

    //
    @RequestMapping("/addProductsToCart")
    @ResponseBody
    public ResponseResult addProductsToCart(Integer id,Integer quantity,HttpSession session){

        //获取购物车对象
        ShoppingCart sc = ShoppingCartUtils.getShoppingCart(session);
        /*ShoppingCart shoppingCart = (ShoppingCart) session.getAttribute("shoppingCart");
        System.out.println(shoppingCart.getProductNumber());*/


        //调用service方法
        //boolean flag = productService.addToCart(id,sc);
        boolean flag = productService.addProductsToCart(id,quantity,sc);

        //System.out.println(sc.getProductNumber());
        if (flag){
            return ResponseResult.success("添加成功");
        }
        return ResponseResult.fail("商品购买数量不能超过5件");


    }

    @RequestMapping("/makeOrder")
    @ResponseBody
    public ResponseResult makeOrder(int[] ids,int[] quantitys,HttpSession session){

        ShoppingCart shoppingCart = ShoppingCartUtils.getOrderCart(session);

        int count = 0;
        for (int k=0;k<ids.length;k++){
            System.out.println(ids[k]);
            System.out.println(quantitys[k]);

            boolean flag = productService.addProductsToCart(ids[k],quantitys[k],shoppingCart);
            if (flag){
                count++;
            }

        }
        if (count != ids.length-1){
            return ResponseResult.fail("商品数量不能超过5");
        }

        return ResponseResult.success("结算成功");

    }


    @RequestMapping("/modifyPass")
     public String modifyPass(String customerName,String newPass,Model model){

        try {

            customerService.modifyPassByNameAndPass(customerName,newPass);

            model.addAttribute("successMsg","修改成功");
        } catch (Exception e) {
            //e.printStackTrace();
            model.addAttribute("errorMsg","修改失败");
        }
        //System.out.println(customerName+":"+oldPass+":"+newPass);
        return "forward:main";

    }


    @RequestMapping("/signUp")
    public String signUp(String name,Model model){

        //System.out.println(customerVO);

        System.out.println(name);

        //return "forward:main?pageNum="+Constants.PAGE_NO;
        return "main";
    }


    @RequestMapping("/upLoadImage")
    public String upLoadImage(CustomerVO customerVO,Model model,HttpSession session){

        Customer customerOfSession = (Customer) session.getAttribute("customer");
        CustomerDto customerDto = new CustomerDto();
        Customer customer = new Customer();

        try {

            PropertyUtils.copyProperties(customerDto, customerVO);

            customerDto.setFileName(customerVO.getFile().getOriginalFilename());
            customerDto.setInputStream(customerVO.getFile().getInputStream());

            customer = customerService.addImage(customerDto);

            customerOfSession.setImage(customer.getImage());

            model.addAttribute("successMsg", "修改头像成功");


        } catch (Exception e) {
            //e.printStackTrace();

            model.addAttribute("errorMsg",e.getMessage());
        }
        //System.out.println(customerVO.getId());

        return "forward:main";
    }



}











