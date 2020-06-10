package com.zte.zshop.service;

import com.github.pagehelper.PageInfo;
import com.zte.zshop.entity.Sysuser;
import com.zte.zshop.exception.SysuserNotExistException;
import com.zte.zshop.params.SysuserParam;
import com.zte.zshop.vo.SysuserVo;

import java.util.List;


/**
 * Author:helloboy
 * Date:2019-05-24 15:28
 * Description:<描述>
 */
public interface SysuserService {

    public PageInfo<Sysuser> findAll(Integer pageNum, int pageSize);

    public void add(SysuserVo sysuserVo);

    public boolean checkLoginName(String loginName);

    public Sysuser findById(Integer id);

    public void modifyStatus(Integer id);

    public List<Sysuser> findByParam(SysuserParam sysuserParam);

    public Sysuser login(String loginName, String password)throws SysuserNotExistException;


    public void modifySysuser(SysuserVo sysuserVo);
}
