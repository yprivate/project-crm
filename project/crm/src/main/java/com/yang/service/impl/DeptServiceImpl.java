package com.yang.service.impl;

import com.yang.domain.Dept;
import com.yang.domain.Page;
import com.yang.mapper.DeptMapper;
import com.yang.service.DeptService;
import com.yang.utils.UUIDUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DeptServiceImpl implements DeptService {
    @Resource
    private DeptMapper deptMapper;

    @Override
    public void getPage(Page page) {
        /**
         * 条件：页码和每页条数
         * 计算：
         *  1. 查询总记录数
         *  2. 计算总页数：  (总记录数 - 1) / 每页条数 + 1
         *  3. 查询当前页数据：
         select * from 表名 limit 0,  每页条数    #第1页
         select * from 表名 limit 5,  每页条数    #第2页
         select * from 表名 limit 10, 每页条数    #第3页
         ...
         select * from 表名 limit (n-1) * 每页条数, 每页条数    #第n页
         */
        //1. 查询总记录数
        Integer totalRows = deptMapper.getCount();
        //2. 计算总页数：  (总记录数 - 1) / 每页条数 + 1
        Integer totalPages = (totalRows - 1) / page.getRowsPerPage() + 1;
        // 计算起始索引
        Integer startIndex = (page.getCurrentPage() - 1) * page.getRowsPerPage();
        //根据索引查询
        List<Dept> data = deptMapper.getPageData(startIndex, page.getRowsPerPage());
        page.setTotalRows(totalRows);
        page.setTotalPages(totalPages);
        page.setData(data);
    }

    @Override
    public void addsave(Dept dept) {
        dept.setId(UUIDUtil.getUUID());
        deptMapper.addsave(dept);
    }

    @Override
    public void deleteBtn(String[] ids) {
        deptMapper.deleteBtn(ids);
    }

    @Override
    public boolean getExists(String no) {
        return deptMapper.getExists(no);
    }

    @Override
    public Dept getOne(String id) {
        return deptMapper.getOne(id);
    }

    @Override
    public void updateadd(Dept dept) {
        deptMapper.updateadd(dept);
    }

    @Override
    public List<Dept> getAll() {
        return deptMapper.getAll();
    }
}
