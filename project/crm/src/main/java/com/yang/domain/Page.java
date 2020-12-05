package com.yang.domain;

import java.io.Serializable;
import java.util.List;
import java.util.Map;
// 分页对象：用于描述分页插件
/**
 * 条件：页码和每页条数
 * 计算：
 *  1. 查询总记录数
 *  2. 计算总页数：  (总记录数 - 1) / 每页条数 + 1
 *  3. 查询当前页数据：
 select * from 表名 limit 0,  每页条数    #第1页
 select * from 表名 limit 5,  每页条数    #第2页
 select * from 表名 limit 10, 每页条数    #第3页
 ...
 select * from 表名 limit (n-1) * 每页条数, 每页条数    #第n页
 */
public class Page implements Serializable {
    private Integer currentPage = 1;            // 页码
    private Integer rowsPerPage = 10;           // 每页显示的记录条数
    private Integer maxRowsPerPage = 100;       // 每页最多显示的记录条数
    private Integer totalPages;                 // 总页数
    private Integer totalRows;                  // 总记录数
    private Integer visiblePageLinks = 10;      // 分页卡片数
    private List data;                          // 部门的当前页数据

     // 查询条件
    private Map<String,Object> searchMap;

    public Map<String, Object> getSearchMap() {
        return searchMap;
    }

    public void setSearchMap(Map<String, Object> searchMap) {
        this.searchMap = searchMap;
    }

    public Integer getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(Integer currentPage) {
        this.currentPage = currentPage;
    }

    public Integer getRowsPerPage() {
        return rowsPerPage;
    }

    public void setRowsPerPage(Integer rowsPerPage) {
        this.rowsPerPage = rowsPerPage;
    }

    public Integer getMaxRowsPerPage() {
        return maxRowsPerPage;
    }

    public void setMaxRowsPerPage(Integer maxRowsPerPage) {
        this.maxRowsPerPage = maxRowsPerPage;
    }

    public Integer getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(Integer totalPages) {
        this.totalPages = totalPages;
    }

    public Integer getTotalRows() {
        return totalRows;
    }

    public void setTotalRows(Integer totalRows) {
        this.totalRows = totalRows;
    }

    public Integer getVisiblePageLinks() {
        return visiblePageLinks;
    }

    public void setVisiblePageLinks(Integer visiblePageLinks) {
        this.visiblePageLinks = visiblePageLinks;
    }

    public List getData() {
        return data;
    }

    public void setData(List data) {
        this.data = data;
    }
}
