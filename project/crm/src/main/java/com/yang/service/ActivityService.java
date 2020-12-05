package com.yang.service;

import com.yang.domain.Activity;
import com.yang.domain.Page;

import javax.servlet.http.HttpSession;
import java.util.List;

public interface ActivityService {
    void getPage(Page page);

    void save(Activity activity, HttpSession session);

    void delete(String[] ids);

    Activity getone(String id);

    void update(Activity activity, HttpSession session);

    List<Activity> getexport();

    void saveList(List<Activity> data);

    List<Activity> getAll();
}
