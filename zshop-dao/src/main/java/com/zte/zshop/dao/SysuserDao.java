package com.zte.zshop.dao;

import com.zte.zshop.entity.Sysuser;
import com.zte.zshop.params.SysuserParam;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Author:helloboy
 * Date:2019-05-24 15:31
 * Description:<描述>
 */
public interface SysuserDao {

     public List<Sysuser> selectAll();


     public void insert(Sysuser sysuser);

     public Sysuser selectByName(String loginName);

     public Sysuser selectById(Integer id);

     public void update(Sysuser sysuser);

     public void updateStatus(@Param("id")int id,@Param("isValid") int isValid);

     public List<Sysuser> selectByParam(SysuserParam sysuserParam);

     public Sysuser selectByLoginNameAndPass(@Param("loginName") String loginName, @Param("password") String password, @Param("isValid")int isValid);
}
