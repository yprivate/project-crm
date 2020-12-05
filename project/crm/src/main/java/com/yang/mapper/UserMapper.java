package com.yang.mapper;

import com.yang.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    User login(@Param("username") String username,
               @Param("password") String password);

    User autoLogin(@Param("username")String username,@Param("password")String password);

    List<String> getAllOwner();

    Integer getcount(@Param("searchMap") Map<String, Object> searchMap);

    List<User> getAll(@Param("startIndex") Integer startIndex,
                      @Param("rowsPerPage") Integer rowsPerPage,
                      @Param("searchMap") Map<String, Object> searchMap);

    void saveadd(User user);

    void delete(String[] ids);
}
