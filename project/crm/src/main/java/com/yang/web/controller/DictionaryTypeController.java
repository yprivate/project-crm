package com.yang.web.controller;

import com.yang.domain.DictionaryType;
import com.yang.service.DictionaryTypeService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("type")
public class DictionaryTypeController {
    @Resource
    private DictionaryTypeService dictionaryTypeService;

    @RequestMapping("index.html")
    public ModelAndView getAll(ModelAndView mv){
        List<DictionaryType> list = dictionaryTypeService.getAll();
        mv.addObject("list",list);
        mv.setViewName("settings/dictionary/type/index");
        return mv;
    }

    @RequestMapping("getExists.json")
    @ResponseBody
    public boolean getExists(String code) {
        return dictionaryTypeService.getExists(code);
    }

    @RequestMapping("save.do")
    public String saveadd(DictionaryType dictionaryType){
        dictionaryTypeService.saveadd(dictionaryType);
        return "redirect:/type/index.html";
    }

    @RequestMapping("delete.do")
    public String delete(String[] code){
        System.out.println(code);
        dictionaryTypeService.delete(code);
        return "redirect:/type/index.html";
    }

    @RequestMapping("edit.html")
    public ModelAndView getEdit(String code){
        ModelAndView mv =new ModelAndView();
        DictionaryType type=dictionaryTypeService.getedit(code);
        mv.addObject("type",type);
        mv.setViewName("settings/dictionary/type/edit");
        return mv;
    }
    @RequestMapping("edit.do")
    public String updateEdit(DictionaryType dictionaryType){
        dictionaryTypeService.updateEdit(dictionaryType);
        return "redirect:/type/index.html";
    }
}
