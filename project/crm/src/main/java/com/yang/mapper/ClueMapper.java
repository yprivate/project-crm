package com.yang.mapper;

import com.yang.domain.Clue;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface ClueMapper {

    Integer getcount(@Param("searchMap") Map<String, Object> searchMap);

    List<Clue> getPage(@Param("startIndex") Integer startIndex,
                       @Param("rowsPerPage") Integer rowsPerPage,
                       @Param("searchMap") Map<String, Object> searchMap);

    void save(Clue clue);

    void delete(String[] ids);

    Clue getone(String id);

    void update(Clue clue);

}
