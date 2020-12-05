jQuery.fn.extend({
    pager: function(page, callback) {
        this.bs_pagination({
            currentPage: page.currentPage,          // 页码
            rowsPerPage: page.rowsPerPage,          // 每页显示的记录条数
            maxRowsPerPage: page.maxRowsPerPage,    // 每页最多显示的记录条数
            totalPages: page.totalPages,            // 总页数
            totalRows: page.totalRows,              // 总记录数
            visiblePageLinks: page.visiblePageLinks,// 显示几个卡片
            onChangePage: function (event, data) {
                callback(data.currentPage, data.rowsPerPage);
            }
        });
        return this;
    }
});