package com.yang.web.controller;

import com.yang.domain.Clue;
import com.yang.domain.Page;
import com.yang.service.ClueService;
import com.yang.utils.HandleFlag;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.Map;

@Controller
@RequestMapping("clue")
public class ClueController {
    @Resource
    private ClueService clueService;

    @RequestMapping("getPage.json")
    @ResponseBody
    public Page getPage(Page page){
        clueService.getPage(page);
        return page;
    }

    @PostMapping
    @ResponseBody
    public Map save(Clue clue, HttpSession session){
        clueService.save(clue,session);
        return HandleFlag.successTrue();
    }


    @DeleteMapping("{ids}")
    @ResponseBody
    public Map delete(@PathVariable("ids") String[] ids){
        clueService.delete(ids);
        return HandleFlag.successTrue();
    }

    //查询一个
    @GetMapping("{id}")
    @ResponseBody
    public Clue getone(@PathVariable("id") String id){
        return clueService.getone(id);
    }

    //修改
    @PutMapping
    @ResponseBody
    public Map update(Clue clue,HttpSession session) {
        clueService.update(clue,session);
        return HandleFlag.successTrue();
    }

}
