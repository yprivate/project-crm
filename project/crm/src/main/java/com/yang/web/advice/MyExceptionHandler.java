package com.yang.web.advice;

import com.yang.exception.LoginException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class MyExceptionHandler {
    // 针对 LoginException 异常的处理
    @ExceptionHandler(LoginException.class)
    @ResponseBody
    public Map loginExceptionHandler(Exception e) {
        e.printStackTrace();
        Map map = new HashMap();
        map.put("success", false);
        map.put("msg", e.getMessage());
        return map;
    }

    // 针对 Exception 异常的处理
    @ExceptionHandler(Exception.class)
    public String exceptionHandler(Exception e) {
        e.printStackTrace();
        return "500";
    }
}
