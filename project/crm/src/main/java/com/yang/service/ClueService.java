package com.yang.service;

import com.yang.domain.Clue;
import com.yang.domain.Page;

import javax.servlet.http.HttpSession;

public interface ClueService {
    void getPage(Page page);

    void save(Clue clue, HttpSession session);

    void delete(String[] ids);

    Clue getone(String id);

    void update(Clue clue, HttpSession session);

}
