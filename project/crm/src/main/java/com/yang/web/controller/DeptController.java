package com.yang.web.controller;

import com.yang.domain.Dept;
import com.yang.domain.Page;
import com.yang.service.DeptService;
import com.yang.utils.HandleFlag;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("dept")
public class DeptController {
    @Resource
    private DeptService deptService;

    @RequestMapping("getPage.json")
    @ResponseBody
    public Page getPage(Page page) {
        deptService.getPage(page);
        return page;
    }

    @RequestMapping("delete.do")
    @ResponseBody
    public Map deleteBtn(String[] ids){
        deptService.deleteBtn(ids);
        return HandleFlag.successTrue();
    }

    @RequestMapping("getExists.json")
    @ResponseBody
    public boolean getExists(String no){
        return deptService.getExists(no);
    }

    @RequestMapping("save.do")
    @ResponseBody
    public Map save(Dept dept){
        deptService.addsave(dept);
        return HandleFlag.successTrue();
    }

    @RequestMapping("getOne.json")
    @ResponseBody
    public Dept getOne(String id){
        return deptService.getOne(id);
    }

    @RequestMapping("updateadd.do")
    @ResponseBody       //修改
    public Map updateadd(Dept dept1){
        System.out.println(dept1.getDescription());
        System.out.println(dept1.getManager());
        deptService.updateadd(dept1);
        return HandleFlag.successTrue();
    }

    @RequestMapping("getAll.json")
    @ResponseBody
    public List getAll(){
        List dept = deptService.getAll();
        return dept;
    }
}
