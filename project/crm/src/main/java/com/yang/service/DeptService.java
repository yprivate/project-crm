package com.yang.service;

import com.yang.domain.Dept;
import com.yang.domain.Page;

import java.util.List;


public interface DeptService {
    //查询部门跟初始化分页
    void getPage(Page page);
    //增加部门
    void addsave(Dept dept);

    void deleteBtn(String[] ids);

    boolean getExists(String no);

    Dept getOne(String id);

    void updateadd(Dept dept);

    List<Dept> getAll();
}
