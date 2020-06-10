package com.zte.zshop.service;

import com.github.pagehelper.PageInfo;
import com.zte.zshop.entity.ProductType;
import com.zte.zshop.exception.ProductTypeExistException;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-05-12 20:08
 * Description:<描述>
 */
public interface ProductTypeService {


    //查找所有商品类型信息
    public PageInfo<ProductType> findAll(Integer page,Integer rows);

    public void add(String productTypeName)throws ProductTypeExistException;

    public ProductType findById(Integer id);

    public void modifyName(Integer id, String name)throws ProductTypeExistException;

    public void removeById(Integer id);

    public void modifyStatus(Integer id);

    public List<ProductType> findEnable(int productTypeEnable);
}
