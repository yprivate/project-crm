package com.yang.web.controller;

import com.yang.domain.DictionaryType;
import com.yang.domain.DictionaryValue;
import com.yang.service.DictionaryTypeService;
import com.yang.service.DictionaryValueService;
import com.yang.utils.UUIDUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import java.util.List;

@Controller
@RequestMapping("value")
public class DictionaryValueController {
    @Resource
    private DictionaryValueService dictionaryValueService;
    @Resource
    private DictionaryTypeService dictionaryTypeService;

    @RequestMapping("index.html")
    public ModelAndView getAll() {
        ModelAndView mv = new ModelAndView();
        List<DictionaryValue> list = dictionaryValueService.getAll();
        mv.addObject("list", list);
        mv.setViewName("settings/dictionary/value/index");
        return mv;
    }

    //value页面字典值的查询,使用type的查询方法
    @RequestMapping("save.html")
    public ModelAndView getsave() {
        ModelAndView mv = new ModelAndView();
        List<DictionaryType> list = dictionaryTypeService.getAll();
        mv.addObject("list", list);
        mv.setViewName("settings/dictionary/value/save");
        return mv;
    }

    //ajax请求查询数字最大值
    @RequestMapping("getSuggestOrderNo.json")
    @ResponseBody
    public String getSuggestOrderNo(String code) {
        return dictionaryValueService.getSuggestOrderNo(code);
    }

    //增加
    @RequestMapping("save.do")
    public String saveAdd(DictionaryValue dictionaryValue) {
        String id = UUIDUtil.getUUID();
        dictionaryValue.setId(id);
        dictionaryValueService.saveadd(dictionaryValue);
        return "redirect:/value/index.html";
    }

    //删除
    @RequestMapping("delete.do")
    public String delete(String[] ids) {
        dictionaryValueService.delete(ids);
        return "redirect:/value/index.html";
    }

    //修改前先查询，给出初始值
    @RequestMapping("edit.html")
    public ModelAndView getEdit(String id) {
        ModelAndView mv = new ModelAndView();
        DictionaryValue value = dictionaryValueService.getedit(id);
        mv.addObject("value", value);
        mv.setViewName("settings/dictionary/value/edit");
        return mv;
    }

    //修改
    @RequestMapping("edit.do")
    public String updateEdit(DictionaryValue dictionaryValue) {
        dictionaryValueService.updateEdit(dictionaryValue);
        return "redirect:/value/index.html";
    }

    //分类显示ajax
    @RequestMapping("get.json")
    @ResponseBody
    public List<DictionaryValue> getUnder(String typeCode){
        List<DictionaryValue> list = dictionaryValueService.getunder(typeCode);
        return list;
    }
}