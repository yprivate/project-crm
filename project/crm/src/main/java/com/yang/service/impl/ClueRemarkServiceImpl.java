package com.yang.service.impl;

import com.yang.domain.ClueRemark;
import com.yang.domain.User;
import com.yang.mapper.ClueRemarkMapper;
import com.yang.service.ClueRemarkService;
import com.yang.utils.DateTimeUtil;
import com.yang.utils.UUIDUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Resource
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> get(String clueId) {
        return clueRemarkMapper.get(clueId);
    }

    @Override
    public void save(ClueRemark clueRemark, HttpSession session) {
        clueRemark.setId(UUIDUtil.getUUID());
        User user = (User) session.getAttribute("user");
        clueRemark.setNotePerson(user.getLoginAct()+"-"+user.getName());
        clueRemark.setNoteTime(DateTimeUtil.getSysTime());
        clueRemark.setEditFlag("0");
        System.out.println(clueRemark);
        clueRemarkMapper.save(clueRemark);
    }

    @Override
    public void update(ClueRemark clueRemark, HttpSession session) {
        User user = (User) session.getAttribute("user");
        clueRemark.setEditFlag("1");
        clueRemark.setEditPerson(user.getLoginAct()+"-"+user.getName());
        clueRemark.setEditTime(DateTimeUtil.getSysTime());
        clueRemarkMapper.update(clueRemark);
    }

    @Override
    public void delete(String id) {
        clueRemarkMapper.delete(id);
    }
}
