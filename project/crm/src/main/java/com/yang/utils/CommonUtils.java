package com.yang.utils;

import com.yang.domain.User;
import org.apache.commons.beanutils.BeanUtils;


import javax.servlet.http.HttpSession;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class CommonUtils {
    public static void initEntity(Object object, HttpSession session) {
        try {
            BeanUtils.setProperty(object, "id", UUIDUtil.getUUID());
            User user = (User) session.getAttribute("user");
            BeanUtils.setProperty(object, "createBy", user.getLoginAct()+"|"+user.getName());
            BeanUtils.setProperty(object, "createTime", DateTimeUtil.getSysTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
        /*Class clazz = object.getClass();
        try {
            Method method = clazz.getMethod("setId", String.class);
            method.invoke(object, UUIDUtil.getUUID());

            User user = (User) session.getAttribute("user");
            method = clazz.getMethod("setCreateBy", String.class);
            method.invoke(object, user.getLoginAct()+"|"+user.getName());

            method = clazz.getMethod("setCreateTime", String.class);
            method.invoke(object, DateTimeUtil.getSysTime());
        } catch (Exception e) {
            e.printStackTrace();
        }*/
    }

    public static void initEntity(Object object, String createBy) {
        try {
            BeanUtils.setProperty(object, "id", UUIDUtil.getUUID());
            BeanUtils.setProperty(object, "createBy", createBy);
            BeanUtils.setProperty(object, "createTime", DateTimeUtil.getSysTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void editEntity(Object object, HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");
            BeanUtils.setProperty(object, "editBy", user.getLoginAct()+"|"+user.getName());
            BeanUtils.setProperty(object, "editTime", DateTimeUtil.getSysTime());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
