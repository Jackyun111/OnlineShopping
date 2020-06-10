package com.zte.zshop.service;

import com.github.pagehelper.PageInfo;
import com.zte.zshop.cart.ShoppingCart;
import com.zte.zshop.dto.ProductDto;
import com.zte.zshop.entity.Product;
import com.zte.zshop.params.ProductParam;
import org.apache.commons.fileupload.FileUploadException;

import java.io.OutputStream;
import java.util.List;

/**
 * Author:helloboy
 * Date:2019-05-18 15:14
 * Description:<描述>
 */
public interface ProductService {
    public void add(ProductDto productDto) throws FileUploadException;

    public boolean checkName(String name);

    public PageInfo<Product> findAll(Integer pageNum, int pageSize);

    public Product findById(Integer id);

    public void getImage(String path, OutputStream out);

    public void modifyProduct(ProductDto productDto) throws FileUploadException;

    public void removeById(Integer id);

    public List<Product> findByParam(ProductParam productParam);

    public boolean addToCart(Integer id, ShoppingCart sc);

    public void removeItemById(ShoppingCart shoppingCart, Integer id);

    public void modifyCart(ShoppingCart shoppingCart, Integer id, Integer quantity);

    public void removeItemByIds(ShoppingCart shoppingCart, int[] ids);

    public void removeShoppingCart(ShoppingCart shoppingCart);

    public Product findByFrontId(Integer id);

    public boolean addProductsToCart(Integer id, Integer quantity, ShoppingCart sc);

    public void modifyProductStatus(Integer id);

}
