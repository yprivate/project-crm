package com.yang.utils;

import java.util.HashMap;
import java.util.Map;

public class HandleFlag {

    /*public static Map<String,Object> handleFlag(boolean flag){

        Map<String,Object> map = new HashMap<>();
        map.put("success",flag);
        return map;

    }*/

    public static Map<String,Object> successTrue(){

        Map<String,Object> map = new HashMap<>();
        map.put("success",true);
        map.put("msg","操作成功！");
        return map;

    }

    public static Map<String,Object> successObj(String key,Object obj){

        Map<String,Object> map = new HashMap<>();
        map.put("success",true);
        map.put(key,obj);
        return map;

    }


}
