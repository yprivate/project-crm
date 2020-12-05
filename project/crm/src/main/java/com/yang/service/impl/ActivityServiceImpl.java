package com.yang.service.impl;

import com.yang.domain.Activity;
import com.yang.domain.Page;
import com.yang.domain.User;
import com.yang.mapper.ActivityMapper;
import com.yang.service.ActivityService;
import com.yang.utils.DateTimeUtil;
import com.yang.utils.UUIDUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityMapper activityMapper;

    @Override
    public void getPage(Page page) {
        System.out.println(page.getSearchMap());
        //1. 查询总记录数
        Integer totalRows = activityMapper.getcount(page.getSearchMap());
        //2. 计算总页数：  (总记录数 - 1) / 每页条数 + 1
        Integer totalPages = (totalRows - 1) / page.getRowsPerPage() + 1;
        // 计算起始索引
        Integer startIndex = (page.getCurrentPage() - 1) * page.getRowsPerPage();
        //根据索引查询
        List<Activity> list = activityMapper.getAll(startIndex, page.getRowsPerPage(),page.getSearchMap());
        page.setTotalRows(totalRows);
        page.setTotalPages(totalPages);
        page.setData(list);
    }

    @Override
    public void save(Activity activity, HttpSession session) {
        // 生成id、创建人、创建时间
        activity.setId(UUIDUtil.getUUID());
        User user = (User)session.getAttribute("user");
        activity.setCreateBy(user.getLoginAct()+"-"+user.getName());
        activity.setCreateTime(DateTimeUtil.getSysTime());

        activityMapper.save(activity);
    }

    @Override
    public void delete(String[] ids) {
        activityMapper.delete(ids);
    }

    @Override
    public Activity getone(String id) {
        return activityMapper.getone(id);

    }

    @Override
    public void update(Activity activity, HttpSession session) {
        User user = (User)session.getAttribute("user");
        activity.setEditBy(user.getLoginAct()+"-"+user.getName());
        activity.setEditTime(DateTimeUtil.getSysTime());
        activityMapper.update(activity);
    }

    @Override
    public List<Activity> getexport() {

        return activityMapper.getexport();
    }

    @Override
    public void saveList(List<Activity> data) {
        activityMapper.saveList(data);
    }

    @Override
    public List<Activity> getAll() {
        return activityMapper.getexport();
    }
}
