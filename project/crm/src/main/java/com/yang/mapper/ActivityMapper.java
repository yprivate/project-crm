package com.yang.mapper;


import com.yang.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    Integer getcount(@Param("searchMap") Map<String, Object> searchMap);

    List<Activity> getAll(@Param("totalRows") Integer totalRows,
                          @Param("rowsPerPage") Integer rowsPerPage,
                          @Param("searchMap")Map<String, Object> searchMap);

    void save(Activity activity);

    void delete(String[] ids);

    Activity getone(String id);

    void update(Activity activity);

    List<Activity> getexport();

    void saveList(List<Activity> data);
}
