package com.yang.mapper;

import com.yang.domain.Dept;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DeptMapper {
    Integer getCount();

    List<Dept> getPageData(@Param("startIndex") Integer startIndex,
                           @Param("rowsPerPage") Integer rowsPerPage);

    void addsave(Dept dept);

    void deleteBtn(String[] ids);

    boolean getExists(String no);

    void save(Dept dept);

    Dept getOne(String id);

    void updateadd(Dept dept);

    List<Dept> getAll();
}
