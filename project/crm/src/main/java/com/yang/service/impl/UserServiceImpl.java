package com.yang.service.impl;

import com.yang.domain.Page;
import com.yang.domain.User;
import com.yang.exception.LoginException;
import com.yang.mapper.DeptMapper;
import com.yang.mapper.UserMapper;
import com.yang.service.UserService;
import com.yang.utils.DateTimeUtil;
import com.yang.utils.MD5Util;
import com.yang.utils.UUIDUtil;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserMapper userMapper;

    @Resource
    private DeptMapper deptMapper;

    @Override
    public User login(String username, String password, String ip) {
  /*     0、 登录时，除了要验证用户名和密码是否正确之外，还需要验证：
         1、	关于失效时间：如果失效，在页面上给出提示
         2、	是否锁定，如果处于锁定状态，在页面上给出提示
         3、	判断用户使用的电脑的IP是否在允许范围内，如果不在范围内，在页面上给出提示
         4、登录时，需要对密码进行MD5加密处理，然后再与数据库中进行比较
         5、要求使用ajax完成登录的验证，验证通过，跳转到首页。

         关于失效时间：如果失效时间为空，则表示永不失效
         关于锁定状态：0锁定  1启用
         关于允许访问的IP：为空表示不限制，多个IP使用逗号分隔
         */
        password = MD5Util.getMD5(password);
        User user = userMapper.login(username, password);
        //有没有获取到用户信息
        if (user == null) {
            throw new LoginException("用户名或密码错误!");
        }
        //获取数据库中的时间
        String expireTime = user.getExpireTime();
        //验证用户名有没有过期
        if (expireTime != null && !"".equals(expireTime)) {
            // 2999-11-11 11:11:11  2020-11-14 11:11:11
            long now = System.currentTimeMillis();
            Date expire = DateTimeUtil.parse(expireTime);
            long time = expire.getTime();
            if (now > time) {
                throw new LoginException("账号已过期！");
            }
        }
        // 0表示锁定  1表示启用
        if ("0".equals(user.getLockStatus())) {
            throw new LoginException("账号已锁定！");
        }
        // 为空时表示不限制IP，多个IP地址之间使用半角逗号隔开
        if (user.getAllowIps() != null && !"".equals(user.getAllowIps())) {
            boolean allow = false;
            String replace = user.getAllowIps().replace(".", "\\.").replace("*", "\\d+");
            String[] split = replace.split("[,，]");
            for (String s : split) {
                //trim去前后空格
                allow = ip.matches(s.trim());
                if (allow) {
                    break;
                }
            }
            if (!allow) {
                throw new LoginException("当前ip不能访问");
            }
        }
        return user;
    }

    @Override
    public User autoLogin(String username, String password, String ip) {
        User user = userMapper.autoLogin(username, password);
        //有没有获取到用户信息
        if (user == null) {
            throw new LoginException("用户已过期，请重新登录");
        }
        //获取数据库中的时间
        String expireTime = user.getExpireTime();
        //验证用户名有没有过期
        if (expireTime != null && !"".equals(expireTime)) {
            // 2999-11-11 11:11:11  2020-11-14 11:11:11
            long now = System.currentTimeMillis();
            Date expire = DateTimeUtil.parse(expireTime);
            long time = expire.getTime();
            if (now > time) {
                throw new LoginException("用户已过期，请重新登录");
            }
        }
        // 0表示锁定  1表示启用
        if ("0".equals(user.getLockStatus())) {
            throw new LoginException("用户已过期，请重新登录");
        }
        // 为空时表示不限制IP，多个IP地址之间使用半角逗号隔开
        if (user.getAllowIps() != null && !"".equals(user.getAllowIps())) {
            boolean allow = false;
            String replace = user.getAllowIps().replace(".", "\\.").replace("*", "\\d+");
            String[] split = replace.split("[,，]");
            for (String s : split) {
                //trim去前后空格
                allow = ip.matches(s.trim());
                if (allow) {
                    break;
                }
            }
            if (!allow) {
                throw new LoginException("用户已过期，请重新登录");
            }
        }
        return user;
    }

    @Override
    public List<String> getAllOwner() {
        return userMapper.getAllOwner();
    }

    @Override
    public void getAll(Page page) {
        /*  1. 查询总记录数
            2. 计算总页数：  (总记录数 - 1) / 每页条数 + 1
            3. 查询当前页数据：
         */
        //总记录数
        Integer totalRows = userMapper.getcount(page.getSearchMap());
        //总页数
        Integer totalPages= (totalRows-1)/page.getRowsPerPage()+1;
        // 计算起始索引
        Integer startIndex = (page.getCurrentPage() - 1) * page.getRowsPerPage();

        List<User> list = userMapper.getAll(startIndex,page.getRowsPerPage(),page.getSearchMap());
        page.setTotalRows(totalRows);
        page.setTotalPages(totalPages);
        page.setData(list);
    }

    @Override
    public void saveadd(User user, HttpSession session) {
        user.setId(UUIDUtil.getUUID());
        //获取当前用户信息
        User user1 =(User)session.getAttribute("user");
        user.setCreateBy(user1.getLoginAct()+"-"+user1.getName());
        user.setLoginPwd(MD5Util.getMD5(user.getLoginPwd()));
        user.setCreateTime(DateTimeUtil.getSysTime());
        userMapper.saveadd(user);
    }

    @Override
    public void delete(String[] ids) {
        userMapper.delete(ids);
    }
}
