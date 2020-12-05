package com.yang.mapper;

import com.yang.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    void deleteBeiZhu(String[] ids);

    List<ClueRemark> get(String clueId);

    void save(ClueRemark clueRemark);

    void update(ClueRemark clueRemark);

    void delete(String id);
}
