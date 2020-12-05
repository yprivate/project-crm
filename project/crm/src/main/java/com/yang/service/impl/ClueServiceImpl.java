package com.yang.service.impl;

import com.yang.domain.Clue;
import com.yang.domain.Page;
import com.yang.domain.User;
import com.yang.mapper.ClueMapper;
import com.yang.mapper.ClueRemarkMapper;
import com.yang.service.ClueService;
import com.yang.utils.DateTimeUtil;
import com.yang.utils.UUIDUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.List;

@Service
public class ClueServiceImpl implements ClueService {
    @Resource
    private ClueMapper clueMapper;
    @Resource
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public void getPage(Page page) {
        /*1. 查询总记录数
          2. 计算总页数：  (总记录数 - 1) / 每页条数 + 1
          3. 查询当前页数据：
        */
        //总记录数
        Integer totalRows = clueMapper.getcount(page.getSearchMap());
        //每页显示的记录条数      page.getRowsPerPage()
        //总页数                totalPages
        Integer totalPages = (totalRows-1)/page.getRowsPerPage()+1;
        //计算起始索引
        Integer startIndex = (page.getCurrentPage()-1)*page.getRowsPerPage();

        List<Clue> list = clueMapper.getPage(startIndex,page.getRowsPerPage(),page.getSearchMap());
        page.setTotalRows(totalRows);
        page.setTotalPages(totalPages);
        page.setData(list);
    }

    @Override
    public void save(Clue clue, HttpSession session) {
        //获取当前登录用户
        User user =(User)session.getAttribute("user");
        //设置创建线索的用户
        clue.setCreateBy(user.getLoginAct()+"-"+user.getName());
        //设置创建时间
        clue.setCreateTime(DateTimeUtil.getSysTime());
        //设置id
        clue.setId(UUIDUtil.getUUID());
        clueMapper.save(clue);
    }

    @Override
    public void delete(String[] ids) {
        //删除信息时先删相关备注
        clueRemarkMapper.deleteBeiZhu(ids);
        clueMapper.delete(ids);
    }

    @Override
    public Clue getone(String id) {
        return clueMapper.getone(id);
    }

    @Override
    public void update(Clue clue, HttpSession session) {
        User user =(User)session.getAttribute("user");
        clue.setEditBy(user.getLoginAct()+"-"+user.getName());
        clue.setEditTime(DateTimeUtil.getSysTime());
        clueMapper.update(clue);
    }
}
