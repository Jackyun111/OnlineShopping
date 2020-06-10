package com.zte.zshop.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zte.zshop.constant.Constants;
import com.zte.zshop.dao.SysuserDao;
import com.zte.zshop.entity.Role;
import com.zte.zshop.entity.Sysuser;
import com.zte.zshop.exception.SysuserNotExistException;
import com.zte.zshop.params.SysuserParam;
import com.zte.zshop.service.SysuserService;
import com.zte.zshop.vo.SysuserVo;
import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * Author:helloboy
 * Date:2019-05-24 15:29
 * Description:<描述>
 */
@Service
@Transactional(propagation = Propagation.REQUIRED,rollbackFor = Exception.class)
public class SysuserServiceImpl implements SysuserService {

    @Autowired
    private SysuserDao sysuserDao;

    @Override
    public PageInfo<Sysuser> findAll(Integer pageNum, int pageSize) {

        PageHelper.startPage(pageNum,pageSize);
        List<Sysuser> sysusers = sysuserDao.selectAll();

        PageInfo<Sysuser> pageInfo = new PageInfo<>(sysusers);
        return pageInfo;
    }

    @Override
    public void add(SysuserVo sysuserVo) {

        Sysuser sysuser = new Sysuser();

        try {

            PropertyUtils.copyProperties(sysuser,sysuserVo);

            sysuser.setIsValid(Constants.SYSUSER_VALID);
            sysuser.setCreateDate(new Date());

            Role role = new Role();
            role.setId(sysuserVo.getRoleId());
            sysuser.setRole(role);

            sysuserDao.insert(sysuser);

        } catch (Exception e) {

            e.printStackTrace();
        }

    }

    @Override
    public boolean checkLoginName(String loginName) {

        Sysuser sysuser = sysuserDao.selectByName(loginName);
        if (sysuser!=null){
            return false;
        }

        return true;
    }

    @Override
    public Sysuser findById(Integer id) {

        return sysuserDao.selectById(id);
    }

    @Override
    public void modifyStatus(Integer id) {

        Sysuser sysuser = sysuserDao.selectById(id);
        Integer isValid = sysuser.getIsValid();
        if (isValid==Constants.SYSUSER_VALID){
            isValid=Constants.SYSUSER_INVALID;
        }else {
            isValid=Constants.SYSUSER_VALID;
        }

        sysuserDao.updateStatus(id,isValid);

    }

    @Override
    public List<Sysuser> findByParam(SysuserParam sysuserParam) {


        return sysuserDao.selectByParam(sysuserParam);
    }

    @Override
    public Sysuser login(String loginName, String password) throws SysuserNotExistException {

        Sysuser sysuser = sysuserDao.selectByLoginNameAndPass(loginName,password,Constants.SYSUSER_VALID);
        if (sysuser!=null){
            return sysuser;
        }
        throw new SysuserNotExistException("用户名或密码不正确");
    }

    @Override
    public void modifySysuser(SysuserVo sysuserVo) {

        Sysuser sysuser = new Sysuser();

        try {
            PropertyUtils.copyProperties(sysuser,sysuserVo);
            Role role = new Role();
            role.setId(sysuserVo.getRoleId());
            sysuser.setRole(role);

            sysuserDao.update(sysuser);

        } catch (Exception e) {
            e.printStackTrace();
        }


    }
}












