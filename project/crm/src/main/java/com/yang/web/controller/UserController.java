package com.yang.web.controller;


import com.yang.domain.Page;
import com.yang.domain.User;
import com.yang.service.UserService;
import com.yang.utils.HandleFlag;
import com.yang.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("user")
public class UserController {
    @Resource
    private UserService userService;

    //登录
    @RequestMapping("login.do")
    @ResponseBody
    public Map login(String username, String password, boolean autoLogin, HttpServletRequest request, HttpServletResponse response) {
        String ip = request.getRemoteAddr();
        User user = userService.login(username, password, ip);
        if (autoLogin) {
            password = MD5Util.getMD5(password);
            Cookie c1 = new Cookie("username", username);
            c1.setMaxAge(60 * 60 * 24 * 10);
            //将cookie保存的路径改变为"/"路径
            c1.setPath("/");
            response.addCookie(c1);
            Cookie c2 = new Cookie("password", password);
            c2.setMaxAge(60 * 60 * 24 * 10);
            //将cookie保存的路径改变为"/"路径
            c2.setPath("/");
            response.addCookie(c2);
        }

        request.getSession().setAttribute("user", user);
        Map map = new HashMap();
        map.put("success", true);
        return map;
    }
    //退出
    @RequestMapping("logout.do")
    public String loginout(HttpSession session ,HttpServletResponse response){
       //清除session对象
        session.invalidate();
        //把保存的cookie的密码覆盖
        Cookie c2 = new Cookie("password",null);
        //将cookie保存的路径改变为"/"路径
        c2.setPath("/");
        response.addCookie(c2);
        return "redirect:/";
    }

    //获取所有用户名
    @RequestMapping("getAllOwner.json")
    @ResponseBody
    public List<String> getAllOwner() {
        return userService.getAllOwner();
    }

    //根据条件获取所有用户
    @RequestMapping("getAll.json")
    @ResponseBody
    public Page getAll(Page page){
        userService.getAll(page);
        return page;
    }

    @RequestMapping("saveadd.do")
    @ResponseBody
    public Map saveadd(User user,HttpSession session){
        userService.saveadd(user,session);
        return HandleFlag.successTrue();
    }

    @RequestMapping("delete.do")
    @ResponseBody
    public Map delete(String[] ids){
        userService.delete(ids);
        return HandleFlag.successTrue();
    }
}
