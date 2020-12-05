package com.yang.service.impl;

import com.yang.domain.DictionaryType;
import com.yang.mapper.DictionaryTypeMapper;
import com.yang.service.DictionaryTypeService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class DictionaryTypeServiceImpl implements DictionaryTypeService {
    @Resource
    private DictionaryTypeMapper dictionaryTypeMapper;
    @Override
    public List<DictionaryType> getAll() {
        return dictionaryTypeMapper.getAll();
    }

    @Override
    public boolean getExists(String code) {
        return dictionaryTypeMapper.getExists(code);
    }

    @Override
    public void saveadd(DictionaryType dictionaryType) {
        dictionaryTypeMapper.saveadd(dictionaryType);
    }

    @Override
    public void delete(String[] args) {
        dictionaryTypeMapper.delete(args);
    }

    @Override
    public DictionaryType getedit(String code) {
        return dictionaryTypeMapper.getedit(code);
    }

    @Override
    public void updateEdit(DictionaryType dictionaryType) {
        dictionaryTypeMapper.updateEdit(dictionaryType);
    }
}
