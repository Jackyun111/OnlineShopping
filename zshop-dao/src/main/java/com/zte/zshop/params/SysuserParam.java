package com.zte.zshop.params;

/**
 * Author:helloboy
 * Date:2019-05-29 17:56
 * Description:<描述>
 */
public class SysuserParam {

    private String name;

    private String loginName;

    private String phone;

    private Integer roleId;

    private Integer isValid;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getIsValid() {
        return isValid;
    }

    public void setIsValid(Integer isValid) {
        this.isValid = isValid;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getLoginName() {
        return loginName;
    }

    public void setLoginName(String loginName) {
        this.loginName = loginName;
    }

    @Override
    public String toString() {
        return "SysuserParam{" +
                "name='" + name + '\'' +
                ", loginName='" + loginName + '\'' +
                ", phone='" + phone + '\'' +
                ", roleId=" + roleId +
                ", isValid=" + isValid +
                '}';
    }
}
