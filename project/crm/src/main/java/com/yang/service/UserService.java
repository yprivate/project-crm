package com.yang.service;

import com.yang.domain.Page;
import com.yang.domain.User;

import javax.servlet.http.HttpSession;
import java.util.List;

public interface UserService {
    User login(String username, String password, String ip);

    User autoLogin(String username, String password, String ip);

    List<String> getAllOwner();

    void getAll(Page page);

    void saveadd(User user, HttpSession session);

    void delete(String[] ids);
}
