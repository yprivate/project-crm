package com.yang.service;

import com.yang.domain.DictionaryValue;

import java.util.List;

public interface DictionaryValueService {
    List<DictionaryValue> getAll();

    String getSuggestOrderNo(String code);

    void saveadd(DictionaryValue dictionaryValue);

    void delete(String[] ids);

    DictionaryValue getedit(String id);

    void updateEdit(DictionaryValue dictionaryValue);

    List<DictionaryValue> getunder(String typeCode);
}
