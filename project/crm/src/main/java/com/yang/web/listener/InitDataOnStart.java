package com.yang.web.listener;

import com.yang.domain.DictionaryValue;
import com.yang.service.DictionaryValueService;
import org.springframework.beans.factory.BeanFactory;
import org.springframework.web.context.ContextLoader;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebListener
public class InitDataOnStart implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        BeanFactory beanFactory = ContextLoader.getCurrentWebApplicationContext();
        DictionaryValueService bean = beanFactory.getBean(DictionaryValueService.class);
        // 所有的字典值
        List<DictionaryValue> list = bean.getAll();
            /*将这些字典值根据字典类型处理成多个集合：
            例如：包含2个字典类型，就处理成2个集合
            1	先生	先生	1	        appellation
            2	夫人	夫人	2	        appellation
            3	女士	女士	3	        appellation
            4	虚假线索	虚假线索	4	clueState
            5	将来联系	将来联系	2	clueState
            6	丢失线索	丢失线索	5	clueState
            */

        Map<String,List<DictionaryValue>> map = new HashMap<>();

        for (DictionaryValue dictionaryValue : list) {

            List<DictionaryValue> values = map.get(dictionaryValue.getTypeCode());

            if(values==null){
                values = new ArrayList<>();
                map.put(dictionaryValue.getTypeCode(),values);
            }
            values.add(dictionaryValue);
        }
        sce.getServletContext().setAttribute("dicMap",map);
    }
}
