package com.yang.web.controller;

import com.yang.domain.Activity;
import com.yang.domain.Page;
import com.yang.domain.User;
import com.yang.service.ActivityService;
import com.yang.utils.CommonUtils;
import com.yang.utils.HandleFlag;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("act")
public class ActivityController {
    @Resource
    private ActivityService activityService;

    @RequestMapping("getPage.json")
    @ResponseBody
    public Page getPage(Page page){
        activityService.getPage(page);
        return page;
    }

    @RequestMapping("save.do")
    @ResponseBody
    public Map save(Activity activity, HttpSession session){
        activityService.save(activity,session);
        return HandleFlag.successTrue();
    }

    @RequestMapping("delete.do")
    @ResponseBody
    public Map delete(String[] ids){
        activityService.delete(ids);
        return HandleFlag.successTrue();
    }

    @RequestMapping("getone.json")
    @ResponseBody
    public Activity getone(String id){
        return activityService.getone(id);
    }

    @RequestMapping("update.do")
    @ResponseBody
    public Map update(Activity activity ,HttpSession session){
        System.out.println(activity);
        activityService.update(activity,session);
        return HandleFlag.successTrue();
    }

    //导出
    @RequestMapping("export.do")
    @ResponseBody
    public void getexport(HttpServletResponse response) throws IOException {
        List<Activity> activities = activityService.getexport();
        // 创建excel文档对象
        HSSFWorkbook sheets = new HSSFWorkbook();
        // 创建一个页签
        HSSFSheet sheet = sheets.createSheet();

        int rownum=0;
        // 创建一行胡（标题）
        HSSFRow row = sheet.createRow(rownum++);
        int i = 0;
        row.createCell(i++).setCellValue("市场活动的所有者");
        row.createCell(i++).setCellValue("活动名称");
        row.createCell(i++).setCellValue("开始日期");
        row.createCell(i++).setCellValue("结束日期");
        row.createCell(i++).setCellValue("预计成本");
        row.createCell(i++).setCellValue("描述");
        row.createCell(i++).setCellValue("市场活动创建人");

        for (Activity activity : activities) {
            row = sheet.createRow(rownum++);
            i = 0;
            row.createCell(i++).setCellValue(activity.getOwner());
            row.createCell(i++).setCellValue(activity.getName());
            row.createCell(i++).setCellValue(activity.getStartDate());
            row.createCell(i++).setCellValue(activity.getEndDate());
            row.createCell(i++).setCellValue(activity.getCost());
            row.createCell(i++).setCellValue(activity.getDescription());
            row.createCell(i++).setCellValue(activity.getCreateBy());
        }
        String filename = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        response.setHeader("Content-Disposition","attachment;filename=" + filename + ".xls");
        // 将Excel文件写到客户端(下载！)
        sheets.write(response.getOutputStream());
    }

    @RequestMapping("import.do")
    @ResponseBody
    public Map importFile(MultipartFile file, HttpSession session) throws Exception {
        // 上传的Excel文件
        HSSFWorkbook workbook = new HSSFWorkbook(file.getInputStream());
        // 获取第1页签
        HSSFSheet sheet = workbook.getSheetAt(0);

        List<Activity> data = new ArrayList<>();
        // 获取数据行（除了标题行）
        int i = 1;
        User user = (User)session.getAttribute("user");
        for (;;) {
            HSSFRow row = sheet.getRow(i++);
            if ( row == null ) break;
            int j = 0;

            String owner = row.getCell(j++).getStringCellValue();
            String name = row.getCell(j++).getStringCellValue();
            String startDate = row.getCell(j++).getStringCellValue();
            String endDate = row.getCell(j++).getStringCellValue();
            String cost = row.getCell(j++).getStringCellValue();
            String description = row.getCell(j++).getStringCellValue();
            String createBy = row.getCell(j++).getStringCellValue();

            Activity activity = new Activity();
            CommonUtils.initEntity(activity, session);

            activity.setOwner(owner);
            activity.setName(name);
            activity.setStartDate(startDate);
            activity.setEndDate(endDate);
            activity.setEndDate(createBy);
            if (!"".equals(cost)) {
                activity.setCost(cost);
            }

            activity.setDescription(description);

            data.add(activity);

        }
        activityService.saveList(data);

        return HandleFlag.successTrue();
    }

    @GetMapping
    @ResponseBody
    public List<Activity> getAll(){
        return activityService.getAll();
    }


}
