package com.yang.service.impl;

import com.yang.domain.DictionaryValue;
import com.yang.mapper.DictionaryValueMapper;
import com.yang.service.DictionaryValueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DictionaryValueServiceImpl implements DictionaryValueService {
    @Resource
    private DictionaryValueMapper dictionaryValueMapper;

    @Override
    public List<DictionaryValue> getAll() {
        return dictionaryValueMapper.getAll();
    }

    @Override
    public String getSuggestOrderNo(String code) {
        return dictionaryValueMapper.getSuggestOrderNo(code);
    }

    @Override
    public void saveadd(DictionaryValue dictionaryValue) {
        dictionaryValueMapper.saveadd(dictionaryValue);
    }

    @Override
    public void delete(String[] ids) {
        dictionaryValueMapper.delete(ids);
    }

    @Override
    public DictionaryValue getedit(String id) {
        return dictionaryValueMapper.getedit(id);
    }

    @Override
    public void updateEdit(DictionaryValue dictionaryValue) {
        System.out.println(dictionaryValue);
        dictionaryValueMapper.updateEdit(dictionaryValue);
    }

    @Override
    public List<DictionaryValue> getunder(String typeCode) {
        if(typeCode==null || "".equals(typeCode)){
            return dictionaryValueMapper.getAll();
        }
        return dictionaryValueMapper.getunder(typeCode);
    }
}
