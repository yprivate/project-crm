package Test;

import com.yang.domain.Dept;
import com.yang.mapper.DeptMapper;
import com.yang.utils.UUIDUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import javax.annotation.Resource;

@ContextConfiguration("classpath:applicationContext.xml")//指定配置文件的所在路径
@RunWith(SpringJUnit4ClassRunner.class) // 指定使用spring编写的增强的junit类运行代码
public class Test {

    @Resource
    private DeptMapper deptService;

    @org.junit.Test
    public void test01(){
        for (int i = 0; i < 250; i++) {
            Dept dept = new Dept();
            dept.setId(UUIDUtil.getUUID());
            dept.setNo("0"+(i+1));
            dept.setName("部门"+(i+1));
            dept.setManager("xxx"+(i+1));
            dept.setPhone("电话号码"+(i+1));
            dept.setDescription("desc" + i);
            deptService.addsave(dept);
        }
    }

@org.junit.Test
public void test() {
        int ob=1;
    int a = 10;
    System.out.println(a++ + a--);
}
}
