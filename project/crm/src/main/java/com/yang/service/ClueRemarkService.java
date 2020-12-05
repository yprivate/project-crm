package com.yang.service;


import com.yang.domain.ClueRemark;

import javax.servlet.http.HttpSession;
import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> get(String clueId);

    void save(ClueRemark clueRemark, HttpSession session);

    void update(ClueRemark clueRemark, HttpSession session);

    void delete(String id);
}
