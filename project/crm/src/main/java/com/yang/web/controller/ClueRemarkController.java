package com.yang.web.controller;

import com.yang.domain.Activity;
import com.yang.domain.ClueRemark;
import com.yang.service.ClueRemarkService;
import com.yang.utils.HandleFlag;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("clueremark")
public class ClueRemarkController {
    @Resource
    private ClueRemarkService clueRemarkService;

    @GetMapping("{clueId}")
    @ResponseBody
    public List<ClueRemark> get(@PathVariable("clueId") String clueId) {
        return clueRemarkService.get(clueId);
    }

    @DeleteMapping("{id}")
    @ResponseBody
    public Map delete(@PathVariable("id") String id) {
        System.out.println(id);
        ;
        clueRemarkService.delete(id);
        return HandleFlag.successTrue();
    }

    @PostMapping
    @ResponseBody
    public Map save(ClueRemark clueRemark, HttpSession session) {
        clueRemarkService.save(clueRemark, session);
        return HandleFlag.successTrue();
    }

    @PutMapping
    @ResponseBody
    public Map update(ClueRemark clueRemark, HttpSession session) {
        clueRemarkService.update(clueRemark, session);
        return HandleFlag.successTrue();
    }
}
