package com.zte.zshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zte.zshop.cart.ShoppingCart;
import com.zte.zshop.constant.Constants;
import com.zte.zshop.dao.ProductDao;
import com.zte.zshop.dto.ProductDto;
import com.zte.zshop.entity.Product;
import com.zte.zshop.entity.ProductType;
import com.zte.zshop.ftp.FTPConfig;
import com.zte.zshop.ftp.FTPUtils;
import com.zte.zshop.params.ProductParam;
import com.zte.zshop.service.ProductService;
import com.zte.zshop.utils.StringUtils;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.fileupload.FileUploadException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StreamUtils;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

/**
 * Author:helloboy
 * Date:2019-05-18 15:22
 * Description:<描述>
 */
@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class ProductServiceImpl implements ProductService{

    @Autowired
    ProductDao productDao;

    @Autowired
    private FTPConfig ftpConfig;

    @Override
    public void add(ProductDto productDto) throws FileUploadException {

        //获取用户名
        String fileName= StringUtils.renameFileName(productDto.getFileName());

        //获取上传路径
        //String filePath = productDto.getUploadPath()+"\\"+fileName;

        //获取二级目录
        String picSavePath = StringUtils.generateRandomDir(fileName);

        //上传文件
        String filePath="";

        try {
            //StreamUtils.copy(productDto.getInputStream(),new FileOutputStream(filePath));

            filePath= FTPUtils.pictureUploadByConfig(ftpConfig,fileName,picSavePath,productDto.getInputStream());
        } catch (IOException e) {
            throw new FileUploadException("文件上传失败:"+e.getMessage());
        }

        //将值插入数据库中
        //dto--->pojo
        Product product = new Product();

        try {
            PropertyUtils.copyProperties(product,productDto);
            product.setImage(filePath);
            ProductType productType = new ProductType();
            productType.setId(productDto.getProductTypeId());

            product.setProductType(productType);

            product.setStatus(Constants.PRODUCT_ENABLE);
            productDao.insert(product);

        } catch (Exception e) {
            e.printStackTrace();


        }
    }

    @Override
    public boolean checkName(String name) {

        Product product = productDao.selectByName(name);
        if (product != null){
            return false;
        }
        return true;
    }

    @Override
    public PageInfo<Product> findAll(Integer pageNum, int pageSize) {

        PageHelper.startPage(pageNum,pageSize);
        List<Product> products = productDao.selectAll();
        PageInfo<Product> pageInfo = new PageInfo<>(products);
        return pageInfo;
    }

    @Override
    public Product findById(Integer id) {

        return productDao.selectById(id);
    }

    @Override
    public void getImage(String path, OutputStream out) {
        try {
            StreamUtils.copy(new FileInputStream(path),out);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void modifyProduct(ProductDto productDto) throws FileUploadException {

        String filePath = "";
        if (productDto.getFileName()!=null) {
            //获取用户名
            String fileName= StringUtils.renameFileName(productDto.getFileName());

            //获取上传路径
            filePath = productDto.getUploadPath()+"\\"+fileName;

            //上传文件

            try {
                StreamUtils.copy(productDto.getInputStream(),new FileOutputStream(filePath));
            } catch (IOException e) {
                throw new FileUploadException("文件上传失败:"+e.getMessage());
            }
        }

        //将值插入数据库中
        //dto--->pojo
        Product product = new Product();

        try {
            PropertyUtils.copyProperties(product,productDto);
            if (productDto.getFileName()!=null) {
                product.setImage(filePath);
            }
            ProductType productType = new ProductType();
            productType.setId(productDto.getProductTypeId());

            product.setProductType(productType);
            productDao.update(product);

        } catch (Exception e) {
            e.printStackTrace();


        }
    }

    @Override
    public void removeById(Integer id) {

        productDao.deleteById(id);
    }

    @Override
    public List<Product> findByParam(ProductParam productParam) {
        return productDao.selectByParam(productParam);
    }

    @Override
    public boolean addToCart(Integer id, ShoppingCart sc) {

        Product product = productDao.selectById(id);

        if (product!=null){
            //sc.addProduct(product);
            boolean flag = sc.addProduct(product);
            return flag;
        }
        return false;
    }

    @Override
    public void removeItemById(ShoppingCart shoppingCart, Integer id) {

        shoppingCart.removeItem(id);
    }

    @Override
    public void modifyCart(ShoppingCart shoppingCart, Integer id, Integer quantity) {

        shoppingCart.updateItemQuantity(id,quantity);
    }

    @Override
    public void removeItemByIds(ShoppingCart shoppingCart, int[] ids) {

        for (int id:ids){
            shoppingCart.removeItem(id);
        }
    }

    @Override
    public void removeShoppingCart(ShoppingCart shoppingCart) {

        shoppingCart.clear();
    }

    @Override
    public Product findByFrontId(Integer id) {

        return productDao.selectByFrontId(id);
    }

    @Override
    public boolean addProductsToCart(Integer id, Integer quantity, ShoppingCart sc) {

        Product product = productDao.selectById(id);

        if (product!=null){
            boolean flag = sc.addSomeProducts(product,quantity);
            return flag;
        }
        return false;

    }

    @Override
    public void modifyProductStatus(Integer id) {

        Product product = productDao.selectById(id);
        int s = product.getStatus();

        if (s == Constants.PRODUCT_ENABLE){
            s = Constants.PRODUCT_DISABLE;
        }else if (s == Constants.PRODUCT_DISABLE){
            s = Constants.PRODUCT_ENABLE;
        }

        productDao.updateStatus(id,s);
    }



}















