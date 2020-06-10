package com.zte.zshop.dao;

import com.zte.zshop.entity.Product;
import com.zte.zshop.params.ProductParam;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-05-18 15:25
 * Description:<描述>
 */
public interface ProductDao {
    public void insert(Product product);

    public Product selectByName(String name);

    public List<Product> selectAll();

    public Product selectById(Integer id);

    public void update(Product product);

    public void deleteById(Integer id);

    public List<Product> selectByParam(ProductParam productParam);

    public Product selectByFrontId(Integer id);

    public void updateStatus(@Param("id")int id,@Param("status") int status);
}
