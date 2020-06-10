package com.zte.zshop.params;

/**
 * Author:hellboy
 * Date:2019-05-30 14:18
 * Description:<描述>
 * 该类用于封装首页的查询条件
 */
public class ProductParam {

    //产品名称
    private String name;

    //最低价格
    private Double minPrice;

    //最高价格
    private Double maxPrice;

    //产品类型
    private Integer productTypeId;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(Double minPrice) {
        this.minPrice = minPrice;
    }

    public Double getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(Double maxPrice) {
        this.maxPrice = maxPrice;
    }

    public Integer getProductTypeId() {
        return productTypeId;
    }

    public void setProductTypeId(Integer productTypeId) {
        this.productTypeId = productTypeId;
    }
}
