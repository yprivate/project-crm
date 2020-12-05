package com.yang.mapper;

import com.yang.domain.DictionaryType;

import java.util.List;

public interface DictionaryTypeMapper {
    List<DictionaryType> getAll();

    boolean getExists(String code);

    void saveadd(DictionaryType dictionaryType);

    void delete(String[] args);

    DictionaryType getedit(String code);

    void updateEdit(DictionaryType dictionaryType);

}
