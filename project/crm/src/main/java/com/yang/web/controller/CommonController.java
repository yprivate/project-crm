package com.yang.web.controller;

import com.yang.domain.User;
import com.yang.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class CommonController {
    @Resource
    private UserService userService;

    @RequestMapping("/**/*.html")
    public String page(HttpServletRequest request) {
        String url = request.getRequestURI();
        String viewName = url.substring(1, url.lastIndexOf("."));
        return viewName;
    }

    @RequestMapping({"/","index.jsp","/login.html"})
    public String autoLogin(@CookieValue(value = "username", required = false) String username, HttpServletRequest request,
                            @CookieValue(value = "password", required = false) String password, HttpServletResponse response) {
        // 如果已经登录，直接跳转到首页
        if (request.getSession().getAttribute("user") != null) {
            return "redirect:/workbench/index.html";
        }

        if (username != null && !"".equals(username) && password != null && !"".equals(password)) {
            String ip = request.getRemoteAddr();
            User user = userService.autoLogin(username, password, ip);
            if (user != null) {
                request.getSession().setAttribute("user", user);
                return "redirect:/workbench/index.html";
            }
        }
        return "login";
    }
}
